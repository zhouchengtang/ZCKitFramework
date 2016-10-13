//
//  IZCUIViewController.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IZCUIViewController <NSObject>

@property(nonatomic,assign) id parentController;
@property(nonatomic,readonly) id topController;
@property(nonatomic,readonly) BOOL isDisplaced;
@property(nonatomic,retain) id config;
@property(nonatomic,retain) NSString * alias;
@property(nonatomic,retain) NSURL * url;
@property(nonatomic,retain) NSString * scheme;

-(BOOL) canOpenUrl:(NSURL *) url;

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated;

-(NSString *) loadUrl:(NSURL *) url basePath:(NSString *) basePath animated:(BOOL) animated;


@end
