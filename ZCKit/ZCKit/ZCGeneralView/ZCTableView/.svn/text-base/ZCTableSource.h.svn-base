//
//  ZCTableSource.h
//  ZCKit
//
//  Created by zhoucheng on 16/4/28.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTableSection.h"

@interface ZCTableSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) IBOutletCollection(ZCTableSection) NSArray * sections;

@property(nonatomic,assign) IBOutlet id delegate;

@end

@protocol ZCTableSourceDelegate

@optional

-(void) ZCTableSource:(ZCTableSource *) tableSource tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath;

@end