/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+ZCSD_WebCache.h"

#if SD_UIKIT

#import "objc/runtime.h"
#import "UIView+ZCSD_WebCacheOperation.h"
#import "UIView+ZCSD_WebCache.h"

static char imageURLStorageKey;

typedef NSMutableDictionary<NSNumber *, NSURL *> SDStateImageURLDictionary;

@implementation UIButton (ZCSD_WebCache)

- (nullable NSURL *)zc_sd_currentImageURL {
    NSURL *url = self.imageURLStorage[@(self.state)];

    if (!url) {
        url = self.imageURLStorage[@(UIControlStateNormal)];
    }

    return url;
}

- (nullable NSURL *)zc_sd_imageURLForState:(UIControlState)state {
    return self.imageURLStorage[@(state)];
}

#pragma mark - Image

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state {
    [self zc_sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder {
    [self zc_sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder options:(ZC_SDWebImageOptions)options {
    [self zc_sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)zc_sd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder
                   options:(ZC_SDWebImageOptions)options
                 completed:(nullable SDExternalCompletionBlock)completedBlock {
    if (!url) {
        [self.imageURLStorage removeObjectForKey:@(state)];
        return;
    }
    
    self.imageURLStorage[@(state)] = url;
    
    __weak typeof(self)weakSelf = self;
    [self zc_sd_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           [weakSelf setImage:image forState:state];
                       }
                            progress:nil
                           completed:completedBlock];
}

#pragma mark - Background image

- (void)zc_sd_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state {
    [self zc_sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)zc_sd_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder {
    [self zc_sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)zc_sd_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder options:(ZC_SDWebImageOptions)options {
    [self zc_sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)zc_sd_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)zc_sd_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self zc_sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)zc_sd_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder
                             options:(ZC_SDWebImageOptions)options
                           completed:(nullable SDExternalCompletionBlock)completedBlock {
    if (!url) {
        [self.imageURLStorage removeObjectForKey:@(state)];
        return;
    }
    
    self.imageURLStorage[@(state)] = url;
    
    __weak typeof(self)weakSelf = self;
    [self zc_sd_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           [weakSelf setBackgroundImage:image forState:state];
                       }
                            progress:nil
                           completed:completedBlock];
}

- (void)zc_sd_setImageLoadOperation:(id<ZC_SDWebImageOperation>)operation forState:(UIControlState)state {
    [self zc_sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)zc_sd_cancelImageLoadForState:(UIControlState)state {
    [self zc_sd_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)zc_sd_setBackgroundImageLoadOperation:(id<ZC_SDWebImageOperation>)operation forState:(UIControlState)state {
    [self zc_sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (void)zc_sd_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self zc_sd_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (SDStateImageURLDictionary *)imageURLStorage {
    SDStateImageURLDictionary *storage = objc_getAssociatedObject(self, &imageURLStorageKey);
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &imageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end

#endif
