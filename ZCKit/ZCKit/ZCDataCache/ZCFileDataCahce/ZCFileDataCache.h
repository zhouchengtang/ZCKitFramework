//
//  ZCFiledataCache.h
//  JPSALEClient
//
//  Created by 唐周成 on 14-5-22.
//  Copyright (c) 2014年 唐周成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCFileDataCache : NSObject

@property(nonatomic, assign)BOOL writeDataInMainQueQue;//在主线程写数据

@property(nonatomic, assign)BOOL writeDataOnlyToMemory; //只将数据写入内存中（默认写入硬盘）;

@property(nonatomic, assign)BOOL encryption;//是否对缓存数据加密 default is NO

+ (ZCFileDataCache  *)sharedInstance;

- (void)setObject:(id)value forKey:(NSString *)defaultName;

- (void)setValue:(id)value forKey:(NSString *)defaultName;

- (id)objectForKey:(NSString *)defaultName;

- (id)valueForKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)showContent;//展示缓存字典数据

- (void)updateDataCacheDict;

- (void)updateDiskData;

- (void)clearDataCache;

@end
