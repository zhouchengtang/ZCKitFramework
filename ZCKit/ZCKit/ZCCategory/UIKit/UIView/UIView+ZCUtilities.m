//
//  UIView+TZCUtilities.m
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/12/11.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import "UIView+ZCUtilities.h"

@implementation UIView(ZCUtilities)

//x属性的get,set
-(void)setX:(CGFloat)x
{
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}
-(CGFloat)x
{
    return self.frame.origin.x;
}
//centerX属性的get,set
-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}
-(CGFloat)centerX
{
    return self.center.x;
}
//centerY属性的get,set
-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}
-(CGFloat)centerY
{
    return self.center.y;
}
//y属性的get,set
-(void)setY:(CGFloat)y
{
    CGRect frame=self.frame;
    frame.origin.y=y;
    self.frame=frame;
}
-(CGFloat)y
{
    return self.frame.origin.y;
}
//width属性的get,set
-(void)setWidth:(CGFloat)width
{
    CGRect frame=self.frame;
    frame.size.width=width;
    self.frame=frame;
}
-(CGFloat)width
{
    return self.frame.size.width;
}
//height属性的get,set
-(void)setHeight:(CGFloat)height
{
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;
}
-(CGFloat)height
{
    return self.frame.size.height;
}
//size属性的get,set
-(void)setSize:(CGSize)size
{
    CGRect frame=self.frame;
    frame.size.width=size.width;
    frame.size.height=size.height;
    self.frame=frame;
}
-(CGSize)size
{
    return self.frame.size;
}
//origin属性的get,set,用于设置坐标
-(void)setOrigin:(CGPoint)origin
{
    CGRect frame=self.frame;
    frame.origin.x=origin.x;
    frame.origin.y=origin.y;
    self.frame=frame;
}
-(CGPoint)origin
{
    return self.frame.origin;
}

#pragma mark - style

-(CGFloat) cornerRadius{
    return self.layer.cornerRadius;
}

-(void) setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

-(UIColor *) shadowColor{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

-(void) setShadowColor:(UIColor *)shadowColor{
    self.layer.shadowColor = [shadowColor CGColor];
}

-(float) shadowOpacity{
    return self.layer.shadowOpacity;
}

-(void) setShadowOpacity:(float)shadowOpacity{
    self.layer.shadowOpacity = shadowOpacity;
}

-(CGSize) shadowOffset{
    return self.layer.shadowOffset;
}

-(void) setShadowOffset:(CGSize)shadowOffset{
    self.layer.shadowOffset = shadowOffset;
}

-(CGFloat) shadowRadius{
    return self.layer.shadowRadius;
}

-(void) setShadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowRadius = shadowRadius;
}

-(void) setBackgroundImage:(UIImage *)backgroundImage{
    [self setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
}

-(UIImage *) backgroundImage{
    return nil;
}

-(float) borderWidth{
    return self.layer.borderWidth;
}

-(void) setBorderWidth:(float)borderWidth{
    self.layer.borderWidth = borderWidth;
}

-(UIColor *) borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void) setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = [borderColor CGColor];
}

-(NSString *) fontName{
    if([self respondsToSelector:@selector(font)]){
        return [[(UILabel *)self font] fontName];
    }
    return nil;
}

-(void) setFontName:(NSString *)fontName{
    if([self respondsToSelector:@selector(font)]){
        UIFont * f = [(UILabel *)self font];
        if(f && fontName){
            f = [UIFont fontWithName:fontName size:f.pointSize];
        }
        if([self respondsToSelector:@selector(setFont:)]){
            [(UILabel *)self setFont:f];
        }
    }
}

@end
