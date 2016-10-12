//
//  UIApplication+ZCNetworkActivityIndicator.m
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "UIApplication+ZCNetworkActivityIndicator.h"
#import <libkern/OSAtomic.h>

@implementation UIApplication(ZCNetworkActivityIndicator)

static volatile int32_t numberOfActiveNetworkConnections;

#pragma mark Public API

- (void)beganNetworkActivity
{
    self.networkActivityIndicatorVisible = OSAtomicAdd32(1, &numberOfActiveNetworkConnections) > 0;
}

- (void)endedNetworkActivity
{
    self.networkActivityIndicatorVisible = OSAtomicAdd32(-1, &numberOfActiveNetworkConnections) > 0;
}

@end
