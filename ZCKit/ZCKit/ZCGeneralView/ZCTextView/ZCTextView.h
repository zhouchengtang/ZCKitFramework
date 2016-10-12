//
//  AKTextView.h
//  AKBiOSProject
//
//  Created by zhoucheng on 16/4/27.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCTextView : UITextView

@property(nonatomic,retain) NSString * placeholder;
@property(nonatomic,assign) NSUInteger maxLength;

@end
