//
//  IZCPServiceContext.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IZCTask.h"

@protocol IZCServiceContext <NSObject>

-(BOOL) handle:(Protocol *)taskType task:(id<IZCTask>)task priority:(NSInteger)priority;

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IZCTask>)task;

-(BOOL) cancelHandleForSource:(id) source;

@end
