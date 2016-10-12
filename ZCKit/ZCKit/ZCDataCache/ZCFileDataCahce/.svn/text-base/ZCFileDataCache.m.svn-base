//
//  ZCFileDataCache.m
//  JPSALEClient
//
//  Created by 唐周成 on 14-5-22.
//  Copyright (c) 2014年 唐周成. All rights reserved.
//

#import "ZCFileDataCache.h"
#import "NSData+AES256.h"

#ifdef DEBUG
#define ZCLog(...) NSLog(__VA_ARGS__)
#else
#define ZCLog(...)
#endif

//caches文件夹文件路径，一般用于存储网络下载文件
#define PATH_HOME_CACHE [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//文件缓存路径，当前使用document文件夹
#define PATH_HOME_DUCMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define JP_DATA_FILE_NAME @"zc_file_data_cache.sqlite"//客户端数据缓存JPDataCache

#define AES_KEY @"zc_file_data_cache+ase256" //ASE加密key

@interface ZCFileDataCache()

@property(nonatomic, strong)NSString * cache_path;

@end

@implementation ZCFileDataCache
{
    NSMutableDictionary * _c_cacheDict;
    dispatch_queue_t _writeDataCacheQueue;
    dispatch_queue_t _cacheDataQueue;
}

static ZCFileDataCache * fileDataCache;

+ (ZCFileDataCache  *)sharedInstance
{
    @synchronized(self)
	{
        if (fileDataCache == nil)
		{
            fileDataCache = [[self alloc] init];
        }
    }
    return fileDataCache;
}

- (dispatch_queue_t)writeDataCacheQueue{
    if (!_writeDataCacheQueue) {
        _writeDataCacheQueue = dispatch_queue_create("cachewrite_data_zcfiledatacacheueue", DISPATCH_QUEUE_SERIAL);
    }
    return _writeDataCacheQueue;
}

- (dispatch_queue_t)cacheDataQueue{
    if (!_cacheDataQueue) {
        _cacheDataQueue = dispatch_queue_create("cache_data_zcfiledatacacheueue", DISPATCH_QUEUE_SERIAL);
    }
    return _cacheDataQueue;
}

+(id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        
        if (!fileDataCache) {
            
            fileDataCache = [super allocWithZone:zone]; //确保使用同一块内存地址
        }
    }
    return fileDataCache;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self; //确保copy对象也是唯一
}

- (void)updateDataCacheDict
{
    _c_cacheDict = nil;
    [self getDataDecryptWithPath:[self cache_path]];
}

- (NSString *)cache_path
{
    if (!_cache_path) {
        _cache_path = [PATH_HOME_DUCMENT stringByAppendingPathComponent:JP_DATA_FILE_NAME];
    }
    return _cache_path;
}

- (NSMutableDictionary *)getDataDecryptWithPath:(NSString *)cachePath
{
    if (!_c_cacheDict) {
        if (self.encryption) {
            NSData * cacheData = [[NSData dataWithContentsOfFile:cachePath] AES256DecryptWithKey:AES_KEY];
            //NSData * cacheData = [NSData dataWithContentsOfFile:cachePath];
            NSMutableDictionary *cacheDict = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
            _c_cacheDict = [[NSMutableDictionary alloc] initWithDictionary:cacheDict];
        }else{
            //NSData * cacheData = [GTMBase64 decodeData:[NSData dataWithContentsOfFile:cachePath]];
            NSDictionary *cacheDict = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:cachePath]];
            _c_cacheDict = [[NSMutableDictionary alloc] initWithDictionary:cacheDict];
        }
    }
    return _c_cacheDict;
}

