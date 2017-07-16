//
//  IZCAction.h
//  vTeam
//
//  Created by tang zhoucheng on 13-5-3.
//  Copyright (c) 2013年 zhoucheng.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IZCAction <NSObject>

@property(nonatomic,retain) NSString * actionName;
@property(nonatomic,retain) id userInfo;
@property(nonatomic,retain) IBOutletCollection(UIView) NSArray * actionViews;

@end
