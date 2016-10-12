//
//  VTTableViewCell.m
//  vTeam
//
//  Created by tang zhoucheng on 13-6-22.
//  Copyright (c) 2013年 zhoucheng.org. All rights reserved.
//

#import "ZCTableViewCell.h"

#import "IZCAction.h"

@implementation UITableView(ZCTableViewCell)

-(void) applyDataOutlet{
    NSArray * cells = [self visibleCells];
    if([cells count]){
        for(ZCTableViewCell * cell in cells){
            if([cell isKindOfClass:[ZCTableViewCell class]]){
                [cell setDataItem:cell.dataItem];
            }
        }
    }
}

@end

@interface ZCTableViewCell(){
    CALayer * _highlightedLayer;
}
@property(nonatomic,retain) CALayer * highlightedLayer;
@property(nonatomic,assign) BOOL isHighlighted;
@property(nonatomic,assign) BOOL isSelected;

@end


@implementation ZCTableViewCell


@synthesize nibNameOrNil = _nibNameOrNil;
@synthesize nibBundleOrNil = _nibBundleOrNil;

@synthesize dataOutletContainer = _dataOutletContainer;

@synthesize index = _index;
@synthesize userInfo = _userInfo;
@synthesize delegate = _delegate;
@synthesize dataItem = _dataItem;
@synthesize controller = _controller;
@synthesize highlightedLayer= _highlightedLayer;
@synthesize actionColor = _actionColor;


-(void)refreshHighlightedLayer
{
    if([self isHighlighted] || [self isSelected])
    {
        if(_highlightedLayer == nil){
            _highlightedLayer = [[CALayer alloc] init];
        }
        
        UIColor * actionColor = self.actionColor;
        
        if(actionColor == nil){
            _highlightedLayer.masksToBounds = YES;
            _highlightedLayer.backgroundColor = [actionColor CGColor];
            
            _highlightedLayer.frame = self.bounds;
            [_highlightedLayer removeFromSuperlayer];
            
        }
        else
        {
            _highlightedLayer.masksToBounds = YES;
            _highlightedLayer.backgroundColor = [actionColor CGColor];
            
            _highlightedLayer.frame = self.bounds;
            
            [self.layer addSublayer:_highlightedLayer];
        }
    }
    else
    {
        [_highlightedLayer removeFromSuperlayer];
    }
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self touchesBegan:location];

    [super touchesBegan:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self touchesEnded:location];
    
    [super touchesEnded:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self touchesCancelled:location];
    
    [super touchesCancelled:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self touchesMoved:location];
    
    [super touchesMoved:touches withEvent:event];
}

- (BOOL)touchesBegan:(CGPoint) location{
    CGSize size = self.frame.size;
    if(location.x >=0 && location.y >=0 && location.x < size.width && location.y < size.height){
        [self setHighlighted:YES];
    }
    return NO;
}

- (void)touchesMoved:(CGPoint) location{
    CGSize size = self.frame.size;
    if(location.x < 0 || location.y < 0 || location.x >= size.width || location.y >= size.height){
        [self setHighlighted:NO];
    }
}

- (void)touchesEnded:(CGPoint) location{
    [self setHighlighted:NO];
}

- (void)touchesCancelled:(CGPoint) location{
    [self setHighlighted:NO];
}


-(void)setActionColor:(UIColor *)actionColor
{
    if (_actionColor!=actionColor) {
        _actionColor = actionColor;
        
    }
}

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    self.isHighlighted = highlighted;
    [self refreshHighlightedLayer];
}

-(void) setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.isSelected = selected;
    [self refreshHighlightedLayer];
}


+(id) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    UIViewController * viewController = [[UIViewController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    UIView * view = [viewController view];
    
    if([view isKindOfClass:[ZCTableViewCell class]]){
        
        return view;
    }
    
    return nil;
}


-(IBAction) doAction :(id)sender{
    if([sender conformsToProtocol:@protocol(IZCAction)]){
        if([_delegate respondsToSelector:@selector(ZCTableViewCell:doAction:)]){
            [_delegate ZCTableViewCell:self doAction:sender];
        }
    }
}

-(void) setDataItem:(id)dataItem{
    if(_dataItem != dataItem){
        _dataItem = dataItem;
        [_dataOutletContainer applyDataOutlet:self];
    }
    else{
        [_dataOutletContainer applyDataOutlet:self];
    }
}


@end
