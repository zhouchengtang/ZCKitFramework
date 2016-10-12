//
//  VTDataOutlet.h
//  vTeam
//
//  Created by tang zhoucheng on 13-4-25.
//  Copyright (c) 2013年 zhoucheng.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSObject(ZCDataOutlet)

-(id) dataForKey:(NSString *) key;

-(id) dataForKeyPath:(NSString *) keyPath;

@end

typedef  NSString * (^ ZCDataOutletStringValue) (id data,NSString * keyPath);

@interface NSString (ZCDataOutlet)

-(NSString *) stringByDataOutlet:(id) data;

-(NSString *) stringByDataOutlet:(id) data stringValue: (ZCDataOutletStringValue)value;

@end


@interface ZCDataOutlet : NSObject

@property(nonatomic,assign) NSInteger tag;
@property(nonatomic,retain) NSString * status;
@property(nonatomic,retain) IBOutlet id view;
@property(nonatomic,retain) IBOutletCollection(NSObject) NSArray * views;

@property(nonatomic,retain) NSString * keyPath;
@property(nonatomic,retain) NSString * stringKeyPath;
@property(nonatomic,retain) NSString * stringFormat;
@property(nonatomic,retain) NSString * stringHtmlFormat;
@property(nonatomic,retain) NSString * booleanKeyPath;
@property(nonatomic,retain) NSString * valueKeyPath;
@property(nonatomic,retain) NSString * enabledKeyPath;
@property(nonatomic,retain) NSString * disabledKeyPath;
@property(nonatomic,retain) id value;

-(void) applyDataOutlet:(id) data;

@end