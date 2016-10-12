//
//  UIColor+TZCInoutTextColor.m
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/12/10.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import "UIColor+ZCUtilities.h"

@implementation UIColor(ZCUtilities)

- (UIColor *)colorWithAlpha:(CGFloat)alpha
{
    NSDictionary * colorDict = [UIColor getRGBDictionaryByColor:self];
    return [UIColor colorWithRed:[[colorDict objectForKey:@"R"] floatValue] green:[[colorDict objectForKey:@"G"] floatValue] blue:[[colorDict objectForKey:@"B"] floatValue] alpha:alpha];
}

+ (NSDictionary *)getRGBDictionaryByColor:(UIColor *)originColor

{
    
    CGFloat r=0,g=0,b=0,a=0;
    
    if ([originColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        
        [originColor getRed:&r green:&g blue:&b alpha:&a];
        
    }
    
    else {
        
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        
        r = components[0];
        
        g = components[1];
        
        b = components[2];
        
        a = components[3];
        
    }
    
    return @{@"R":@(r),
             
             @"G":@(g),
             
             @"B":@(b),
             
             @"A":@(a)};
    
}

@end
