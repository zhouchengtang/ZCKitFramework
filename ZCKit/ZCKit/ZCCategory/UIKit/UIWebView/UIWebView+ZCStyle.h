//
//  UIWebView+ZCStyle.h
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView(ZCStyle)
/**
 *  @brief  是否显示阴影
 *
 *  @param b 是否显示阴影
 */
- (void)setShadowViewHidden:(BOOL)b;

/**
 *  @brief  是否显示水平滑动指示器
 *
 *  @param b 是否显示水平滑动指示器
 */
- (void)setShowsHorizontalScrollIndicator:(BOOL)b;
/**
 *  @brief  是否显示垂直滑动指示器
 *
 *  @param b 是否显示垂直滑动指示器
 */
- (void)setShowsVerticalScrollIndicator:(BOOL)b;

/**
 *  @brief  网页透明
 */
-(void) makeTransparent;
/**
 *  @brief  网页透明移除+阴影
 */
-(void) makeTransparentAndRemoveShadow;

@end
