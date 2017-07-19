//
//  ZCHttpService.m
//  ZCKit
//
//  Created by tangzhoucheng on 2017/7/16.
//  Copyright © 2017年 zhoucheng. All rights reserved.
//

#import "ZCHttpService.h"

@interface ZCHttpService()

@property(nonatomic, strong)ZC_AFHTTPSessionManager * manager;

@end

@implementation ZCHttpService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [ZC_AFHTTPSessionManager manager];
    }
    return self;
}

-(BOOL) handle:(Protocol *)taskType task:(id<IZCTask>)task priority:(NSInteger)priority{
    
    if([task conformsToProtocol:@protocol(IZCHttpTask)]){
        id<IZCHttpTask> httpTask = (id<IZCHttpTask>)task;
        [[self.manager.session dataTaskWithRequest:[httpTask request] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                [httpTask doFailError:error];
            }else{
                NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if ([jsonString toJsonObject]) {
                    httpTask.responseStr = jsonString;
                    httpTask.responseBody = [jsonString toJsonObject];
                    [httpTask doLoaded];
                }
            }
            if (httpTask.completionHandler) {
                httpTask.completionHandler(data, httpTask, error);
            }
        }] resume];

        return YES;
    }
    return NO;
}

@end
