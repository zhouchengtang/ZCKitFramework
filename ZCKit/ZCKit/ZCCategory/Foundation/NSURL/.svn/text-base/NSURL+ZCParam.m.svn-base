//
//  NSURL+ZCParam.m
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "NSURL+ZCParam.h"

#include <objc/runtime.h>

@implementation NSURL(ZCParam)
/**
 *  @brief  url参数转字典
 *
 *  @return 参数转字典结果
 */
- (NSDictionary *)parameters
{
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionary];
    NSArray * queryComponents = [self.query componentsSeparatedByString:@"&"];
    for (NSString * queryComponent in queryComponents) {
        NSString * key = [queryComponent componentsSeparatedByString:@"="].firstObject;
        NSString * value = [queryComponent substringFromIndex:(key.length + 1)];
        [parametersDictionary setObject:value forKey:key];
    }
    return parametersDictionary;
}
/**
 *  @brief  根据参数名 取参数值
 *
 *  @param parameterKey 参数名的key
 *
 *  @return 参数值
 */
- (NSString *)valueForParameter:(NSString *)parameterKey
{
    return [[self parameters] objectForKey:parameterKey];
}

+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL queryValues:(id) queryValues{
    NSRange r = [URLString rangeOfString:@"?"];
    NSMutableString * ms = [NSMutableString stringWithCapacity:64];
    BOOL isFirst = NO;
    if(r.location == NSNotFound){
        [ms appendString:@"?"];
        isFirst = YES;
    }
    else if(r.location == [URLString length] -1){
        isFirst = YES;
    }
    
    if([queryValues isKindOfClass:[NSDictionary class]]){
        for(NSString * key in queryValues){
            if(isFirst){
                isFirst = NO;
            }
            else{
                [ms appendString:@"&"];
            }
            id v = [queryValues valueForKey:key];
            if(![v isKindOfClass:[NSString class]]){
                v = [NSString stringWithFormat:@"%@",v];
            }
            [ms appendFormat:@"%@=%@",key ,[NSURL encodeQueryValue:v]];
        }
    }
    else if(queryValues){
        Class clazz = [queryValues class];
        while(clazz != [NSObject class]){
            unsigned c = 0;
            objc_property_t * prop = class_copyPropertyList(clazz, &c);
            objc_property_t * p = prop;
            
            while(c >0){
                
                NSString * key = [NSString stringWithCString:property_getName(*p)
                                                    encoding:NSUTF8StringEncoding];
                
                id v = [queryValues valueForKey:key];
                
                if(v == nil){
                    c --;
                    p ++;
                    continue;
                }
                
                if(isFirst){
                    isFirst = NO;
                }
                else{
                    [ms appendString:@"&"];
                }
                
                if(![v isKindOfClass:[NSString class]]){
                    v = [NSString stringWithFormat:@"%@",v];
                }
                [ms appendFormat:@"%@=%@",key ,[NSURL encodeQueryValue:v]];
                
                c --;
                p ++;
            }
            free(prop);
            
            clazz = class_getSuperclass(clazz);
        }
    }
    
    return [NSURL URLWithString:[URLString stringByAppendingString:ms] relativeToURL:baseURL];
}

+ (id)URLWithString:(NSString *)URLString queryValues:(id) queryValues{
    return [NSURL URLWithString:URLString relativeToURL:nil queryValues:queryValues];
}

+ (NSString *) encodeQueryValue:(NSString *) queryValue{
    NSMutableString * ms = [NSMutableString stringWithCapacity:64];
    unsigned char * p = (unsigned char *) [queryValue UTF8String];
    while(p && *p != '\0'){
        
        if(*p == ' '){
            [ms appendString:@"+"];
        }
        else if(*p == '.'){
            [ms appendString:@"."];
        }
        else if(*p == '-'){
            [ms appendString:@"-"];
        }
        else if(*p == '_'){
            [ms appendString:@"_"];
        }
        else if((*p >='0' && *p <='9') || (*p >= 'a' && *p <='z') || (*p >= 'A' && *p <='Z')){
            [ms appendFormat:@"%c",*p];
        }
        else{
            [ms appendFormat:@"%%%02X",*p];
        }
        
        p++;
    }
    return ms;
}

@end
