//
//  UIButton+ZCBlock.h
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchedBlock)(NSInteger tag);

@interface UIButton(ZCBlock)
-(void)addActionHandler:(TouchedBlock)touchHandler;
@end
