//
//  AKTextView.h
//  AKBiOSProject
//
//  Created by zhoucheng on 16/4/27.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZCKit/IZCAction.h>

@interface ZCTextView : UITextView<IZCAction>

@property(nonatomic,retain) NSString * placeholder;
@property(nonatomic,assign) NSUInteger maxLength;

@end