- (void)setDataEncryptWithPath:(NSString *)cachePath withSaveData:(NSMutableDictionary *)dict
{
    //NSData * cacheData = [NSData dataWithContentsOfFile:cachePath];
    
    if (!_c_cacheDict) {
        _c_cacheDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [_c_cacheDict setDictionary:dict];
    
    if (!self.writeDataOnlyToMemory) {
        void(^dictWirteToDiskBlock)(void) = ^{
            if (self.encryption) {
                @try {
                    NSData *cacheData = [[NSKeyedArchiver archivedDataWithRootObject:dict] AES256EncryptWithKey:AES_KEY];
                    [cacheData writeToFile:cachePath atomically:NO];
                }
                @catch (NSException *exception) {
                    NSLog(@"Caught %@%@", [exception name], [exception reason]);
                }
            }else{
                @try {
                    NSData *cacheData =  [NSKeyedArchiver archivedDataWithRootObject:dict];
                    [cacheData writeToFile:cachePath atomically:NO];
                }
                @catch (NSException *exception) {
                    NSLog(@"Caught %@%@", [exception name], [exception reason]);
                }
            }
        };
        if (self.writeDataInMainQueQue) {
            dictWirteToDiskBlock();
        }else{
            dispatch_barrier_async([self writeDataCacheQueue], ^(void) {
                dictWirteToDiskBlock();
            });
        }
    }
}

- (void)createCacheDictWithPath:(NSString *)cachePath
{
    self.writeDataInMainQueQue = YES;
    NSError * errer;
    NSMutableDictionary * cacheDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self setDataEncryptWithPath:cachePath withSaveData:cacheDict];
    if (errer!=nil) {
        ZCLog(@"%@", errer.description);
    }
    self.writeDataInMainQueQue = NO;
}

- (NSMutableDictionary *)currentDataCache
{
    NSString * cachePath = [self cache_path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [self createCacheDictWithPath:cachePath];
    }
    return [self getDataDecryptWithPath:cachePath];
}


- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    dispatch_barrier_sync([self cacheDataQueue], ^(void) {
        NSMutableDictionary * cacheDict = [NSMutableDictionary dictionaryWithDictionary:[self currentDataCache]];
        [cacheDict setObject:value forKey:defaultName];
        [self setDataEncryptWithPath:[self cache_path] withSaveData:cacheDict];
    });
}

- (void)setValue:(id)value forKey:(NSString *)defaultName
{
    [self setObject:value forKey:defaultName];
}

- (id)objectForKey:(NSString *)defaultName
{
    __block id returnValue = nil;
    dispatch_sync([self cacheDataQueue], ^(void) {
        NSMutableDictionary * cacheDict = [NSMutableDictionary dictionaryWithDictionary:[self currentDataCache]];
        if ([cacheDict objectForKey:defaultName]) {
            returnValue = [cacheDict objectForKey:defaultName];
        }else{
            returnValue =nil;
        }
    });
    return returnValue;
}

- (id)valueForKey:(NSString *)defaultName
{
    return [self objectForKey:defaultName];
}

- (void)removeObjectForKey:(NSString *)key
{
    dispatch_barrier_sync([self cacheDataQueue], ^(void) {
        NSMutableDictionary * cacheDict = [NSMutableDictionary dictionaryWithDictionary:[self currentDataCache]];
        if ([cacheDict objectForKey:key]) {
            [cacheDict removeObjectForKey:key];
            [self setDataEncryptWithPath:[self cache_path] withSaveData:cacheDict];
        }
    });
}

- (void)showContent
{
    NSMutableDictionary * cacheDict = [NSMutableDictionary dictionaryWithDictionary:[self currentDataCache]];
    ZCLog(@"%@", cacheDict);
}

- (void)setWriteDataOnlyToMemory:(BOOL)writeDataOnlyToMemory
{
    _writeDataOnlyToMemory = writeDataOnlyToMemory;
    if (!_writeDataOnlyToMemory) {
        [self updateDiskData];
    }
}

- (void)clearDataCache
{
    dispatch_barrier_sync([self cacheDataQueue], ^(void) {
        NSString * cachePath = [self cache_path];
        [self removeFileCachePath:cachePath];
        _c_cacheDict = nil;
    });
}

- (void)removeFileCachePath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

- (void)updateDiskData
{
    if (_c_cacheDict) {
        NSString * cachePath = [self cache_path];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            [self createCacheDictWithPath:cachePath];
        }
        [self setDataEncryptWithPath:cachePath withSaveData:_c_cacheDict];
    }
}


@end
