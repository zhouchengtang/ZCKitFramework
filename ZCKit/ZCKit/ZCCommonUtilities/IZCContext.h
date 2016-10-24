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

@property(nonatomic, strong, readonly)NSMutableArray * registerObjects;

- (void)removeRegisterObject:(id)object;//删除存放在heapViewControllers中的object
/*
 getViewControllerForURL
 url 规则
 scheme如果需要进行相应才做则需要进行指定(root,push,present,pop),如果不需要做相应操作则随意定制
 root root://target?key=value&key1=value1为程序的根视图
 push push://target?key=value&key1=value1
 present present://target?key=value&key1=value1或present present://nav/target?key=value&key1=value1(如果路径中带nav则会创建带NavigationController的VC再present)
 */
- (BOOL) registerObjectForURL:(NSURL *)url;

- (BOOL)resignObjectForURL:(NSURL *)url;

- (id) getViewControllerForURL:(NSURL *) url;

//- (id) getViewControllerForURL:(NSURL *) url basePath:(NSString *) basePath;
/*
 getObjectForURL与sendObjectURL方法中url的scheme避免使用(root,push,present,pop)
 url 规则 value://target/action?key=value&key1=value1
 object为调用方法参数
 */
- (id) getValueForRegisterObjectURL:(NSURL *)url object:(id)object;

- (void) sendRegisterObjectURL:(NSURL *)url object:(id)object callback:(ZCViewConrollerCallback)callback;

- (void)finishSendObjectURLWithTarget:(id)target;

- (id) focusValueForKey:(NSString *) key;

- (void) setFocusValue:(id) value forKey:(NSString *) key;

- (id) rootViewController;

@end
