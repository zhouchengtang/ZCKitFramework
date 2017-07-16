//
//  ZCTask.m
//  ZCKit
//
//  Created by tangzhoucheng on 2017/7/16.
//  Copyright © 2017年 zhoucheng. All rights reserved.
//

#import "ZCTask.h"

@implementation ZCTask

@synthesize source = _source;

-(id) initWithSource:(id) source{
    if((self = [super init])){
        _source = source;
    }
    return self;
}

@end
