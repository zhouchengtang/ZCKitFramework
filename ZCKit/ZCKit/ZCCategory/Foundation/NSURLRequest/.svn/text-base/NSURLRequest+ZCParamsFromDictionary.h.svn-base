//
//  NSURLRequest+ZCParamsFromDictionary.h
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest(ZCParamsFromDictionary)
+(NSURLRequest *)requestGETWithURL:(NSURL *)url parameters:(NSDictionary *)params;
- (id)initWithURL:(NSURL *)URL parameters:(NSDictionary *)params;

+(NSString *)URLfromParameters:(NSDictionary *)params;

+(NSArray *)queryStringComponentsFromKey:(NSString *)key value:(id)value;
+(NSArray *)queryStringComponentsFromKey:(NSString *)key dictionaryValue:(NSDictionary *)dict;
+(NSArray *)queryStringComponentsFromKey:(NSString *)key arrayValue:(NSArray *)array;
@end
