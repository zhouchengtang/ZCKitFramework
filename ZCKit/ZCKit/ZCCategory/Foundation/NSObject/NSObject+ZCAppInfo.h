//
//  NSObject+ZCAppInfo.h
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(ZCAppInfo)

-(NSString *)zc_version;
-(NSInteger)zc_build;
-(NSString *)zc_identifier;
-(NSString *)zc_currentLanguage;
-(NSString *)zc_deviceModel;

@end
