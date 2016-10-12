//
//  ZCViewController.h
//  zTeam
//
//  Created by t_zc on 16/1/19.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTableDataController.h"
//#import "ZCDataOutletContainer.h"

typedef enum _ZCViewControllerLoadingViewStyle : NSInteger
{
    ZCViewControllerLoadingViewStyle_None = 0,
    ZCViewControllerLoadingViewStyle_System
    
}ZCViewControllerLoadingViewStyle;

@interface ZCViewController : UIViewController<ZCTableDataControllerDelegate, ZCTableViewDataSource>

@property(nonatomic, strong)IBOutlet UITableView * contentTableView;
@property(nonatomic, strong)NSMutableArray * dataObjects;
@property(nonatomic, strong)IBOutlet ZCTableDataController * tableDataController;

@property(nonatomic,retain) IBOutlet ZCDataOutletContainer * dataOutletContainer;
@property(nonatomic,retain) IBOutletCollection(id) NSArray * controllers;

- (void)showLoadingViewWithStyle:(ZCViewControllerLoadingViewStyle)loadingStyle backgroundColor:(UIColor *)backgroundColor;//显示等待页面
- (void)hiddenLoadingView;//隐藏等待页面

- (void)showAlertViewWithViewWithWaitingText:(NSString *)waitingText;//显示等待页面，定制文字
- (void)showAlertViewWithViewWithWaitingText:(NSString *)waitingText afterDelay:(NSTimeInterval)delay;//提示页面，自动消失
- (void)hiddenAlertView;

- (void)initTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)tableViewStylel;

-(void)keybordHidden:(NSNotification *)aNotification;

-(void)keybordShown:(NSNotification *)aNotification;

@end
