//
//  ZCTableSection.m
//  ZCKit
//
//  Created by zhoucheng on 16/4/28.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "ZCTableSection.h"

@implementation ZCTableSection

@synthesize height=  _height;
@synthesize title = _title;
@synthesize view = _view;
@synthesize cells = _cells;
@synthesize footerView = _footerView;
@synthesize tag = _tag;

-(void) setCells:(NSArray *)cells{
    NSArray * c = [cells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger tag1 = [(UIView *) obj1 tag];
        NSInteger tag2 = [(UIView *) obj2 tag];
        NSInteger r = tag1 - tag2;
        
        if(r < 0){
            return NSOrderedAscending;
        }
        if(r > 0){
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    _cells = c;
}

@end
