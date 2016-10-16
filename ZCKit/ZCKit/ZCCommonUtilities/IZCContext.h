//
//  IZCPContext.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZCKit/IZCUIViewController.h>

@protocol IZCContext <NSObject>

@property(nonatomic, strong)NSMutableArray * heapViewControllers;

/*
 getViewControllerForURL
 url 规则
 push scheme://target?key=value&key1=value1
 present present://target?key=value&key1=value1或present present://nav/target?key=value&key1=value1(如果路径中带nav则会创建带NavigationController的VC再present)
 */
- (id) getViewControllerForURL:(NSURL *) url;

//- (id) getViewControllerForURL:(NSURL *) url basePath:(NSString *) basePath;
/*
 getObjectForURL
 url 规则 scheme://target/?key=value&key1=value1
 object为调用方法参数
 */
- (id) getObjectForURL:(NSURL *)url object:(id)object;

- (void) sendObjectURL:(NSURL *)url object:(id)object callback:(ZCViewConrollerCallback)callback;

- (void)finishSendObjectURLWithTarget:(id)target;

- (id) focusValueForKey:(NSString *) key;

- (void) setFocusValue:(id) value forKey:(NSString *) key;

- (id) rootViewController;

@end
