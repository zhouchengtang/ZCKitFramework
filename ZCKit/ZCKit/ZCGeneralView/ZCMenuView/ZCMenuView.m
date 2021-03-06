//
//  ZCMenuView.m
//  MenuScrollView
//
//  Created by t_zc on 16/1/22.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "ZCMenuView.h"

@implementation ZCMenuViewItem

@end

@interface ZCMenuView()<UIGestureRecognizerDelegate>

@property(nonatomic, assign)NSInteger numberOfItem;
//一行格子个数
@property(nonatomic, assign)NSInteger numberOfLineItem;
//格子Size
@property(nonatomic, assign)CGSize itemSize;

@property(nonatomic, strong)NSMutableArray * menuViewItems;

@property(nonatomic, strong)UIGestureRecognizer * currentGestureRecognizer;

@end

@implementation ZCMenuView
#define line_Size 0.5
#define line_Color [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]//分割线颜色

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.numberOfLineItem = 0;
        self.numberOfItem = 0;
        self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.width / 3);
        self.separatorColor = line_Color;
    }
    return self;
}

- (NSMutableArray *)menuViewItems
{
    if (!_menuViewItems) {
        _menuViewItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _menuViewItems;
}

- (UIView *)creatVerticalLineWithFrame:(CGRect)frame
{
    UIView * verticalLine = [[UIView alloc] initWithFrame:frame];
    [verticalLine setBackgroundColor:self.separatorColor];
    return verticalLine;
}

- (UIView *)creatHorizontalLineWithFrame:(CGRect)frame
{
    UIView * headHorizontalLine = [[UIView alloc] initWithFrame:frame];
    [headHorizontalLine setBackgroundColor:self.separatorColor];
    return headHorizontalLine;
}

- (ZCMenuViewItem *)dequeueReusableMentItemWithIdentifier:(NSString *)identifier
{
    ZCMenuViewItem * menuViewItem = [[ZCMenuViewItem alloc] initWithFrame:CGRectMake(0, 0, self.itemSize.width, self.itemSize.height)];
    menuViewItem.selectStyle = ZCMenuViewItem_SelectStyle_Defualt;
    return menuViewItem;
}

- (CGSize)menuViewItemSize
{
    if ([_delegate respondsToSelector:@selector(sizeWithMenuViewItem:)]) {
        self.itemSize =[_delegate sizeWithMenuViewItem:self];
    }
    return self.itemSize;
}

- (ZCMenuViewItem *)menuViewItemWithIndex:(NSInteger)index
{
    if (self.menuViewItems.count > index) {
        return [self.menuViewItems objectAtIndex:index];
    }
    return nil;
}

#pragma mark - reloadData
- (void)reloadData
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        
        [self addSubview:_scrollView];
    }
    
    for (UIView * view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.menuViewItems removeAllObjects];
    [_scrollView setFrame:self.bounds];
    
    if ([_delegate respondsToSelector:@selector(numberWithMenuViewItem:)]) {
        self.numberOfItem = [_delegate numberWithMenuViewItem:self];
    }
    if ([_delegate respondsToSelector:@selector(numberWithOneLineMenuViewItem:)]) {
        self.numberOfLineItem = [_delegate numberWithOneLineMenuViewItem:self];
    }
    if ([_delegate respondsToSelector:@selector(sizeWithMenuViewItem:)]) {
        self.itemSize = [_delegate sizeWithMenuViewItem:self];
    }
    
    for (NSInteger i = 0; i < self.numberOfItem; i++) {
        CGFloat item_X = self.itemSize.width * (i % self.numberOfLineItem);
        CGFloat item_Y = (NSInteger)(i / self.numberOfLineItem) * self.itemSize.height;
        
        
        UIView * view = [[UIView alloc] initWithFrame: CGRectMake(item_X,
                                                                  item_Y,
                                                                  self.itemSize.width,
                                                                  self.itemSize.height)];
        
        //verticalLine
        
        UIView * rightLine = nil;
        if (item_X != self.itemSize.width * (self.numberOfLineItem - 1)) {
            rightLine = [self creatVerticalLineWithFrame:CGRectMake(self.itemSize.width, 0, line_Size, self.itemSize.height)];
            [view addSubview:rightLine];
        }
        
        //horizontalLine
        UIView * topLine = nil;
        if (item_Y == 0) {
            topLine = [self creatHorizontalLineWithFrame:CGRectMake(0, 0, self.itemSize.width, line_Size)];
            [view addSubview:topLine];
        }
        
        UIView * bottomLine = [self creatHorizontalLineWithFrame:CGRectMake(0, self.itemSize.height - line_Size, self.itemSize.width, line_Size)];
        [view addSubview:bottomLine];
        
        if ([_delegate respondsToSelector:@selector(menuView:menuViewItemAtIndex:)]) {
            ZCMenuViewItem * menuItemView = [_delegate menuView:self menuViewItemAtIndex:i];
            [view addSubview:menuItemView];
            if (rightLine && menuItemView.rightLineColor) {
                [rightLine setBackgroundColor:menuItemView.rightLineColor];
            }
            if (topLine && menuItemView.topLineColor) {
                [topLine setBackgroundColor:menuItemView.topLineColor];
            }
            if (bottomLine && menuItemView.bottomLineColor) {
                [bottomLine setBackgroundColor:menuItemView.bottomLineColor];
            }
            [self.menuViewItems addObject:menuItemView];
        }
        
        view.tag = i;
        
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        longPressGesture.delegate = self;
        longPressGesture.minimumPressDuration = 0.2;
        [view addGestureRecognizer:longPressGesture];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressGesture:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tapGesture];
        [view setExclusiveTouch:YES];
        
        [_scrollView addSubview:view];
        [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, view.frame.origin.y + view.frame.size.height)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self reloadData];
}

