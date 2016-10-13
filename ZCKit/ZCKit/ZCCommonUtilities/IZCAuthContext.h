//
//  IZCPAuthContext.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IZCAuthContext <NSObject>

-(void) setAuthValue:(id) value forKey:(NSString *)key;

-(id) authValueForKey:(NSString *) key;

-(NSArray *) authKeys;


@end
