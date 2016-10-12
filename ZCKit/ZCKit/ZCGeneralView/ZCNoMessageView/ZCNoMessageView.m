//
//  SFNoMessageView.m
//  SinaFinance
//
//  Created by Sina_Mobile on 15/4/15.
//  Copyright (c) 2015年 sina.com. All rights reserved.
//

#import "ZCNoMessageView.h"
#import "UIColor+ZCHEX.h"

#define NO_MESSAGE_IMAGE_HEIGHT 82
#define NO_MESSAGE_LABEL_HEIGHT 25

@implementation ZCNoMessageView
{
    UIImageView * _imageView;
    UILabel * _textLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGPoint)getCurrentPoint
{
    return CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (void)initContentView
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat image_y = [self getCurrentPoint].y - NO_MESSAGE_IMAGE_HEIGHT;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake([self getCurrentPoint].x - NO_MESSAGE_IMAGE_HEIGHT / 2 , ((image_y > 0) ? image_y : 0 ), NO_MESSAGE_IMAGE_HEIGHT, NO_MESSAGE_IMAGE_HEIGHT)];
    [_imageView setImage:[UIImage imageNamed:@"icon_NoMessageTrad2.png"]];
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.frame.origin.y + _imageView.frame.size.height, self.frame.size.width, NO_MESSAGE_LABEL_HEIGHT)];
    _textLabel.text = @"暂无数据";
    _textLabel.backgroundColor = self.backgroundColor;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor colorWithHex:0xCCCCCC andAlpha:1];
    _textLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_textLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initContentView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initContentView];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self stepSubViewFrame];
}

- (void)setShowImageNamed:(NSString *)showImageNamed
{
    [_imageView setImage:[UIImage imageNamed:showImageNamed]];
}

- (void)setShowLabelText:(NSString *)showLabelText
{
    [_textLabel setText:showLabelText];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"对找不着的key(%@)调用此方法", key);
}

- (void)layoutSubviews
{
    [self stepSubViewFrame];
}

- (void)stepSubViewFrame
{
    CGFloat image_y = [self getCurrentPoint].y - NO_MESSAGE_IMAGE_HEIGHT;
    
    _imageView.frame = CGRectMake([self getCurrentPoint].x - NO_MESSAGE_IMAGE_HEIGHT / 2 , ((image_y > 0) ? image_y : 0), NO_MESSAGE_IMAGE_HEIGHT, NO_MESSAGE_IMAGE_HEIGHT);
    _textLabel.frame = CGRectMake(0, _imageView.frame.origin.y + _imageView.frame.size.height, self.frame.size.width, NO_MESSAGE_LABEL_HEIGHT);
}


@end
