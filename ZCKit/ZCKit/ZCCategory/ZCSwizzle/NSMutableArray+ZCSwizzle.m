//
//  NSMutableArray+ZCSwizzle.m
//  SinaFinance
//
//  Created by t_zc on 16/1/14.
//  Copyright © 2016年 sina.com. All rights reserved.
//

#import "NSMutableArray+ZCSwizzle.h"
#import "NSObject+ZCSwizzle.h"
#import <objc/runtime.h>

@implementation NSMutableArray(ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef __OPTIMIZE__
        id obj = [[self alloc] init];
        Class class = NSClassFromString(@"__NSArrayM");
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(tzc_objectAtIndex:) class:class];
        [obj swizzleMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(tzc_replaceObjectAtIndex:withObject:) class:class];
        [obj swizzleMethod:@selector(addObject:) withMethod:@selector(tzc_addObject:) class:class];
        [obj swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(tzc_insertObject:atIndex:) class:class];
        [obj swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(tzc_removeObjectAtIndex:) class:class];
#endif
    });
}


#pragma mark - swizzling
- (id)tzc_objectAtIndex:(NSInteger)index
{
    if(index<[self count]){
        return [self tzc_objectAtIndex:index];
    }else{
        NSLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
    }
    return nil;
}

- (void)tzc_addObject:(id)anObject
{
    if (!anObject)
    {
        NSLog(@"[%@ %@], nil object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    [self tzc_addObject:anObject];
}

- (void)tzc_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= self.count)
    {
        NSLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        return;
    }
    
    if (!anObject)
    {
        NSLog(@"[%@ %@] nil object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    [self tzc_replaceObjectAtIndex:index withObject:anObject];
}

- (void)tzc_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (index > self.count)
    {
        NSLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        return;
    }
    
    if (!anObject)
    {
        NSLog(@"[%@ %@] nil object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    [self tzc_insertObject:anObject atIndex:index];
}

- (void)tzc_removeObjectAtIndex:(NSUInteger)index{
    if (index >= [self count]) {
        NSLog(@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]);
        return;
    }
    
    return [self tzc_removeObjectAtIndex:index];
}

@end
