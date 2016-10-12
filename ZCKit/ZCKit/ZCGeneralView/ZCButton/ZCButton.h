//
//  ZCButton.h
//  ZCKit
//
//  Created by zhoucheng on 16/4/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IZCAction.h"

@interface ZCButton : UIButton<IZCAction>

@property(nonatomic,retain) UIColor * backgroundColorHighlighted;
@property(nonatomic,retain) UIColor * backgroundColorDisabled;
@property(nonatomic,retain) UIColor * backgroundColorSelected;
@property(nonatomic,assign) CGFloat cornerRadius;

//css中格式:{notdom-stateTitleColorString:normal|#ff0000,highlighted|#111111;}
//状态normal，highlighted，disabled，selected
@property(nonatomic,retain) NSString * stateTitleColorString;

-(UIColor *) backgroundColorForState:(UIControlState) state;

-(void) setBackgroundColor:(UIColor *) backgroundColor forState:(UIControlState)state;

@end
