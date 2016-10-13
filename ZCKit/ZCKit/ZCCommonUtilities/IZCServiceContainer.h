//
//  IZCServiceContainer.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IZCServiceContainer

@property(nonatomic,readonly) id instance;
@property(nonatomic,retain) id config;
@property(nonatomic,assign,getter=isInherit) BOOL inherit;

-(BOOL) hasTaskType:(Protocol *) taskType;

-(void) addTaskType:(Protocol *) taskType;

-(void) didReceiveMemoryWarning;

@end
