//
//  TZCTableView.h
//  PrivateAccountBook
//
//  Created by JiaPin on 15-2-2.
//  Copyright (c) 2015年 JiaPin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCTableView : UITableView

@end

@protocol ZCTableViewDelegate <UITableViewDelegate>

@optional

-(void) tableView:(UITableView *) tableView didContentOffsetChanged:(CGPoint) contentOffset;

-(void) tableView:(UITableView *) tableView willMoveToWindow:(UIWindow *) window;

-(void) tableView:(UITableView *) tableView didMoveToWindow:(UIWindow *) window;

@end
