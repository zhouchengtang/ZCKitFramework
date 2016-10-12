//
//  ZCImageView.m
//  ZCKit
//
//  Created by zhoucheng on 16/4/21.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "ZCImageView.h"
#import "UIColor+ZCHEX.h"

@implementation ZCImageView

@synthesize src = _src;
@synthesize loading = _loading;
@synthesize defaultImage = _defaultImage;
@synthesize loaded = _loaded;
@synthesize defaultSrc = _defaultSrc;
@synthesize reuseFileURI = _reuseFileURI;
@synthesize localAsyncLoad = _localAsyncLoad;
@synthesize cornerRadius = _cornerRadius;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius != cornerRadius && cornerRadius > 0) {
        self.layer.cornerRadius = cornerRadius;
        [self.layer setMasksToBounds:YES];
        _cornerRadius = cornerRadius;
    }
}

-(void) setImage:(UIImage *)image{
    [self setImage:image isLocal:NO];
}

-(void) setImage:(UIImage *) image isLocal:(BOOL) isLocal{
    if(image == nil){
        if(!isLocal){
            self.loaded = YES;
        }
        [super setImage:_defaultImage];
    }
    else{
        self.loaded = YES;
        [super setImage:image];
    }
    if((_fitHeight || _fitWidth) && self.image){
        CGSize imageSize = [self.image size];
        CGRect r = [self frame];
        
        if(_fitWidth){
            
            if(r.size.width && r.size.height && imageSize.width && imageSize.height){
                
                if(r.size.width / r.size.height != imageSize.width / imageSize.height){
                    r.size.width = imageSize.width / imageSize.height * r.size.height;
                    
                    if(_maxWidth && r.size.width > _maxWidth){
                        r.size.width = _maxWidth;
                    }
                    
                    [self setFrame:r];
                }
                
            }
            
        }
        
        if(_fitHeight){
            
            if(r.size.width && r.size.height && imageSize.width && imageSize.height){
                
                if(r.size.width / r.size.height != imageSize.width / imageSize.height){
                    
                    r.size.height = imageSize.height / imageSize.width * r.size.width;
                    
                    if(_maxHeight && r.size.height > _maxHeight){
                        r.size.height = _maxHeight;
                    }
                    
                    [self setFrame:r];
                }
                
            }
            
        }
    }
}

-(void) setDefaultImage:(UIImage *)defaultImage{
    if(_defaultImage != defaultImage){
        if([self image] == _defaultImage){
            [super setImage:nil];
        }
        _defaultImage = defaultImage;
        if(self.image == nil){
            [super setImage:_defaultImage];
        }
    }
}

- (void) setDefaultSrc:(NSString *)defaultSrc
{
    _defaultSrc = defaultSrc;
    if (defaultSrc) {
        [self setDefaultImage:[UIImage imageNamed:defaultSrc]];
    }
}

-(void) setSrc:(NSString *)src{
    if(_src != src && ! [_src isEqualToString:src]){
        _src = src;
        self.loaded = NO;
        [super setImage:_defaultImage];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(NSString *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor =  [UIColor colorWithHexString:borderColor].CGColor;
}

@end
