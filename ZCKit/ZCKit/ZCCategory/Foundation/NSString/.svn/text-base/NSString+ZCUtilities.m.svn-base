//
//  NSString+ZCUtilitiesy.m
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/11/28.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import "NSString+ZCUtilities.h"
#import "NSData+ZCMD5.h"

@implementation NSString(ZCUtilities)

-(NSString *) zcMD5String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zcMD5String];
}

- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (CGSize)ZCSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    /*iOS9由于字体变化，所以为了在界面显示上不出错，就算是固定长度的文字也还是建议使用对size向上取整 ceilf()*/
    if ([self getCurDeviceVersion]<7.0) {
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    }else{
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        if ([self getCurDeviceVersion] < 9.0) {
            return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        }else{
            CGSize currentSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            CGSize adjustedSize = CGSizeMake(ceilf(currentSize.width), ceilf(currentSize.height));
            return adjustedSize;
        }
    }
}

- (CGSize)ZCSizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode{
    /*iOS9由于字体变化，所以为了在界面显示上不出错，就算是固定长度的文字也还是建议使用对size向上取整 ceilf()*/
    if ([self respondsToSelector:@selector(sizeWithFont:minFontSize:actualFontSize:forWidth:lineBreakMode:)]) {
        if ([self getCurDeviceVersion] < 9.0) {
            return [self sizeWithFont:font minFontSize:minFontSize actualFontSize:actualFontSize forWidth:width lineBreakMode:NSLineBreakByClipping];
        }else{
            CGSize currentSize = [self sizeWithFont:font minFontSize:minFontSize actualFontSize:actualFontSize forWidth:width lineBreakMode:NSLineBreakByClipping];
            CGSize adjustedSize = CGSizeMake(ceilf(currentSize.width), ceilf(currentSize.height));
            return adjustedSize;
        }
    }else{
        NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
        drawingContext.minimumScaleFactor = minFontSize/[font pointSize]; // Half the font size
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        
        CGSize s = [self boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:drawingContext].size;
        *actualFontSize = drawingContext.actualScaleFactor*[font pointSize];
        if ([self getCurDeviceVersion] < 9.0) {
            return s;
        }else{
            CGSize adjustedSize = CGSizeMake(ceilf(s.width), ceilf(s.height));
            return adjustedSize;
        }
        
    }
}

- (void)ZCDrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color:(UIColor *)color{
    if ([self getCurDeviceVersion]<7.0) {
        [self drawInRect:rect
                withFont:font lineBreakMode:lineBreakMode alignment:alignment];
    }else{
        NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
        drawingContext.minimumScaleFactor = 0.5;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        paragraphStyle.alignment = alignment;
        NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:color};
        [self drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:drawingContext];
    }
}

- (float)getCurDeviceVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)stringWithJsonObject:(id)jsonObject
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString *)stringWidthPositiveFormat:(NSString *)format
{
    NSNumberFormatter *formatter  = [[NSNumberFormatter alloc] init];
    
    [formatter setPositiveFormat:format];
    
    return [formatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
}

- (instancetype)toJsonObject
{
    NSError * error;
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];

}

- (NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *destDate= [dateFormatter dateFromString:self];
    return destDate;
}

@end
