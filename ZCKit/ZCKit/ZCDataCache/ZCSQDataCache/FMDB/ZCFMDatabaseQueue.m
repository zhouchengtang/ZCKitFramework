//
//  ZCFMDatabaseQueue.m
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "ZCFMDatabaseQueue.h"
#import "ZCFMDatabase.h"

/*

 Note: we call [self retain]; before using dispatch_sync, just incase
 ZCFMDatabaseQueue is released on another thread and we're in the middle of doing
 something in dispatch_sync

 */

/*
 * A key used to associate the ZCFMDatabaseQueue object with the dispatch_queue_t it uses.
 * This in turn is used for deadlock detection by seeing if inDatabase: is called on
 * the queue's dispatch queue, which should not happen and causes a deadlock.
 */
static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;

@implementation ZCFMDatabaseQueue

@synthesize path = _path;
@synthesize openFlags = _openFlags;

+ (instancetype)databaseQueueWithPath:(NSString*)aPath {

    ZCFMDatabaseQueue *q = [[self alloc] initWithPath:aPath];

    ZCFMDBAutorelease(q);

    return q;
}

+ (instancetype)databaseQueueWithPath:(NSString*)aPath flags:(int)openFlags {

    ZCFMDatabaseQueue *q = [[self alloc] initWithPath:aPath flags:openFlags];

    ZCFMDBAutorelease(q);

    return q;
}

+ (Class)databaseClass {
    return [ZCFMDatabase class];
}

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags {

    self = [super init];

    if (self != nil) {

        _db = [[[self class] databaseClass] databaseWithPath:aPath];
        ZCFMDBRetain(_db);

#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:openFlags];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            NSLog(@"Could not create database queue for path %@", aPath);
            ZCFMDBRelease(self);
            return 0x00;
        }

        _path = ZCFMDBReturnRetained(aPath);

        _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
        dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
        _openFlags = openFlags;
    }

    return self;
}

- (instancetype)initWithPath:(NSString*)aPath {

    // default flags for sqlite3_open
    return [self initWithPath:aPath flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
}

- (instancetype)init {
    return [self initWithPath:nil];
}


- (void)dealloc {

    ZCFMDBRelease(_db);
    ZCFMDBRelease(_path);

    if (_queue) {
        ZCFMDBDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    ZCFMDBRetain(self);
    dispatch_sync(_queue, ^() {
        [self->_db close];
        ZCFMDBRelease(_db);
        self->_db = 0x00;
    });
    ZCFMDBRelease(self);
}

- (ZCFMDatabase*)database {
    if (!_db) {
        _db = ZCFMDBReturnRetained([ZCFMDatabase databaseWithPath:_path]);

#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:_openFlags];
#else
        BOOL success = [db open];
#endif
        if (!success) {
            NSLog(@"ZCFMDatabaseQueue could not reopen database for path %@", _path);
            ZCFMDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }

    return _db;
}

- (void)inDatabase:(void (^)(ZCFMDatabase *db))block {
    /* Get the currently executing queue (which should probably be nil, but in theory could be another DB queue
     * and then check it against self to make sure we're not about to deadlock. */
    ZCFMDatabaseQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
    assert(currentSyncQueue != self && "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock");

    ZCFMDBRetain(self);

    dispatch_sync(_queue, ^() {

        ZCFMDatabase *db = [self database];
        block(db);

        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [ZCFMDatabaseQueue inDatabase:]");

#ifdef DEBUG
            NSSet *openSetCopy = ZCFMDBReturnAutoreleased([[db valueForKey:@"_openResultSets"] copy]);
            for (NSValue *rsInWrappedInATastyValueMeal in openSetCopy) {
                ZCFMResultSet *rs = (ZCFMResultSet *)[rsInWrappedInATastyValueMeal pointerValue];
                NSLog(@"query: '%@'", [rs query]);
            }
#endif
        }
    });

    ZCFMDBRelease(self);
}


- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(ZCFMDatabase *db, BOOL *rollback))block {
    ZCFMDBRetain(self);
    dispatch_sync(_queue, ^() {

        BOOL shouldRollback = NO;

        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }

        block([self database], &shouldRollback);

        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });

    ZCFMDBRelease(self);
}

- (void)inDeferredTransaction:(void (^)(ZCFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(ZCFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(ZCFMDatabase *db, BOOL *rollback))block {

    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    ZCFMDBRetain(self);
    dispatch_sync(_queue, ^() {

        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];

        BOOL shouldRollback = NO;

        if ([[self database] startSavePointWithName:name error:&err]) {

            block([self database], &shouldRollback);

            if (shouldRollback) {
                // We need to rollback and release this savepoint to remove it
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            [[self database] releaseSavePointWithName:name error:&err];

        }
    });
    ZCFMDBRelease(self);
    return err;
}
#endif

@end
