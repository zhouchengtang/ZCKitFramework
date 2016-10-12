//
//  UIScreen+ZCFrame.h
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen(ZCFrame)

+ (CGSize)size;
+ (CGFloat)width;
+ (CGFloat)height;

+ (CGSize)orientationSize;
+ (CGFloat)orientationWidth;
+ (CGFloat)orientationHeight;
+ (CGSize)DPISize;

@end
