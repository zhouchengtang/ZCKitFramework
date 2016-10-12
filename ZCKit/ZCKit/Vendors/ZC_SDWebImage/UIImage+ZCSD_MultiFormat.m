/*
 * This file is part of the ZC_SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+ZCSD_MultiFormat.h"
#import "UIImage+ZCSD_GIF.h"
#import "NSData+ZCSD_ImageContentType.h"
#import <ImageIO/ImageIO.h>

#ifdef SD_WEBP
#import "UIImage+ZCSD_WebP.h"
#endif

@implementation UIImage (ZCSD_MultiFormat)

+ (nullable UIImage *)zc_sd_imageWithData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    
    UIImage *image;
    ZC_SDImageFormat imageFormat = [NSData zc_sd_imageFormatForImageData:data];
    if (imageFormat == ZC_SDImageFormatGIF) {
        image = [UIImage zc_sd_animatedGIFWithData:data];
    }
#ifdef SD_WEBP
    else if (imageFormat == ZC_SDImageFormatWebP)
    {
        image = [UIImage zc_sd_imageWithWebPData:data];
    }
#endif
    else {
        image = [[UIImage alloc] initWithData:data];
#if SD_UIKIT || SD_WATCH
        UIImageOrientation orientation = [self zc_sd_imageOrientationFromImageData:data];
        if (orientation != UIImageOrientationUp) {
            image = [UIImage imageWithCGImage:image.CGImage
                                        scale:image.scale
                                  orientation:orientation];
        }
#endif
    }


    return image;
}

#if SD_UIKIT || SD_WATCH
+(UIImageOrientation)zc_sd_imageOrientationFromImageData:(nonnull NSData *)imageData {
    UIImageOrientation result = UIImageOrientationUp;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (imageSource) {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (properties) {
            CFTypeRef val;
            int exifOrientation;
            val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
            if (val) {
                CFNumberGetValue(val, kCFNumberIntType, &exifOrientation);
                result = [self zc_sd_exifOrientationToiOSOrientation:exifOrientation];
            } // else - if it's not set it remains at up
            CFRelease((CFTypeRef) properties);
        } else {
            //NSLog(@"NO PROPERTIES, FAIL");
        }
        CFRelease(imageSource);
    }
    return result;
}

#pragma mark EXIF orientation tag converter
// Convert an EXIF image orientation to an iOS one.
// reference see here: http://sylvana.net/jpegcrop/exif_orientation.html
+ (UIImageOrientation) zc_sd_exifOrientationToiOSOrientation:(int)exifOrientation {
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (exifOrientation) {
        case 1:
            orientation = UIImageOrientationUp;
            break;

        case 3:
            orientation = UIImageOrientationDown;
            break;

        case 8:
            orientation = UIImageOrientationLeft;
            break;

        case 6:
            orientation = UIImageOrientationRight;
            break;

        case 2:
            orientation = UIImageOrientationUpMirrored;
            break;

        case 4:
            orientation = UIImageOrientationDownMirrored;
            break;

        case 5:
            orientation = UIImageOrientationLeftMirrored;
            break;

        case 7:
            orientation = UIImageOrientationRightMirrored;
            break;
        default:
            break;
    }
    return orientation;
}
#endif

- (nullable NSData *)zc_sd_imageData {
    return [self zc_sd_imageDataAsFormat:ZC_SDImageFormatUndefined];
}

- (nullable NSData *)zc_sd_imageDataAsFormat:(ZC_SDImageFormat)imageFormat {
    NSData *imageData = nil;
    if (self) {
#if SD_UIKIT || SD_WATCH
        int alphaInfo = CGImageGetAlphaInfo(self.CGImage);
        BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                          alphaInfo == kCGImageAlphaNoneSkipFirst ||
                          alphaInfo == kCGImageAlphaNoneSkipLast);
        
        BOOL usePNG = hasAlpha;
        
        // the imageFormat param has priority here. But if the format is undefined, we relly on the alpha channel
        if (imageFormat != ZC_SDImageFormatUndefined) {
            usePNG = (imageFormat == ZC_SDImageFormatPNG);
        }
        
        if (usePNG) {
            imageData = UIImagePNGRepresentation(self);
        } else {
            imageData = UIImageJPEGRepresentation(self, (CGFloat)1.0);
        }
#else
        NSBitmapImageFileType imageFileType = NSJPEGFileType;
        if (imageFormat == ZC_SDImageFormatGIF) {
            imageFileType = NSGIFFileType;
        } else if (imageFormat == ZC_SDImageFormatPNG) {
            imageFileType = NSPNGFileType;
        }
        
        imageData = [NSBitmapImageRep representationOfImageRepsInArray:self.representations
                                                             usingType:imageFileType
                                                            properties:@{}];
#endif
    }
    return imageData;
}


@end
