//
//  NSString+ZCSwizzle.m
//  SinaFinance
//
//  Created by t_zc on 16/1/14.
//  Copyright © 2016年 sina.com. All rights reserved.
//

#import "NSString+ZCSwizzle.h"
#import "NSObject+ZCSwizzle.h"
#import <objc/runtime.h>

@implementation NSString(ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef __OPTIMIZE__
        id obj = [[self alloc] init];
        Class class = [self class];
        [obj swizzleMethod:@selector(substringFromIndex:) withMethod:@selector(sf_substringFromIndex:) class:class];
        [obj swizzleMethod:@selector(substringToIndex:) withMethod:@selector(sf_substringToIndex:) class:class];
        [obj swizzleMethod:@selector(substringWithRange:) withMethod:@selector(sf_substringWithRange:) class:class];
        [obj swizzleMethod:@selector(rangeOfString:) withMethod:@selector(sf_rangeOfString:) class:class];
#endif
    });
}

- (NSRange)sf_rangeOfString:(NSString *)searchString
{
    if (searchString == nil) {
        return NSMakeRange(NSNotFound, 0);
    }
    return [self sf_rangeOfString:searchString];
}

- (NSString *)sf_substringFromIndex:(NSUInteger)from
{
    if (self.length >= from) {
        return [self sf_substringFromIndex:from];
    }    
    return nil;
}

- (NSString *)sf_substringToIndex:(NSUInteger)to
{
    if (self.length >= to) {
        return [self sf_substringToIndex:to];
    }else if (self.length > 0){
        return [self sf_substringToIndex:self.length];
    }
    return nil;
}

- (NSString *)sf_substringWithRange:(NSRange)range
{
    if (self.length >= range.location + range.length) {
        return [self sf_substringWithRange:range];
    }
    return nil;
}

@end
