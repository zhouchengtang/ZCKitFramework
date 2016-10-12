//
//  ZCBaseModelArray.h
//  PrivateAccountBook
//
//  Created by zhoucheng on 15/12/4.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCBaseModel.h"

@interface NSMutableArray(ZCBaseModel)

@property(nonatomic, strong)ZCBaseModelClassProperty * modelProperty;

- (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray modelProperty:(ZCBaseModelClassProperty *)modelProperty;

- (NSMutableArray *)dataArrayWithModelArray:(NSArray *)modelArray;

@end
