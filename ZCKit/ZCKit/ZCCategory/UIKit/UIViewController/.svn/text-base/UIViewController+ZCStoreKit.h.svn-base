//
//  UIViewController+ZCStoreKit.h
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import <UIKit/UIKit.h>
////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

#define affiliateToken @"10laQX"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface UIViewController(ZCStoreKit)

@property NSString* campaignToken;
@property (nonatomic, copy) void (^loadingStoreKitItemBlock)(void);
@property (nonatomic, copy) void (^loadedStoreKitItemBlock)(void);

- (void)presentStoreKitItemWithIdentifier:(NSInteger)itemIdentifier;

+ (NSURL*)appURLForIdentifier:(NSInteger)identifier;

+ (void)openAppURLForIdentifier:(NSInteger)identifier;
+ (void)openAppReviewURLForIdentifier:(NSInteger)identifier;

+ (BOOL)containsITunesURLString:(NSString*)URLString;
+ (NSInteger)IDFromITunesURL:(NSString*)URLString;

@end
