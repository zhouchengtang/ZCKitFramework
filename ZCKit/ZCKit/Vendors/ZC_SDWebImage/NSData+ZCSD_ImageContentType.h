/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "ZC_SDWebImageCompat.h"

typedef NS_ENUM(NSInteger, ZC_SDImageFormat) {
    ZC_SDImageFormatUndefined = -1,
    ZC_SDImageFormatJPEG = 0,
    ZC_SDImageFormatPNG,
    ZC_SDImageFormatGIF,
    ZC_SDImageFormatTIFF,
    ZC_SDImageFormatWebP
};

@interface NSData (ZCImageContentType)

/**
 *  Return image format
 *
 *  @param data the input image data
 *
 *  @return the image format as `SDImageFormat` (enum)
 */
+ (ZC_SDImageFormat)zc_sd_imageFormatForImageData:(nullable NSData *)data;

@end
