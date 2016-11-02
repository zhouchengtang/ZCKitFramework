//
//  UIImage+Compress.m
//  my First Love
//
//  Created by 唐周成 on 13-7-16.
//  Copyright (c) 2013年 唐周成. All rights reserved.
//

#import "UIImage+ZCCompress.h"

#define MAX_IMAGEPIX 500.0 // max pix 500.0px
#define MAX_IMAGEDATA_LEN 50000.0 // max data length 5K

@implementation UIImage (ZCCompress)

-(UIImage *)compressedImage:(CGSize)size{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= size.width && height <= size.height) {
        // no need to compress.
        return self;
    }
    
    if (width == 0 || height == 0) {
        // void zero exception
        return self;
    }
    
    UIImage *newImage = nil;
    CGFloat widthFactor = size.width / width;
    CGFloat heightFactor = size.height / height;
    CGFloat scaleFactor = 0.0;
    
    if (widthFactor > heightFactor)
        scaleFactor = heightFactor; // scale to fit height
    else
        scaleFactor = widthFactor; // scale to fit width
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

-(NSData *)compressedData:(CGFloat)compressionQuality {
    assert(compressionQuality <= 1.0 && compressionQuality >= 0);
    
    return UIImageJPEGRepresentation(self, compressionQuality);
}

-(CGFloat)compressionQuality {
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSUInteger dataLength = [data length];
    
    if(dataLength > MAX_IMAGEDATA_LEN) {
        return 1.0 - MAX_IMAGEDATA_LEN / dataLength;
    } else {
        return 1.0;
    }
}

-(NSData *)compressedData {
    CGFloat quality = [self compressionQuality];
    
    return [self compressedData:quality];
}

@end
