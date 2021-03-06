//
//  ZCPContext.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ZCKit/IZCContext.h>
#import <ZCKit/IZCAuthContext.h>
#import <ZCKit/IZCServiceContext.h>
#import <ZCKit/IZCUIViewController.h>

@interface ZCPContext : NSObject<IZCContext, IZCAuthContext, IZCServiceContext>

+ (ZCPContext *)sharedInstance;

@property(nonatomic, strong ,readonly) id config;

@property(nonatomic, strong)id rootViewController;

- (void)loadConfig:(id)config bundle:(NSBundle *) bundle;

+ (NSURL *)removeSchemeWithURL:(NSURL *)url;

@end
