//
//  UITableViewCell+ZCNIB.m
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "UITableViewCell+ZCNIB.h"

@implementation UITableViewCell(ZCNIB)
/**
 *  @brief  加载同类名的nib
 *
 *  @return nib
 */
+(UINib*)nib{
    return  [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
@end
