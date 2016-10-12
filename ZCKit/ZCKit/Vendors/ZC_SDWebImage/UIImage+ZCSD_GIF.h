/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Laurin Brandner
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "ZC_SDWebImageCompat.h"

@interface UIImage (ZCSD_GIF)

/**
 *  Compatibility method - creates an animated UIImage from an NSData, it will only contain the 1st frame image
 */
+ (UIImage *)zc_sd_animatedGIFWithData:(NSData *)data;

/**
 *  Checks if an UIImage instance is a GIF. Will use the `images` array
 */
- (BOOL)isGIF;

@end
