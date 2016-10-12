//
//  NSString+ZCUtilities.h
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/11/28.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(ZCUtilities)

-(NSString *) zcMD5String;

//判断是否是整数
- (BOOL)isPureInt;
//判断是否为浮点形：
- (BOOL)isPureFloat;

- (CGSize)ZCSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)ZCSizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (void)ZCDrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color:(UIColor *)color;

+ (NSString *)stringWithJsonObject:(id)jsonObject;

- (instancetype)toJsonObject;

- (NSString *)stringWidthPositiveFormat:(NSString *)format;

- (NSDate *)dateWithFormat:(NSString *)format;

@end
