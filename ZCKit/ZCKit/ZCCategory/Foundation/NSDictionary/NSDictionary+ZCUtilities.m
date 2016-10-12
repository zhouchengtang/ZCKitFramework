//
//  NSDictionary+ZCUtilities.m
//  ZCKit
//
//  Created by t_zc on 16/1/20.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "NSDictionary+ZCUtilities.h"

@implementation NSDictionary(ZCUtilities)

- (NSString *)toJsonString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end