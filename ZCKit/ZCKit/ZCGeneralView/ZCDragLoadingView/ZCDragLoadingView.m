//
//  DragLoadingView.m
//  Sports
//
//  Created by tang zhoucheng on 13-4-7.
//  Copyright (c) 2013年 sina.com. All rights reserved.
//

#import "ZCDragLoadingView.h"

@implementation ZCDragLoadingView

@synthesize directImageView = _directImageView;
@synthesize downTitleLabel = _downTitleLabel;
@synthesize upTitleLabel = _upTitleLabel;
@synthesize loadingView = _loadingView;
@synthesize loadingTitleLabel = _loadingTitleLabel;
@synthesize animating = _animating;
@synthesize direct = _direct;
@synthesize timeLabel = _timeLabel;
@synthesize leftTitleLabel = _leftTitleLabel;
@synthesize rightTitleLabel = _rightTitleLabel;
@synthesize offsetValue = _offsetValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) startAnimation{
    if(! _animating){
        
        [_loadingView setHidden:NO];
        
        if([_loadingView respondsToSelector:@selector(startAnimating)]){
            [_loadingView performSelector:@selector(startAnimating) withObject:nil];
        }
        [_directImageView setHidden:YES];
        [_downTitleLabel setHidden:YES];
        [_upTitleLabel setHidden:YES];
        [_leftTitleLabel setHidden:YES];
        [_rightTitleLabel setHidden:YES];
        [_loadingTitleLabel setHidden:NO];
        
        _animating = YES;
    }
}

-(void) stopAnimation{
    
    if( _animating ){
        if([_loadingView respondsToSelector:@selector(stopAnimating)]){
            [_loadingView performSelector:@selector(stopAnimating) withObject:nil];
        }
        //[_loadingView setHidden:YES];
        [_loadingTitleLabel setHidden:YES];
        [_directImageView setHidden:NO];
        [_upTitleLabel setHidden:_direct != ZCDragLoadingViewDirectUp];
        [_downTitleLabel setHidden:_direct != ZCDragLoadingViewDirectDown];
        [_leftTitleLabel setHidden:_direct != ZCDragLoadingViewDirectLeft];
        [_rightTitleLabel setHidden:_direct != ZCDragLoadingViewDirectRight];
        
        _animating = NO;
    }
    
//    if( self.animating ){
//        if([self.loadingView respondsToSelector:@selector(stopAnimating)]){
//            [self.loadingView performSelector:@selector(stopAnimating) withObject:nil];
//        }
//        
//        self.animating = NO;
//    }
}

-(void) setDirect:(ZCDragLoadingViewDirect)direct{
    _direct = direct;
    
    if( ! _animating){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
   
    switch (_direct) {
        case ZCDragLoadingViewDirectDown:
        {
            [_directImageView setTransform:CGAffineTransformIdentity];
            [_upTitleLabel setHidden:YES];
            [_leftTitleLabel setHidden:YES];
            [_rightTitleLabel setHidden:YES];
            [_downTitleLabel setHidden: _animating];
        }
            break;
        case ZCDragLoadingViewDirectUp:
        {
            [_directImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
            [_downTitleLabel setHidden:YES];
            [_leftTitleLabel setHidden:YES];
            [_rightTitleLabel setHidden:YES];
            [_upTitleLabel setHidden: _animating];
        }
            break;
        case ZCDragLoadingViewDirectLeft:
        {
            [_directImageView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            [_downTitleLabel setHidden:YES];
            [_rightTitleLabel setHidden:YES];
            [_upTitleLabel setHidden:YES];
            [_leftTitleLabel setHidden: _animating];
        }
            break;
        case ZCDragLoadingViewDirectRight:
        {
            [_directImageView setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
            [_downTitleLabel setHidden:YES];
            [_leftTitleLabel setHidden:YES];
            [_upTitleLabel setHidden:YES];
            [_rightTitleLabel setHidden: _animating];
        }
            break;
        default:
            break;
    }
   
    if( ! _animating){
    
        [UIView commitAnimations];
    }

}

-(void) setOffsetValue:(CGFloat)offsetValue{
    _offsetValue = offsetValue;
    if([_loadingView respondsToSelector:@selector(setOffsetValue:)]){
        [(ZCDragLoadingView*)_loadingView setOffsetValue:offsetValue];
//        [_loadingView performSelector:@selector(setOffsetValue:) withObject:[NSNumber numberWithFloat:offsetValue]];
    }
}

@end
