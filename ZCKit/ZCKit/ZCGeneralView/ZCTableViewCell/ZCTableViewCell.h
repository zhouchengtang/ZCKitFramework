//
//  ZCTableViewCell.h
//  vTeam
//
//  Created by tang zhoucheng on 13-6-22.
//  Copyright (c) 2013年 zhoucheng.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCDataOutletContainer.h"

@interface UITableView (ZCTableViewCell)

-(void) applyDataOutlet;

@end

@interface ZCTableViewCell : UITableViewCell

@property(nonatomic,readonly) NSString * nibNameOrNil;
@property(nonatomic,readonly) NSBundle * nibBundleOrNil;

@property(nonatomic,retain) id userInfo;
@property(nonatomic,assign) NSInteger index;

@property(nonatomic,assign) id controller;
@property(nonatomic,retain) IBOutlet ZCDataOutletContainer * dataOutletContainer;
@property(nonatomic,assign) IBOutlet id delegate;
@property(nonatomic,retain) id dataItem;
@property(nonatomic,retain) UIColor * actionColor;

- (IBAction) doAction :(id)sender;

+(id) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end

@protocol ZCTableViewCellDelegate

@optional

-(void) ZCTableViewCell:(ZCTableViewCell *) tableViewCell doAction:(id) action;

@end
