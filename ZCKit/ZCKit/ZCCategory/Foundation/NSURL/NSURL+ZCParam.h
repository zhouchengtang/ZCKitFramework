//
//  NSURL+ZCParam.h
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL(ZCParam)
/**
 *  @brief  url参数转字典
 *
 *  @return 参数转字典结果
 */
- (NSDictionary *)parameters;
/**
 *  @brief  根据参数名 取参数值
 *
 *  @param parameterKey 参数名的key
 *
 *  @return 参数值
 */
- (NSString *)valueForParameter:(NSString *)parameterKey;

+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL queryValues:(id) queryValues;

+ (id)URLWithString:(NSString *)URLString queryValues:(id) queryValues;

+ (NSString *) encodeQueryValue:(NSString *) queryValue;

@end
