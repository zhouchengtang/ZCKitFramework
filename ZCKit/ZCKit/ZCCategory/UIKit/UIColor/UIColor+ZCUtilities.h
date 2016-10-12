//
//  UIColor+TZCInoutTextColor.h
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/12/10.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum _UIColorInoutStyle{
    UIColorInoutStyle_None = 1,
    UIColorInoutStyle_In = 1 << 1,
    UIColorInoutStyle_Out = 1 << 2,
    UIColorInoutStyle_New_Out = 1 << 3,
    
    UIColorInoutStyle_New = 1 << 4
}UIColorInoutStyle;

@interface UIColor(ZCUtilities)

- (UIColor *)colorWithAlpha:(CGFloat)alpha;

+ (NSDictionary *)getRGBDictionaryByColor:(UIColor *)originColor;

@end