#pragma mark - Gesture
- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if (!self.currentGestureRecognizer) {
        self.currentGestureRecognizer = gesture;
    }else{
        if (self.currentGestureRecognizer != gesture) {
            return;
        }
    }
    if ([self.menuViewItems count] > gesture.view.tag &&
        !([(ZCMenuViewItem *)[self.menuViewItems objectAtIndex:gesture.view.tag] selectStyle] == ZCMenuViewItem_SelectStyle_None)) {
        if ([(ZCMenuViewItem *)[self.menuViewItems objectAtIndex:gesture.view.tag] selectMenuViewItemColor]) {
            [gesture.view setBackgroundColor:[(ZCMenuViewItem *)[self.menuViewItems objectAtIndex:gesture.view.tag] selectMenuViewItemColor]];
        }else{
            [gesture.view setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.8]];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gesture locationInView:gesture.view];
        if (point.x >= 0 && point.x <= gesture.view.frame.size.width &&
            point.y >= 0 && point.y <= gesture.view.frame.size.height) {
            
            if ([_delegate respondsToSelector:@selector(menuView:didSelectWithIndex:menuViewItem:)]) {
                [_delegate menuView:self didSelectWithIndex:gesture.view.tag menuViewItem:[self.menuViewItems objectAtIndex:gesture.view.tag]];
            }
        }
        [gesture.view setBackgroundColor:[UIColor clearColor]];
        [self setCurrentGestureRecognizer:nil];
    }else if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged)
    {
        [gesture.view setBackgroundColor:[UIColor clearColor]];
        [self setCurrentGestureRecognizer:nil];
    }
}

- (void)tapPressGesture:(UITapGestureRecognizer *)gesture
{
    if (!self.currentGestureRecognizer) {
        self.currentGestureRecognizer = gesture;
    }else{
        if (self.currentGestureRecognizer != gesture) {
            return;
        }
    }
    if ([self.menuViewItems count] > gesture.view.tag &&
        !([(ZCMenuViewItem *)[self.menuViewItems objectAtIndex:gesture.view.tag] selectStyle] == ZCMenuViewItem_SelectStyle_None)) {
        if ([(ZCMenuViewItem *)[self.menuViewItems objectAtIndex:gesture.view.tag] selectMenuViewItemColor]) {
            [gesture.view setBackgroundColor:[(ZCMenuViewItem *)[self.menuViewItems objectAtIndex:gesture.view.tag] selectMenuViewItemColor]];
        }else{
            [gesture.view setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.8]];
        }
    }
    if ([_delegate respondsToSelector:@selector(menuView:didSelectWithIndex:menuViewItem:)]) {
        [_delegate menuView:self didSelectWithIndex:gesture.view.tag menuViewItem:[self.menuViewItems objectAtIndex:gesture.view.tag]];
    }
    [gesture.view performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.1];
    [self performSelector:@selector(setCurrentGestureRecognizer:) withObject:nil afterDelay:0.1];
}

#pragma -mark


@end
