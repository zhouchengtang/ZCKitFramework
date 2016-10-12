/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+ZCSD_HighlightedWebCache.h"

#if SD_UIKIT

#import "UIView+ZCSD_WebCacheOperation.h"
#import "UIView+ZCSD_WebCache.h"

@implementation UIImageView (ZCSD_HighlightedWebCache)

- (void)zc_sd_setHighlightedImageWithURL:(nullable NSURL *)url {
    [self zc_sd_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)zc_sd_setHighlightedImageWithURL:(nullable NSURL *)url options:(ZC_SDWebImageOptions)options {
    [self zc_sd_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)zc_sd_setHighlightedImageWithURL:(nullable NSURL *)url completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)zc_sd_setHighlightedImageWithURL:(nullable NSURL *)url options:(ZC_SDWebImageOptions)options completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)zc_sd_setHighlightedImageWithURL:(nullable NSURL *)url
                              options:(ZC_SDWebImageOptions)options
                             progress:(nullable ZC_SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable SDExternalCompletionBlock)completedBlock {
    __weak typeof(self)weakSelf = self;
    [self zc_sd_internalSetImageWithURL:url
                    placeholderImage:nil
                             options:options
                        operationKey:@"UIImageViewImageOperationHighlighted"
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           weakSelf.highlightedImage = image;
                       }
                            progress:progressBlock
                           completed:completedBlock];
}

@end

#endif
