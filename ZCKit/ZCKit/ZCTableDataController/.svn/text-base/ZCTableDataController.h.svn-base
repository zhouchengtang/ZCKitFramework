//
//  TZCTableDataController.h
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/12/12.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZCDragLoadingView.h"
#import "IZCAction.h"
#import "ZCTableViewCell.h"
#import "ZCDataController.h"

@class ZCTableDataController;

@protocol ZCTableDataControllerDelegate <NSObject>

@optional
- (void)ZCTableView:(UITableView *)tableView didSelectRowAtIndex:(NSIndexPath *)indexPath;
- (CGFloat)ZCTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)ZCTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)ZCTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)ZCTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)ZCTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (UITableViewCellEditingStyle)ZCTableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)ZCScrollViewDidScroll:(UIScrollView *)scrollView;

-(void) ZCTableDataController:(ZCTableDataController *) dataController cell:(ZCTableViewCell *) cell doAction:(id<IZCAction>) action;

-(void) ZCTableDataControllerScrollViewWillBeginDragging:(ZCTableDataController *) dataController;

-(void) ZCTableDataControllerScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

-(void) ZCTableDataControllerScrollVIewWillBeginDecelerating:(UIScrollView *)scrollView;

-(void) ZCTableDataControllerScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

-(void) ZCTableDataController:(ZCTableDataController *) dataController didSelectRowAtIndexPath:(NSIndexPath *) indexPath;

-(void)ZCTableDataControllerRefreshData:(ZCTableDataController *) dataController;

-(void)ZCTableDataControllerLoadMoreData:(ZCTableDataController *) dataController;

@end

@protocol ZCTableViewDataSource <NSObject>
@optional
- (UITableViewCell *)ZCTableView:(UITableView *)tableView tabeViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)ZCNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)ZCTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (BOOL)ZCTableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)ZCTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)ZCTableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (BOOL)ZCTableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ZCTableDataController : ZCDataController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) NSString * reusableCellIdentifier;
@property(nonatomic,retain) NSString * itemViewNib;
@property(nonatomic,retain) NSBundle * itemViewBundle;
@property(nonatomic,retain) IBOutlet ZCDragLoadingView * topLoadingView;
@property(nonatomic,retain) IBOutlet ZCDragLoadingView * bottomLoadingView;
@property(nonatomic,retain) IBOutlet UIView * notFoundDataView;
@property(nonatomic,retain) IBOutletCollection(UIView) NSArray * autoHiddenViews;
@property(nonatomic,retain) IBOutletCollection(UITableViewCell) NSArray * headerCells;
@property(nonatomic,retain) IBOutletCollection(UITableViewCell) NSArray * footerCells;

@property(nonatomic, strong)NSMutableArray * dataObjects;
@property(nonatomic, weak)IBOutlet id <ZCTableDataControllerDelegate> delegate;
@property(nonatomic, weak)IBOutlet id <ZCTableViewDataSource> dataSource;
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, assign)NSInteger pageSize;
@property(nonatomic, assign)BOOL hasMoreData;

@property(nonatomic, assign)CGFloat cellHeight;

@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, assign)BOOL isLoaded;

-(void)restoreTableView:(id)obj;

-(void) startLoading;

-(void) stopLoading;

-(id) dataObjectByIndexPath:(NSIndexPath *) indexPath;

-(void)reloadData;

@end
