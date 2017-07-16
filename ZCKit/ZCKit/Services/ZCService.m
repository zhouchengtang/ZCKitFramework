//
//  ZCService.m
//  ZCKit
//
//  Created by tangzhoucheng on 2017/7/16.
//  Copyright © 2017年 zhoucheng. All rights reserved.
//

#import "ZCService.h"

@implementation ZCService

@synthesize config = _config;

-(BOOL) handle:(Protocol *)taskType task:(id<IZCTask>)task priority:(NSInteger)priority{
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IZCTask>)task{
    return NO;
}

-(BOOL) cancelHandleForSource:(id) source{
    return NO;
}

-(void) didReceiveMemoryWarning{
    
}

@end
