//
//  NSString+VTDOMSource.h
//  vTeam
//
//  Created by tang zhoucheng on 13-8-14.
//  Copyright (c) 2013年 zhoucheng.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (ZCDOMSource)

-(NSString *) htmlEncodeString;

-(NSString *) htmlDecodeString;

-(NSString *) htmlStringByDOMSource:(id) data;

-(NSString *) htmlStringByDOMSource:(id) data htmlEncoded:(BOOL) htmlEncoded;

@end
