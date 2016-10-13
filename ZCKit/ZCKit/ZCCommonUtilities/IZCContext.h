//
//  IZCPContext.h
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void ( ^ VTContextResultsCallback )(id resultsData,id sender);

@protocol IZCContext <NSObject>

-(id) getViewController:(NSURL *) url basePath:(NSString *) basePath;

-(id) focusValueForKey:(NSString *) key;

-(void) setFocusValue:(id) value forKey:(NSString *) key;

-(id) rootViewController;

-(VTContextResultsCallback) resultsCallback;

@end
