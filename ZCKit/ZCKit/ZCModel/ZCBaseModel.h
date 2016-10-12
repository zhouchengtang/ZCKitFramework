//
//  ZCBaseModel.h
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/11/22.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZCBaseModel : NSObject

- (instancetype)initWithDictionary: (NSDictionary *)dictionary;

- (instancetype)initWithJsonData: (NSData *)jsonData;

- (instancetype)initWithJsonString: (NSString *)jsonString;

+ (instancetype)modelWithDictionary: (NSDictionary *)dictionary;

+ (instancetype)modelWithJsonData:(NSData *)jsonData;

+ (instancetype)modelWithJsonString:(NSString *)jsonString;

- (void)setModelWithDictionary: (NSDictionary *)data;

- (NSDictionary *)dictionaryWithModel;

- (NSData *)jsonDataWithModel;

- (NSString *)jsonStringWithModel;

- (NSDictionary *)propertyMapDic;

- (void)setPropertyMapDic:(NSDictionary *)propertyMapDic;

@end

@interface ZCBaseModelClassProperty:NSObject

@property (copy, nonatomic) NSString * name;
@property (assign, nonatomic) Class type;
@property (strong, nonatomic) NSString * structName;
@property (copy, nonatomic) NSString * protocol;

@end