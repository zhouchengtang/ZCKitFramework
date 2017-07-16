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
    if([_delegate respondsToSelector:@selector(zcHttpTaskDidLoaded:)]){
        [_delegate zcHttpTaskDidLoaded:self];
    }
}

-(void) doFailError:(NSError *) error{
    if([_delegate respondsToSelector:@selector(zcHttpTask:didFailError:)]){
        [_delegate zcHttpTask:self didFailError:error];
    }
}

@end
