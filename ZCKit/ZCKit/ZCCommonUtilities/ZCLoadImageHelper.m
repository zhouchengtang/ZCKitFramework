//
//  ZCLoadImageHelper.m
//  AKBiOSProject
//
//  Created by zhoucheng on 16/4/21.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ZCLoadImageHelper.h"
#import "UIImageView+ZCSD_WebCache.h"
#import "ZCImageView.h"
#import "UIView+ZCSearch.h"

@implementation ZCLoadImageHelper

+ (void) loadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IZCImageView)];
    for(ZCImageView * imageView in imageViews){
        if (imageView.src && imageView.src.length > 0) {
            UIImage * defaultImage = nil;
            if (imageView.defaultImage) {
                defaultImage = imageView.defaultImage;
            }
            [imageView zc_sd_setImageWithURL:[NSURL URLWithString:imageView.src] placeholderImage:defaultImage];
        }
    }
}

@end
