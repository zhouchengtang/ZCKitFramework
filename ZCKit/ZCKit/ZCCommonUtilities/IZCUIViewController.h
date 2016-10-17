//
//  IZCUIViewController.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void ( ^ ZCViewConrollerCallback )(id resultsData,id sender);

@protocol IZCUIViewController <NSObject>

@property(nonatomic,weak) id parentController;
@property(nonatomic,readonly) id topController;
@property(nonatomic,readonly) BOOL isDisplaced;
@property(nonatomic,strong) id config;
@property(nonatomic,strong) NSString * alias;
@property(nonatomic,strong) NSURL * url;
@property(nonatomic,strong) NSString * scheme;
@property(nonatomic,strong) id parameterObject;
@property(nonatomic, copy) ZCViewConrollerCallback viewControllerCallback;
@property(nonatomic, copy) ZCViewConrollerCallback viewControllerURLResultsCallback;

/*
 url 规则
 scheme如果需要进行相应才做则需要进行指定(root,push,present,pop)
 root root://target?key=value&key1=value1为程序的根视图
 push push://target?key=value&key1=value1
 pop  返回上一级为".",返回某一级为pop://push路径 返回root为pop://root
 present present://target?key=value&key1=value1或present present://nav/target?key=value&key1=value1(如果路径中带nav则会创建带NavigationController的VC再present)
 */

-(BOOL) canOpenUrl:(NSURL *) url;

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated;

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated object:(id)object;

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated callback:(ZCViewConrollerCallback)callback;

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated object:(id)object callback:(ZCViewConrollerCallback)callback;

@end
