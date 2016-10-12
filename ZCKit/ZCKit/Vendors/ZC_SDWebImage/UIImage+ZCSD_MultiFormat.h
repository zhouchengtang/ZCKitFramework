/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "ZC_SDWebImageCompat.h"
#import "NSData+ZCSD_ImageContentType.h"

@interface UIImage (ZCSD_MultiFormat)

+ (nullable UIImage *)zc_sd_imageWithData:(nullable NSData *)data;
- (nullable NSData *)zc_sd_imageData;
- (nullable NSData *)zc_sd_imageDataAsFormat:(ZC_SDImageFormat)imageFormat;

@end
