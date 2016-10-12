/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "ZC_FLAnimatedImageView+WebCache.h"

#if SD_UIKIT
#import "objc/runtime.h"
#import "UIView+ZCSD_WebCacheOperation.h"
#import "UIView+ZCSD_WebCache.h"
#import "NSData+ZCSD_ImageContentType.h"
#import "ZC_FLAnimatedImage.h"
#import "UIImageView+ZCSD_WebCache.h"

@implementation ZC_FLAnimatedImageView (WebCache)

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url {
    [self zc_sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    [self zc_sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(ZC_SDWebImageOptions)options {
    [self zc_sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(ZC_SDWebImageOptions)options completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(ZC_SDWebImageOptions)options
                  progress:(nullable ZC_SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock {
    __weak typeof(self)weakSelf = self;
    [self zc_sd_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:nil
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           ZC_SDImageFormat imageFormat = [NSData zc_sd_imageFormatForImageData:imageData];
                           if (imageFormat == ZC_SDImageFormatGIF) {
                               weakSelf.animatedImage = [ZC_FLAnimatedImage animatedImageWithGIFData:imageData];
                               weakSelf.image = nil;
                           } else {
                               weakSelf.image = image;
                               weakSelf.animatedImage = nil;
                           }
                       }
                            progress:progressBlock
                           completed:completedBlock];
}

@end

#endif
