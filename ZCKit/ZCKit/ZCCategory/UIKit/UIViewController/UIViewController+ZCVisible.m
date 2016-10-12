//
//  UIViewController+Visible.m
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "UIViewController+ZCVisible.h"

@implementation UIViewController(ZCVisible)

- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}

@end
