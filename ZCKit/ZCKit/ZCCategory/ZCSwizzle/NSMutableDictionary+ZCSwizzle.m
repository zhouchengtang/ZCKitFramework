//
//  NSMutableDictionary+ZCSwizzle.m
//  SinaFinance
//
//  Created by t_zc on 16/1/14.
//  Copyright © 2016年 sina.com. All rights reserved.
//

#import "NSMutableDictionary+ZCSwizzle.h"
#import "NSObject+ZCSwizzle.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary(ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef __OPTIMIZE__
        id obj = [[self alloc] init];
        Class class = NSClassFromString(@"__NSDictionaryM");
        [obj swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(tzc_setObject:forKey:) class:class];
        [obj swizzleMethod:@selector(removeObjectForKey:) withMethod:@selector(tzc_removeObjectForKey:) class:class];
#endif
    });
}

#pragma mark - swizzling
- (void)tzc_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!aKey)
    {
        NSLog(@"[%@ %@] nil key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    if (!anObject)
    {
        NSLog(@"[%@ %@] nil object for key(%@).", NSStringFromClass([self class]), NSStringFromSelector(_cmd), aKey);
        return;
    }
    
    [self tzc_setObject:anObject forKey:aKey];
}

- (void)tzc_removeObjectForKey:(id)aKey{
    if (!aKey) {
        NSLog(@"[%@ %@] nil key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    [self tzc_removeObjectForKey:aKey];
}

@end
