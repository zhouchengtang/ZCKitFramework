//
//  ZC_SDImageCacheConfig.m
//  ZC_SDWebImage
//
//  Created by Bogdan on 09/09/16.
//  Copyright © 2016 Dailymotion. All rights reserved.
//

#import "ZC_SDImageCacheConfig.h"

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week

@implementation  ZC_SDImageCacheConfig

- (instancetype)init {
    if (self = [super init]) {
        _shouldDecompressImages = YES;
        _shouldDisableiCloud = YES;
        _shouldCacheImagesInMemory = YES;
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        _maxCacheSize = 0;
    }
    return self;
}

@end
