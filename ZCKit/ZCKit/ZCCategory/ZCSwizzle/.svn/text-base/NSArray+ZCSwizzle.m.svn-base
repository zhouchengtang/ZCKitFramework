//
//  NSArray+ZCSwizzle.m
//  SinaFinance
//
//  Created by t_zc on 16/1/14.
//  Copyright © 2016年 sina.com. All rights reserved.
//

#import "NSArray+ZCSwizzle.h"
#import "NSObject+ZCSwizzle.h"
#import <objc/runtime.h>

@implementation NSArray(ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef __OPTIMIZE__
        id obj = [[self alloc] init];
        Class class = NSClassFromString(@"__NSArrayI");
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(tzc_objectAtIndex:) class:class];
        [obj swizzleMethod:@selector(arrayWithObjects:count:) withMethod:@selector(tzc_arrayWithObjects:count:) class:class];
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

+ (id)tzc_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id validObjects[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (objects[i])
        {
            validObjects[count] = objects[i];
            count++;
        }
        else
        {
            NSLog(@"[%@ %@] nil object at index {%lu}",
                  NSStringFromClass([self class]),
                  NSStringFromSelector(_cmd),
                  (unsigned long)i);
            
        }
    }
    
    return [self tzc_arrayWithObjects:validObjects count:count];
}

@end
