//
//  ZCHttpTask.m
//  ZCKit
//
//  Created by tangzhoucheng on 2017/7/16.
//  Copyright © 2017年 zhoucheng. All rights reserved.
//

#import "ZCHttpTask.h"

@implementation ZCHttpTask

@synthesize request = _request, delegate = _delegate, responseStr = _responseStr, responseBody = _responseBody;

- (void)doLoaded
{
    if([_delegate respondsToSelector:@selector(vtHttpTaskDidLoaded:)]){
        [_delegate vtHttpTaskDidLoaded:self];
    }
}

-(void) doFailError:(NSError *) error{
    if([_delegate respondsToSelector:@selector(vtHttpTask:didFailError:)]){
        [_delegate vtHttpTask:self didFailError:error];
    }
}

@end
