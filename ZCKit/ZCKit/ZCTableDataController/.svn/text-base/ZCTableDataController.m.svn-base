//
//  ZCTableDataController.m
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/12/12.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import "ZCTableDataController.h"
#import "ZCTableViewCell.h"

#define TableView_Common_RowHeight 44

@interface ZCTableDataController(){
    BOOL _allowRefresh;
    NSDateFormatter * _dateFormatter;
    CGPoint _preContentOffset;
    BOOL _animating;
}

@property(nonatomic,readonly) NSDateFormatter * dateFormatter;

@end

@implementation ZCTableDataController

- (NSBundle *)itemViewBundle
{
    if (!_itemViewBundle) {
        _itemViewBundle = [NSBundle mainBundle];
    }
    return _itemViewBundle;
}

-(NSDateFormatter *) dateFormatter{
    if(_dateFormatter == nil){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (NSMutableArray *)dataObjects
{
    if (!_dataObjects) {
        _dataObjects = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataObjects;
}

#pragma mark - dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_dataSource respondsToSelector:@selector(ZCNumberOfSectionsInTableView:)]) {
        return [_dataSource ZCNumberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(ZCTableView:numberOfRowsInSection:)]) {
        return [_dataSource ZCTableView:tableView numberOfRowsInSection:section];
    }
    if([self.dataObjects count] >0){
        return [self.dataObjects count] + [_headerCells count] + [_footerCells count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(ZCTableView:tabeViewCell:cellForRowAtIndexPath:)]) {
        NSString * cellIdentifier = @"cellIdentifier";
        ZCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ZCTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell = (ZCTableViewCell *)[_dataSource ZCTableView:tableView tabeViewCell:cell cellForRowAtIndexPath:indexPath];
        return cell;
    }
    
    if(indexPath.row < [_headerCells count]){
        return [_headerCells objectAtIndex:indexPath.row];
    }
    
    if(indexPath.row >= [self.dataObjects count] + [_headerCells count]){
        return [_footerCells objectAtIndex:indexPath.row
                - [self.dataObjects count] - [_headerCells count]];
    }
    
    NSString * identifier = _reusableCellIdentifier;
    
    if(identifier == nil){
        identifier = self.itemViewNib;
    }
    
    if(identifier == nil){
        identifier = @"Cell";
    }
    
    NSBundle * bundle = [self itemViewBundle];
    
    if(bundle == nil){
        bundle = [NSBundle mainBundle];
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        
        cell = (UITableViewCell *) [ZCTableViewCell tableViewCellWithNibName:self.itemViewNib bundle:bundle];
        
        [cell setValue:identifier forKey:@"reuseIdentifier"];
        
        if([cell isKindOfClass:[ZCTableViewCell class]]){
            [(ZCTableViewCell *) cell setController:self];
            [(ZCTableViewCell *) cell setDelegate:self];
        }
    }
    
    id data = [self dataObjectByIndexPath:indexPath];
    
    if([cell isKindOfClass:[ZCTableViewCell class]]){
        [(ZCTableViewCell *) cell setDataItem:data];
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(ZCTableView:canMoveRowAtIndexPath:)]) {
        return [_dataSource ZCTableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(ZCTableView:canEditRowAtIndexPath:)]) {
        return [_dataSource ZCTableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(ZCTableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [_dataSource ZCTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([_dataSource respondsToSelector:@selector(ZCTableView:moveRowAtIndexPath:toIndexPath:)]) {
        [_dataSource ZCTableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(ZCTableView:heightForRowAtIndexPath:)]) {
        return [_delegate ZCTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    if(indexPath.row < [_headerCells count]){
        return [[_headerCells objectAtIndex:indexPath.row] frame].size.height;
    }
    
    if(indexPath.row >= [self.dataObjects count] + [_headerCells count]){
        return [[_footerCells objectAtIndex:indexPath.row
                 - [self.dataObjects count] - [_headerCells count]] frame].size.height;
    }
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(ZCTableView:didSelectRowAtIndex:)]) {
        [_delegate ZCTableView:tableView didSelectRowAtIndex:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(ZCTableView:viewForHeaderInSection:)]) {
        return [_delegate ZCTableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(ZCTableView:viewForFooterInSection:)]) {
        return [_delegate ZCTableView:tableView heightForFooterInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(ZCTableView:viewForHeaderInSection:)]) {
        return [_delegate ZCTableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(ZCTableView:viewForFooterInSection:)]) {
        return [_delegate ZCTableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(ZCTableView:editingStyleForRowAtIndexPath:)]) {
        return [_delegate ZCTableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - ScrollViewDelegate
-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(ZCTableDataControllerScrollVIewWillBeginDecelerating:)]) {
        [self.delegate ZCTableDataControllerScrollVIewWillBeginDecelerating:scrollView];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_delegate respondsToSelector:@selector(ZCScrollViewDidScroll:)]) {
        [_delegate ZCScrollViewDidScroll:scrollView];
    }
    if(![_topLoadingView isAnimating]
       && ![_bottomLoadingView isAnimating]
       && _bottomLoadingView.superview
       && [self hasMoreData]
       && scrollView.contentOffset.y + scrollView.frame.size.height
       > scrollView.contentSize.height + _bottomLoadingView.frame.size.height
       && ![self isLoading]){
        if ([self.delegate respondsToSelector:@selector(ZCTableDataControllerLoadMoreData:)]) {
            self.pageIndex++;
            [self.delegate performSelector:@selector(ZCTableDataControllerLoadMoreData:) withObject:self];
        }
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(ZCTableDataControllerScrollViewDidEndDecelerating:)]) {
        [self.delegate ZCTableDataControllerScrollViewDidEndDecelerating:scrollView];
    }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.delegate respondsToSelector:@selector(ZCTableDataControllerScrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate ZCTableDataControllerScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if(decelerate){
        if(![_topLoadingView isAnimating]){
            if( - (scrollView.contentInset.top + scrollView.contentOffset.y) >= _topLoadingView.frame.size.height){
                _allowRefresh = YES;
            }
            else if(_bottomLoadingView.superview
                    && [self hasMoreData]
                    && scrollView.contentOffset.y + scrollView.frame.size.height
                    > scrollView.contentSize.height + _bottomLoadingView.frame.size.height){
                if ([self.delegate respondsToSelector:@selector(ZCTableDataControllerLoadMoreData:)]) {
                    self.pageIndex++;
                    [self.delegate performSelector:@selector(ZCTableDataControllerLoadMoreData:) withObject:self];
                }
            }
        }
    }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(ZCTableDataControllerScrollViewWillBeginDragging:)]){
        [self.delegate ZCTableDataControllerScrollViewWillBeginDragging:self];
    }
}

-(void) ZCTableViewCell:(ZCTableViewCell *) tableViewCell doAction:(id) action{
    if([self.delegate respondsToSelector:@selector(ZCTableDataController:cell:doAction:)]){
        [self.delegate ZCTableDataController:self cell:tableViewCell doAction:action];
    }
}

#pragma mark - otherMethod
#pragma mark - tableViewCanNotMove
-(void)restoreTableView:(id)obj
{
    NSDictionary *dic = obj;
    NSIndexPath *desIP = [dic objectForKey:@"des"];
    NSIndexPath *srcIP = [dic objectForKey:@"src"];
    [self.tableView moveRowAtIndexPath:desIP toIndexPath:srcIP];
}

-(void) setLastUpdateDate:(NSDate *)date{
    if(date){
        
        NSDateFormatter * dateFormatter = [self dateFormatter];
        
        NSString * text = nil;
        NSDate * now = [NSDate date];
        
        int unit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents * timeComponents = [[NSCalendar currentCalendar] components:unit fromDate:date];
        NSDateComponents * nowComponents = [[NSCalendar currentCalendar] components:unit fromDate:now];
        
        if(timeComponents.year == nowComponents.year){
            if(timeComponents.month == nowComponents.month){
                if(timeComponents.day == nowComponents.day){
                    [dateFormatter setDateFormat:@"最后更新: HH:mm:ss"];
                    text = [dateFormatter stringFromDate:date];
                }
                else if(timeComponents.day +1 == nowComponents.day){
                    [dateFormatter setDateFormat:@"最后更新: 昨天 HH:mm"];
                    text = [dateFormatter stringFromDate:date];
                }
                else if(timeComponents.day -1 == nowComponents.day){
                    [dateFormatter setDateFormat:@"最后更新: 明天 HH:mm"];
                    text = [dateFormatter stringFromDate:date];
                }
                else {
                    [dateFormatter setDateFormat:@"最后更新: MM月dd日 HH:mm"];
                    text = [dateFormatter stringFromDate:date];
                }
            }
            else{
                [dateFormatter setDateFormat:@"最后更新: MM月dd日 HH:mm"];
                text = [dateFormatter stringFromDate:date];
            }
        }
        else{
            [dateFormatter setDateFormat:@"最后更新: yyyy年MM月dd日 HH:mm"];
            text = [dateFormatter stringFromDate:date];
        }
        
        [_topLoadingView.timeLabel setText:text];
        [_bottomLoadingView.timeLabel setText:text];
    }
    else{
        [_topLoadingView.timeLabel setText:@""];
        [_bottomLoadingView.timeLabel setText:@""];
    }
}

-(void) startLoading{
    
    if(_pageIndex == 1){
        
        CGRect r = _topLoadingView.frame;
        
        r.size.width = _tableView.bounds.size.width;
        r.origin.y = - r.size.height;
        
        [_topLoadingView setFrame:r];
        
        if(_topLoadingView.superview == nil){
            [_tableView addSubview:_topLoadingView];
        }
        
        if(_tableView.contentOffset.y < _topLoadingView.frame.size.height){
            
            [_tableView setContentOffset:CGPointMake(0, - r.size.height - _tableView.contentInset.top) animated:NO];
            
        }
        
        [_tableView setTableFooterView:nil];
    }
    else{
        [_tableView setTableFooterView:nil];
        [_tableView setTableFooterView:_bottomLoadingView];
    }
    
    [_topLoadingView startAnimation];
    [_bottomLoadingView startAnimation];
    
}

-(void) stopLoading{
    
    
    
    [_tableView setTableFooterView:nil];
    
    [_bottomLoadingView removeFromSuperview];
    
    [_topLoadingView stopAnimation];
    [_bottomLoadingView stopAnimation];
    
    
    
    if(_topLoadingView && _topLoadingView.superview == nil){
        
        CGRect r = _topLoadingView.frame;
        
        r.size.width = _tableView.bounds.size.width;
        r.origin.y = - r.size.height;
        
        [_topLoadingView setFrame:r];
        if(_topLoadingView.superview == nil){
            [_tableView addSubview:_topLoadingView];
        }
    }
    
    if(_tableView.contentOffset.y < _tableView.contentInset.top){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [_tableView setContentOffset:CGPointMake(0, -_tableView.contentInset.top) animated:NO];
        [UIView commitAnimations];
    }
    
    if(_hasMoreData){
        
        CGSize contentSize = _tableView.contentSize;
        
        if(_bottomLoadingView && _bottomLoadingView.superview == nil
           && contentSize.height >= _tableView.bounds.size.height){
            
            CGRect r = _bottomLoadingView.frame;
            
            r.size.width = _tableView.bounds.size.width;
            r.origin.y = contentSize.height;
            
            [_bottomLoadingView setFrame:r];
            [_tableView addSubview:_bottomLoadingView];
            
        }
        else{
            [_bottomLoadingView removeFromSuperview];
        }
    }
    else{
        [_bottomLoadingView removeFromSuperview];
    }
    
    
    if([self.dataObjects count] <= 0){
        if(_notFoundDataView && _notFoundDataView.superview == nil){
            _notFoundDataView.frame = _tableView.bounds;
            [_notFoundDataView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
            
            UIView * v = nil;
            Class clazz = NSClassFromString(@"UITableViewWrapperView");
            
            if(clazz){
                for (UIView * sv in [_tableView subviews]) {
                    if([sv class] == clazz){
                        v = sv;
                        break;
                    }
                }
            }
            
            if(v){
                [_tableView insertSubview:_notFoundDataView aboveSubview:v];
            }
            else {
                [_tableView insertSubview:_notFoundDataView atIndex:0];
            }
        }
    }
    else{
        [_notFoundDataView removeFromSuperview];
    }
    
}

-(void) tableView:(UITableView *)tableView didContentOffsetChanged:(CGPoint)contentOffset{
    
    if(_animating){
        return;
    }
    
    CGSize contentSize = tableView.contentSize;
    UIEdgeInsets contentInset = tableView.contentInset;
    CGSize size = tableView.bounds.size;
    
    if(![_topLoadingView isAnimating] && ![_bottomLoadingView isAnimating]){
        if(contentOffset.y < -contentInset.top){
            if( - (contentOffset.y + contentInset.top) >= _topLoadingView.frame.size.height){
                [_topLoadingView setDirect:ZCDragLoadingViewDirectUp];
            }
            else{
                [_topLoadingView setDirect:ZCDragLoadingViewDirectDown];
                if(_allowRefresh){
                    self.pageIndex = 1;
                    if ([self.delegate respondsToSelector:@selector(ZCTableDataControllerRefreshData:)]) {
                        [self.delegate ZCTableDataControllerRefreshData:self];
                    }
                    _allowRefresh = NO;
                }
            }
            
            [_topLoadingView setOffsetValue: - (contentOffset.y + contentInset.top) / _topLoadingView.frame.size.height];
            
            CGRect r = _topLoadingView.frame;
            
            r.size.width = size.width;
            r.origin.y = - r.size.height;
            
            [_topLoadingView setFrame:r];
            
            if(_topLoadingView.superview == nil){
                [tableView addSubview:_topLoadingView];
                [tableView sendSubviewToBack:_topLoadingView];
            }
        }
        else if(contentOffset.y  + size.height >= contentSize.height){
            
            [_bottomLoadingView setDirect:ZCDragLoadingViewDirectUp];
            
            [_bottomLoadingView setOffsetValue: (contentOffset.y  + size.height - contentSize.height) / _bottomLoadingView.frame.size.height];
            
        }
        
    }
    
    if(contentOffset.y > -contentInset.top && contentOffset.y + size.height < contentSize.height
       && !CGPointEqualToPoint(_preContentOffset, contentOffset)){
        
        CGFloat dy = contentOffset.y - _preContentOffset.y;
        
        if(dy >0){
            
            CGFloat alpha = [[_autoHiddenViews lastObject] alpha] - 0.05;
            
            if(alpha < 0.0f){
                alpha = 0.0f;
            }
            
            for(UIView * v in _autoHiddenViews){
                [v setAlpha:alpha];
                [v setHidden:alpha == 0.0];
            }
            
        }
        else if(dy <0){
            
            CGFloat alpha = [[_autoHiddenViews lastObject] alpha] + 0.05;
            
            if(alpha > 1.0f){
                alpha = 1.0f;
            }
            
            for(UIView * v in _autoHiddenViews){
                [v setAlpha:alpha];
                [v setHidden:alpha == 0.0];
            }
            
        }
        
        _preContentOffset = contentOffset;
    }
    else if(contentOffset.y <= -contentInset.top){
        for(UIView * v in _autoHiddenViews){
            [v setAlpha:1.0];
            [v setHidden:NO];
        }
    }
}

-(id) dataObjectByIndexPath:(NSIndexPath *) indexPath{
    
    if(indexPath.row < [_headerCells count]){
        return nil;
    }
    
    if(indexPath.row >= [self.dataObjects count] + [_headerCells count]){
        return nil;
    }
    
    return [self.dataObjects objectAtIndex:indexPath.row - [_headerCells count]];
}

-(void) setHeaderCells:(NSArray *)headerCells{
    if(_headerCells != headerCells){
        NSArray * v = [headerCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger i = [obj1 tag] - [obj2 tag];
            if(i < 0){
                return NSOrderedAscending;
            }
            if(i > 0 ){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        _headerCells = v;
    }
}

-(void) setFooterCells:(NSArray *)footerCells{
    if(_footerCells != footerCells){
        NSArray * v = [footerCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger i = [obj1 tag] - [obj2 tag];
            if(i < 0){
                return NSOrderedAscending;
            }
            if(i > 0 ){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        _footerCells = v;
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
}

@end
