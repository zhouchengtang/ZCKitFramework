//
//  IZCRegisterObject.h
//  ZCKit
//
//  Created by tangzhoucheng on 16/10/18.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void ( ^ ZCObjectURLCallback )(id resultsData,id sender);

@protocol IZCRegisterObject <NSObject>

@property(nonatomic,strong) id config;
@property(nonatomic,strong) NSString * alias;
@property(nonatomic,strong) NSURL * url;
@property(nonatomic,strong) NSString * scheme;
@property(nonatomic,strong) id parameterObject;
@property(nonatomic, copy) ZCObjectURLCallback objectURLResultsCallback;

@end
