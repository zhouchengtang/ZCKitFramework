//
//  ZCURLCacheObject.h
//  AKBiOSProject
//
//  Created by zhoucheng on 16/4/21.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <ZCKit/ZCKit.h>

@interface ZCURLCacheObject : ZCBaseModel

@property(nonatomic,strong) id dataObject;
@property(nonatomic,strong) NSString * responseUUID;
@property(nonatomic,assign) NSInteger timestamp;
@end
