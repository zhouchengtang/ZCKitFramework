//
//  UIViewController+ZCSystemBackButtonHandler.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/19.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCBackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (SystemBackButtonHandler)<ZCBackButtonHandlerProtocol>

@end
