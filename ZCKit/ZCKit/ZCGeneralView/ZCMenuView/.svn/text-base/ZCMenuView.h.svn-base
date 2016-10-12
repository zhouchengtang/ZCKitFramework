//
//  ZCMenuView.h
//  MenuScrollView
//
//  Created by t_zc on 16/1/22.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ZCMenuViewItem_SelectStyle:NSInteger
{
    ZCMenuViewItem_SelectStyle_Defualt = 0,
    ZCMenuViewItem_SelectStyle_None
}ZCMenuViewItem_SelectStyle;

@interface ZCMenuViewItem:UIView

@property(nonatomic, strong)id dataItem;

@property(nonatomic, assign)ZCMenuViewItem_SelectStyle selectStyle;

@property(nonatomic, strong)UIColor * leftLineColor;

@property(nonatomic, strong)UIColor * rightLineColor;

@property(nonatomic, strong)UIColor * topLineColor;

@property(nonatomic, strong)UIColor * bottomLineColor;

@property(nonatomic, strong)UIColor * selectMenuViewItemColor;

@end

@class ZCMenuView;

@protocol ZCMenuViewDelegate <NSObject>
//一共多少item
- (NSInteger)numberWithMenuViewItem:(ZCMenuView *)menuView;
//一行展示多少个Item
- (NSInteger)numberWithOneLineMenuViewItem:(ZCMenuView *)menuView;
//返回每个menuViewItem对象
- (ZCMenuViewItem *)menuView:(ZCMenuView *)menuView menuViewItemAtIndex:(NSInteger)index;
//menuItemSize

@optional
- (CGSize)sizeWithMenuViewItem:(ZCMenuView *)menuView;
//触发事件
- (void)menuView:(ZCMenuView *)menuView didSelectWithIndex:(NSInteger)index menuViewItem:(ZCMenuViewItem *)menuViewItem;

@end

@interface ZCMenuView : UIView

@property(nonatomic, strong)UIScrollView * scrollView;

@property(nonatomic, weak)id <ZCMenuViewDelegate> delegate;
//分割线颜色
@property(nonatomic, strong)UIColor * separatorColor;
//itemView
@property(nonatomic, assign, readonly)CGSize menuViewItemSize;

- (ZCMenuViewItem *) dequeueReusableMentItemWithIdentifier:(NSString *)identifier;

- (ZCMenuViewItem *) menuViewItemWithIndex:(NSInteger)index;

- (void)reloadData;

@end
