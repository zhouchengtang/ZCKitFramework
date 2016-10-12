//
//  NSDictionary+ZCSwizzle.m
//  PrivateAccountBook
//
//  Created by 唐周成 on 16/1/16.
//  Copyright © 2016年 JiaPin. All rights reserved.
//

#import "NSDictionary+ZCSwizzle.h"
#import "NSObject+ZCSwizzle.h"

@implementation NSDictionary(ZCSwizzl)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef __OPTIMIZE__
        id obj = [[self alloc] init];
        Class class = NSClassFromString(@"__NSDictionaryI");
        [obj swizzleMethod:@selector(objectForKey:) withMethod:@selector(tzc_objectForKey:) class:class];
#endif
    });
}

#pragma mark - swizzling
- (id)tzc_objectForKey:(id<NSCopying>)aKey
{
    if (!aKey)
    {
        NSLog(@"[%@ %@] nil key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return nil;
    }
    return [self tzc_objectForKey:aKey];
}

@end
