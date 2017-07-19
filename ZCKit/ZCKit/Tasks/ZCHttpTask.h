//
//  ZCHttpTask.h
//  ZCKit
//
//  Created by tangzhoucheng on 2017/7/16.
//  Copyright © 2017年 zhoucheng. All rights reserved.
//

#import <ZCKit/ZCKit.h>

@protocol IZCHttpTaskDelegate

@optional
-(void) zcHttpTask:(id) httpTask didFailError:(NSError *) error;
-(void) zcHttpTaskDidLoaded:(id) httpTask;

@end

@protocol IZCHttpTask <IZCTask>

@property(strong) NSURLRequest * request;
@property(weak) id delegate;
@property(strong) id responseBody;
@property(strong) NSString * responseStr;

-(void) doFailError:(NSError *) error;
-(void) doLoaded;

@end

@interface ZCHttpTask : ZCTask<IZCHttpTask>

@end
