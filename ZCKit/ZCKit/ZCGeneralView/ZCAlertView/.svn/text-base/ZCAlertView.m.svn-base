//
//  ZCAlertView.m
//  zTeam
//
//  Created by t_zc on 16/1/19.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "ZCAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "ZCViewController.h"

@interface ZCAlertView(){
    UIWindow * _alertWindow;
}
@end

@implementation ZCAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(id) initWithTitle:(NSString *) title font:(UIFont *)font size:(CGSize) size edgeInsets:(UIEdgeInsets) edgeInsets{
    
    CGSize s = [[UIScreen mainScreen] bounds].size;
    
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    
    if(edgeInsets.left == 0){
        if(edgeInsets.right == 0){
            r.origin.x = (s.width - size.width) / 2.0;
        }
        else{
            r.origin.x = s.width - size.width - edgeInsets.right;
        }
    }
    else{
        r.origin.x = edgeInsets.left;
    }
    
    if(edgeInsets.top == 0){
        if(edgeInsets.bottom == 0){
            r.origin.y = (s.height - size.height) / 2.0;
        }
        else {
            r.origin.y = s.height - size.height - edgeInsets.bottom;
        }
    }
    else{
        r.origin.y = edgeInsets.top;
    }
    
    if((self = [super initWithFrame:r])){
        
        UIViewAutoresizing autoresizeing = UIViewAutoresizingNone;
        
        if(edgeInsets.left == 0){
            autoresizeing |= UIViewAutoresizingFlexibleLeftMargin;
        }
        
        if(edgeInsets.right == 0){
            autoresizeing |= UIViewAutoresizingFlexibleRightMargin;
        }
        
        if(edgeInsets.top == 0){
            autoresizeing |= UIViewAutoresizingFlexibleTopMargin;
        }
        
        if(edgeInsets.bottom == 0){
            autoresizeing |= UIViewAutoresizingFlexibleBottomMargin;
        }
        
        
        [self setAutoresizingMask:autoresizeing];
        
        [self.layer setCornerRadius:5];
        
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
        [self setClipsToBounds:YES];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
        [label setNumberOfLines:0];
        [label setFont:font];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [label setText:title];
        
        [self addSubview:label];
    }
    
    return self;
}

-(id) initWithTitle:(NSString *) title{
    return [self initWithTitle:title edgeInsets:UIEdgeInsetsZero];
}

-(id) initWithTitle:(NSString *) title edgeInsets:(UIEdgeInsets)edgeInsets{
    CGSize maxSize = [[UIScreen mainScreen] bounds].size;
    
    maxSize = CGSizeMake(maxSize.width - 20,maxSize.height);
    
    UIFont * font = [UIFont systemFontOfSize:14];
    
    CGSize size = [title sizeWithFont:font constrainedToSize:maxSize];
    
    return [self initWithTitle:title font:font size:CGSizeMake(size.width + 20, size.height + 10) edgeInsets:edgeInsets];
}

-(void) close{
    [_alertWindow setHidden:YES];
    _alertWindow = nil;
}

-(void) showDuration:(NSTimeInterval) duration{
    
    [self show];
    
    [self performSelector:@selector(close) withObject:nil afterDelay:duration];
    
}

-(void) show{
    if(_alertWindow == nil){
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        [_alertWindow setWindowLevel:UIWindowLevelAlert];
        [_alertWindow setBackgroundColor:[UIColor clearColor]];
        [_alertWindow setUserInteractionEnabled:NO];
        
        [_alertWindow addSubview:self];
        
        [_alertWindow setHidden:NO];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            
            ZCViewController * vc = [[ZCViewController alloc] init];
            vc.view.backgroundColor = [UIColor clearColor];
            [_alertWindow setRootViewController:vc];
        }
    }
    else{
        [_alertWindow setHidden:NO];
    }
}


@end
