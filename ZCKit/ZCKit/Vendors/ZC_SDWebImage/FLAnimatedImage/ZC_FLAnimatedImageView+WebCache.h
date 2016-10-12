/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "ZC_SDWebImageCompat.h"

#if SD_UIKIT

#if COCOAPODS
@import ZC_FLAnimatedImage;
#else
#import "ZC_FLAnimatedImageView.h"
#endif

#import "ZC_SDWebImageManager.h"


/**
 *  A category for the ZC_FLAnimatedImage imageView class that hooks it to the ZC_SDWebImage system.
 *  Very similar to the base class category (UIImageView (WebCache))
 */
@interface ZC_FLAnimatedImageView (WebCache)

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)zc_sd_setImageWithURL:(nullable NSURL *)url;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)zc_sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 *  @param url         The url for the image.
 *  @param placeholder The image to be set initially, until the image request finishes.
 *  @param options     The options to use when downloading the image. @see ZC_SDWebImageOptions for the possible values.
 */
- (void)zc_sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(ZC_SDWebImageOptions)options;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 *
 *  @param url            The url for the image.
 *  @param completedBlock A block called when operation has been completed. This block has no return value
 *                        and takes the requested UIImage as first parameter. In case of error the image parameter
 *                        is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                        indicating if the image was retrieved from the local cache or from the network.
 *                        The fourth parameter is the original image url.
 */
- (void)zc_sd_setImageWithURL:(nullable NSURL *)url
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 *  @param url            The url for the image.
 *  @param placeholder    The image to be set initially, until the image request finishes.
 *  @param completedBlock A block called when operation has been completed. This block has no return value
 *                        and takes the requested UIImage as first parameter. In case of error the image parameter
 *                        is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                        indicating if the image was retrieved from the local cache or from the network.
 *                        The fourth parameter is the original image url.
 */
- (void)zc_sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 *  @param url            The url for the image.
 *  @param placeholder    The image to be set initially, until the image request finishes.
 *  @param options        The options to use when downloading the image. @see ZC_SDWebImageOptions for the possible values.
 *  @param completedBlock A block called when operation has been completed. This block has no return value
 *                        and takes the requested UIImage as first parameter. In case of error the image parameter
 *                        is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                        indicating if the image was retrieved from the local cache or from the network.
 *                        The fourth parameter is the original image url.
 */
- (void)zc_sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(ZC_SDWebImageOptions)options
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 *  @param url            The url for the image.
 *  @param placeholder    The image to be set initially, until the image request finishes.
 *  @param options        The options to use when downloading the image. @see ZC_SDWebImageOptions for the possible values.
 *  @param progressBlock  A block called while image is downloading
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock A block called when operation has been completed. This block has no return value
 *                        and takes the requested UIImage as first parameter. In case of error the image parameter
 *                        is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                        indicating if the image was retrieved from the local cache or from the network.
 *                        The fourth parameter is the original image url.
 */
- (void)zc_sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(ZC_SDWebImageOptions)options
                  progress:(nullable ZC_SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

#endif
