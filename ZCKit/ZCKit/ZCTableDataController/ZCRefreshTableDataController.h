//
//  ZCRefreshTableDataController.h
//  ZCKit
//
//  Created by tangzhoucheng on 16/10/11.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <ZCKit/ZCKit.h>

typedef enum _ZCRefreshLoadingViewStyle : NSInteger
{
    ZCRefreshLoadingViewStyle_ActivityIndicatorNone = 0,
    ZCRefreshLoadingViewStyle_ActivityIndicatorSystem
}ZCRefreshLoadingViewStyle;

@interface ZCRefreshTableDataController : ZCTableDataController

- (void)topLoadingViewWithStyle:(ZCRefreshLoadingViewStyle)loadingViewStyle;

- (void)bottomLoadingViewWithStyle:(ZCRefreshLoadingViewStyle)loadingViewStyle;

- (void)notFoundDataWithAlertText:(NSString *)alertText imageNamed:(NSString *)imageName;

@end
