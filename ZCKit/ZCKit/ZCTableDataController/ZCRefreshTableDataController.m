//
//  ZCRefreshTableDataController.m
//  ZCKit
//
//  Created by tangzhoucheng on 16/10/11.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ZCRefreshTableDataController.h"
#import "ZCNoMessageView.h"

@interface ZCRefreshTableDataController()

@property(nonatomic, assign)BOOL isHasContentSizeKVO;//tableView是否加入了contentSize的KVO

@end

@implementation ZCRefreshTableDataController


-(instancetype)init
{
    self = [super init];
    if (self) {
        _isHasContentSizeKVO = NO;
    }
    return self;
}

- (void)dealloc
{
    if (_isHasContentSizeKVO){
        [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    }
}

#pragma mark - tableViewSet方法时 加入tableViewContentSizeKVO 以便修正bottomLoadingView的坐标系
- (void)setTableView:(UITableView *)tableView
{
    [super setTableView:tableView];
    [self addTableViewContentSizeKVO];
}

- (void)addTableViewContentSizeKVO
{
    if (!self.isHasContentSizeKVO) {
        if (self.tableView) {
            [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            self.isHasContentSizeKVO = YES;
        }
    }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{//监测contentSize，每次contentSize改变时同时改变bottomLoadingView位置，避免位置错误
    if ([keyPath isEqualToString:@"contentSize"]) {
        dispatch_queue_t queue = dispatch_queue_create("tableView_contentSize_update_firstQueue", nil);
        NSDictionary * observeChange = [[NSDictionary alloc] initWithDictionary:change];
        dispatch_async(queue, ^(void) {
            if ([observeChange isKindOfClass:[NSDictionary class]] &&
                [keyPath isEqualToString:@"contentSize"] &&
                self.bottomLoadingView != self.tableView.tableFooterView &&
                [observeChange objectForKey:@"new"] &&
                [observeChange objectForKey:@"old"] &&
                ![[observeChange objectForKey:@"new"] isEqual:[observeChange objectForKey:@"old"]]) {
                CGSize contentSize = self.tableView.contentSize;
                if(self.bottomLoadingView && contentSize.height >= self.tableView.bounds.size.height && self.hasMoreData){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CGRect r = self.bottomLoadingView.frame;
                        r.size.width = self.tableView.bounds.size.width;
                        r.origin.y = contentSize.height;
                        [self.bottomLoadingView setFrame:r];
                        if(self.bottomLoadingView && self.bottomLoadingView.superview == nil){
                            [self.tableView addSubview:self.bottomLoadingView];
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.bottomLoadingView && self.bottomLoadingView.superview != nil) {
                            [self.bottomLoadingView removeFromSuperview];
                        }
                    });
                }
            }
        });
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [ZCLoadImageHelper loadImagesForView:cell];
        return cell;
    }else{
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AKTableViewCell"];
    }
}

- (void)topLoadingViewWithStyle:(ZCRefreshLoadingViewStyle)loadingViewStyle
{
    if (self.topLoadingView) {
        for (UIView * view in self.topLoadingView.subviews) {
            [view removeFromSuperview];
        }
        [self.topLoadingView removeFromSuperview];
        self.topLoadingView = nil;
    }
    if (loadingViewStyle != ZCRefreshLoadingViewStyle_ActivityIndicatorNone) {
        ZCDragLoadingView * topLoadingView = [[ZCDragLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 44)];
        
        topLoadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;;
        [self setTopLoadingView:topLoadingView];
        
        UIView * backgourdView = [[UIView alloc] initWithFrame:topLoadingView.frame];
        backgourdView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [backgourdView setBackgroundColor:[UIColor clearColor]];
        [topLoadingView addSubview:backgourdView];
        
        if(loadingViewStyle == ZCRefreshLoadingViewStyle_ActivityIndicatorSystem){
            
            UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,
                                                                                                               0,
                                                                                                               20,
                                                                                                               20)];
            activityView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
            activityView.hidesWhenStopped = NO;
            activityView.center = CGPointMake(backgourdView.center.x, backgourdView.center.y);
            activityView.hidden = NO;
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [backgourdView addSubview:activityView];
            [topLoadingView setLoadingView:activityView];
        }
    }
}

- (void)bottomLoadingViewWithStyle:(ZCRefreshLoadingViewStyle)loadingViewStyle
{
    if (self.bottomLoadingView) {
        for (UIView * view in self.bottomLoadingView.subviews) {
            [view removeFromSuperview];
        }
        [self.bottomLoadingView  removeFromSuperview];
        self.bottomLoadingView = nil;
    }
    if (loadingViewStyle != ZCRefreshLoadingViewStyle_ActivityIndicatorNone) {
        ZCDragLoadingView * bottomLoadingView = [[ZCDragLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 44)];
        bottomLoadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self setBottomLoadingView:bottomLoadingView];
        
        UIView * backgourdView = [[UIView alloc] initWithFrame:bottomLoadingView.frame];
        backgourdView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [backgourdView setBackgroundColor:[UIColor clearColor]];
        [bottomLoadingView addSubview:backgourdView];
        
        if(loadingViewStyle == ZCRefreshLoadingViewStyle_ActivityIndicatorSystem){
            UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,
                                                                                                               0,
                                                                                                               20,
                                                                                                               20)];
            activityView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
            activityView.hidesWhenStopped = NO;
            activityView.center = CGPointMake(backgourdView.center.x, backgourdView.center.y);
            activityView.hidden = NO;
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [backgourdView addSubview:activityView];
            [bottomLoadingView setLoadingView:activityView];
        }
        
        if(self.hasMoreData){
            
            CGSize contentSize = self.tableView.contentSize;
            
            if(self.bottomLoadingView && self.bottomLoadingView.superview == nil
               && contentSize.height >= self.tableView.bounds.size.height){
                
                CGRect r = self.bottomLoadingView.frame;
                
                r.size.width = self.tableView.bounds.size.width;
                r.origin.y = contentSize.height;
                
                [self.bottomLoadingView setFrame:r];
                [self.tableView addSubview:self.bottomLoadingView];
                
            }
            else{
                [self.bottomLoadingView removeFromSuperview];
            }
        }
        else{
            [self.bottomLoadingView removeFromSuperview];
        }
    }
}

- (void)notFoundDataWithAlertText:(NSString *)alertText imageNamed:(NSString *)imageName
{
    if (self.notFoundDataView) {
        [self.notFoundDataView removeFromSuperview];
        self.notFoundDataView = nil;
    }
    
    ZCNoMessageView * noMessageView = [[ZCNoMessageView alloc] initWithFrame:self.tableView.bounds];
    noMessageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    if (alertText && alertText.length > 0) {
        [noMessageView setShowLabelText:alertText];
    }
    if (imageName && [UIImage imageNamed:imageName]) {
        [noMessageView setShowImageNamed:imageName];
    }
    self.notFoundDataView = noMessageView;;
}


@end
