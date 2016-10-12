/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSData+ZCSD_ImageContentType.h"


@implementation NSData (ZCImageContentType)

+ (ZC_SDImageFormat)zc_sd_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return ZC_SDImageFormatUndefined;
    }
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return ZC_SDImageFormatJPEG;
        case 0x89:
            return ZC_SDImageFormatPNG;
        case 0x47:
            return ZC_SDImageFormatGIF;
        case 0x49:
        case 0x4D:
            return ZC_SDImageFormatTIFF;
        case 0x52:
            // R as RIFF for WEBP
            if (data.length < 12) {
                return ZC_SDImageFormatUndefined;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return ZC_SDImageFormatWebP;
            }
    }
    return ZC_SDImageFormatUndefined;
}

@end
