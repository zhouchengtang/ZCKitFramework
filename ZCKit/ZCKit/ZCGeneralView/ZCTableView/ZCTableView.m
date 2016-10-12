//
//  TZCTableView.m
//  PrivateAccountBook
//
//  Created by JiaPin on 15-2-2.
//  Copyright (c) 2015年 JiaPin. All rights reserved.
//

#import "ZCTableView.h"

@implementation ZCTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {//设置tableView分割线从顶端开始，IOS7默认有一点间隙
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self setLayoutMargins:UIEdgeInsetsZero];
            
        }
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {//设置tableView分割线从顶端开始，IOS7默认有一点间隙
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void) setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    if(self.window){
        if([self.delegate respondsToSelector:@selector(tableView:didContentOffsetChanged:)]){
            [(id<ZCTableViewDelegate>)self.delegate tableView:self didContentOffsetChanged:self.contentOffset];
        }
    }
}

-(void) didMoveToWindow{
    [super didMoveToWindow];
    if([self.delegate respondsToSelector:@selector(tableView:didMoveToWindow:)]){
        [(id<ZCTableViewDelegate>)self.delegate tableView:self didMoveToWindow:self.window];
    }
}

-(void) willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    if([self.delegate respondsToSelector:@selector(tableView:willMoveToWindow:)]){
        [(id<ZCTableViewDelegate>)self.delegate tableView:self willMoveToWindow:newWindow];
    }
}

@end
