//
//  ZCButton.m
//  ZCKit
//
//  Created by zhoucheng on 16/4/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "ZCButton.h"

@interface ZCButton() {
    NSMutableDictionary * _backgroundColorForState;
}

@end

@implementation ZCButton

@synthesize actionName = _actionName;
@synthesize userInfo = _userInfo;
@synthesize actionViews = _actionViews;

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius != cornerRadius && cornerRadius > 0) {
        self.layer.cornerRadius = cornerRadius;
        [self.layer setMasksToBounds:YES];
        _cornerRadius = cornerRadius;
    }
}

-(void) _refreshBackgroundColorForState{
    
    UIColor * color = nil;
    
    if( ! [self isEnabled] ){
        color = [self backgroundColorForState:UIControlStateDisabled];
    }
    else if([self isHighlighted]){
        color = [self backgroundColorForState:UIControlStateHighlighted];
    }
    else if([self isSelected]){
        color = [self backgroundColorForState:UIControlStateSelected];
    }
    
    if(color == nil){
        color = [self backgroundColorForState:UIControlStateNormal];
    }
    
    [super setBackgroundColor:color];
}

-(void) setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self _refreshBackgroundColorForState];
}

-(void) setSelected:(BOOL)selected{
    [super setSelected: selected];
    
    [self _refreshBackgroundColorForState];
}

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    [self _refreshBackgroundColorForState];
}


-(UIColor *) backgroundColor{
    return [self backgroundColorForState:UIControlStateNormal];
}

-(void) setBackgroundColor:(UIColor *)backgroundColor{
    [self setBackgroundColor:backgroundColor forState:UIControlStateNormal];
}

-(UIColor *) backgroundColorDisabled{
    return [self backgroundColorForState:UIControlStateDisabled];
}

-(void) setBackgroundColorDisabled:(UIColor *)backgroundColorDisabled{
    [self setBackgroundColor:backgroundColorDisabled forState:UIControlStateDisabled];
}

-(UIColor *) backgroundColorHighlighted{
    return [self backgroundColorForState:UIControlStateHighlighted];
}

-(void) setBackgroundColorHighlighted:(UIColor *)backgroundColorHighlighted{
    [self setBackgroundColor:backgroundColorHighlighted forState:UIControlStateHighlighted];
}

-(UIColor *) backgroundColorSelected{
    return [self backgroundColorForState:UIControlStateSelected];
}

-(void) setBackgroundColorSelected:(UIColor *)backgroundColorSelected{
    [self setBackgroundColor:backgroundColorSelected forState:UIControlStateSelected];
}

-(UIColor *) backgroundColorForState:(UIControlState)state{
    return [_backgroundColorForState objectForKey:[NSNumber numberWithInt:state]];
}

-(void) setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    
    if(_backgroundColorForState == nil){
        _backgroundColorForState = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    if(backgroundColor){
        [_backgroundColorForState setObject:backgroundColor forKey:[NSNumber numberWithInt:state]];
    }
    else{
        [_backgroundColorForState removeObjectForKey:[NSNumber numberWithInt:state]];
    }
    
    [self _refreshBackgroundColorForState];
}

-(void)setStateTitleColorString:(NSString *)stateTitleColorString
{
    if (stateTitleColorString) {
        NSArray* stateArray = [stateTitleColorString componentsSeparatedByString:@","];
        for (int i=0; i<[stateArray count]; i++) {
            NSString* oneStateString = [stateArray objectAtIndex:i];
            NSArray* colorArray = [oneStateString componentsSeparatedByString:@"|"];
            if ([colorArray count]==2) {
                NSString* state = [colorArray objectAtIndex:0];
                NSString* colorString = [colorArray objectAtIndex:1];
                UIColor* color = [self colorWithHexString:colorString];
                if (color) {
                    if ([[state lowercaseString] isEqualToString:@"normal"]) {
                        if (i==0) {
                            [self setTitleColor:color forState:UIControlStateNormal];
                        }
                        else
                        {
                            [self setTitleColor:color forState:UIControlStateNormal];
                        }
                        
                    }
                    else if([[state lowercaseString] isEqualToString:@"highlight"]) {
                        [self setTitleColor:color forState:UIControlStateHighlighted];
                    }
                    else if([[state lowercaseString] isEqualToString:@"disabled"]) {
                        [self setTitleColor:color forState:UIControlStateDisabled];
                    }
                    else if([[state lowercaseString] isEqualToString:@"selected"]) {
                        [self setTitleColor:color forState:UIControlStateSelected];
                    }
                }
                
            }
        }
        
    }
    
}

- (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return nil;//如果非十六进制，返回nil
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6&&[cString length] != 8)//去头非十六进制，返回nil
        return nil;
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    NSString *aString = @"FF";
    if (cString.length==8) {
        range.location = 6;
        aString = [cString substringWithRange:range];
    }
    
    unsigned int r, g, b ,a;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}


@end
