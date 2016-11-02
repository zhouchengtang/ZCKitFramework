//
//  UIImage+Compress.h
//  my First Love
//
//  Created by 唐周成 on 13-7-16.
//  Copyright (c) 2013年 唐周成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZCCompress)

-(UIImage *)compressedImage:(CGSize)size;

-(CGFloat)compressionQuality;

-(NSData *)compressedData;

-(NSData *)compressedData:(CGFloat)compressionQuality;

@end
