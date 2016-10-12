/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#ifdef SD_WEBP

#import "ZC_SDWebImageCompat.h"

@interface UIImage (ZCSD_WebP)

+ (nullable UIImage *)zc_sd_imageWithWebPData:(nullable NSData *)data;

@end

#endif
