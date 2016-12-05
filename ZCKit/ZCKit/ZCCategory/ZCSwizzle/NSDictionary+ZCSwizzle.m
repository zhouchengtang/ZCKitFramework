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
        [NSObject swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(tzc_dictionaryWithObjects:forKeys:count:) class:class];
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

+ (instancetype)tzc_dictionaryWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt {
    id nObjects[cnt];
    id nKeys[cnt];
    int i=0, j=0;
    for (; i < cnt && j < cnt; i++) {
        if (objects[i] && keys[i]) {
            nObjects[j] = objects[i];
            nKeys[j] = keys[i];
            j++;
        }else{
            NSLog(@"[%@ %@] nil key or nil value", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        }
    }
    return [self tzc_dictionaryWithObjects:nObjects forKeys:nKeys count:j];
}

@end
