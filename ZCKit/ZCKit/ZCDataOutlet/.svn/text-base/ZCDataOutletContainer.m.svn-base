//
//  ZCDataOutletContainer.m
//  vTeam
//
//  Created by tang zhoucheng on 13-4-25.
//  Copyright (c) 2013年 zhoucheng.org. All rights reserved.
//

#import "ZCDataOutletContainer.h"

@implementation ZCDataOutletContainer

@synthesize dataOutlets=  _dataOutlets;
@synthesize status = _status;


-(void) applyDataOutlet:(id) data{
    for(id dataOutlet in _dataOutlets){
        if(_status == nil || [dataOutlet status] == nil
           || [_status rangeOfString:[dataOutlet status]].location != NSNotFound){
            [dataOutlet applyDataOutlet:data];
        }        
    }
}


-(void) setDataOutlets:(NSArray *)dataOutlets{
    if(_dataOutlets != dataOutlets){
        
        NSArray * v = [dataOutlets sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger i = [obj1 tag] - [obj2 tag];
            if(i < 0){
                return NSOrderedAscending;
            }
            if(i > 0){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        _dataOutlets = v ;
    }
}

@end
