//
//  IZCTask.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IZCTask <NSObject>

typedef void(^ZCTaskCompletionHandler)(id data, id<IZCTask> task, NSError * error);

@property(nonatomic,weak) id source;

@property(nonatomic,copy)ZCTaskCompletionHandler completionHandler;

@end
