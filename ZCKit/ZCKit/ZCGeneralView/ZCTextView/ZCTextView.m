//
//  AKTextView.m
//  AKBiOSProject
//
//  Created by zhoucheng on 16/4/27.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ZCTextView.h"
#import "NSString+ZCSize.h"

@interface ZCTextView()

@property(nonatomic,retain) UILabel * placeholderLabel;

@end

@implementation ZCTextView
@synthesize actionName = _actionName;
@synthesize userInfo = _userInfo;
@synthesize actionViews = _actionViews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(didTextChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        
        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(didTextChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void) dealloc{
    
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) sizeToFit{
    [super sizeToFit];
    
    CGRect r = [self frame];
    
    CGSize size= self.contentSize;
    
    if(r.size.height < size.height){
        r.size.height = size.height;
        
        [self setFrame:r];
    }
    
}


-(void) didTextChanged{
    
    if([self.text length] == 0){
        if([self.placeholder length] != 0){
            
            if(_placeholderLabel == nil){
                
                int placeholderOffsetx = 11;
                if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
                {
                    placeholderOffsetx = 4;
                }
                _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(placeholderOffsetx, 6, self.bounds.size.width - 2*placeholderOffsetx, 24)];
                [_placeholderLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
                [_placeholderLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
                [_placeholderLabel setFont:self.font];
                [self addSubview:_placeholderLabel];
            }
            
            [_placeholderLabel setText:_placeholder];
            
            [_placeholderLabel setHidden:NO];
        }
    }
    else {
        [_placeholderLabel setHidden:YES];
    }
    
}

-(void) setText:(NSString *)text{
    if(_maxLength == 0 || [text textLength] <= _maxLength){
        [super setText:text];
        [self didTextChanged];
    }
}

-(void) insertText:(NSString *)text{
    
    NSString * t = [self text];
    
    [super insertText:text];
    
    if(_maxLength && [self.text textLength] > _maxLength){
        [super setText:t];
    }
    
    [self didTextChanged];
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange{
    
    NSString * t = nil;
    
    @try {
        t = [[self text] stringByReplacingCharactersInRange:selectedRange withString:markedText];
    }
    @catch (NSException *exception) {
    }
    
    if(_maxLength == 0 || [t textLength] <= _maxLength){
        
        [super setMarkedText:markedText selectedRange:selectedRange];
        
    }
    
}

-(void) unmarkText{
    
    NSString * t = [self text];
    
    [super unmarkText];
    
    if(_maxLength && [self.text textLength] > _maxLength){
        [super setText:t];
    }
    
    [self didTextChanged];
}

-(void) deleteBackward{
    [super deleteBackward];
    [self didTextChanged];
}

-(void) awakeFromNib{
    [super awakeFromNib];
    [self didTextChanged];
}


@end
