//
//  NSData+ZCUtilities.m
//  ZCKit
//
//  Created by t_zc on 16/1/22.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "NSData+ZCMD5.h"
#import <CommonCrypto/CommonCrypto.h>//md5

@implementation NSData(ZCMD5)

#pragma mark - md5
-(NSString *) zcMD5String
{
    unsigned char md[16];
    CC_MD5([self bytes], (unsigned int) [self length], md);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            md[0], md[1], md[2], md[3],
            md[4], md[5], md[6], md[7],
            md[8], md[9], md[10], md[11],
            md[12], md[13], md[14], md[15]
            ];
}

@end
