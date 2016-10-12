//
//  NSArray+TZCUtilities.m
//  PrivateAccountBook
//
//  Created by 唐周成 on 16/1/10.
//  Copyright © 2016年 JiaPin. All rights reserved.
//

#import "NSArray+ZCUtilities.h"
#import <objc/runtime.h>

@implementation NSArray(ZCUtilities)


@end


@implementation NSMutableArray(ZCUtilities)
#pragma mark - categoryMethod
- (NSMutableArray *)arrayMoveIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    if (sourceIndex != destinationIndex) {
        id moveData = [self objectAtIndex:sourceIndex];
        [self removeObjectAtIndex:sourceIndex];
        if (destinationIndex >= self.count) {
            [self addObject:moveData];
        }else{
            [self insertObject:moveData atIndex:destinationIndex];
        }
    }
    return self;
}

@end