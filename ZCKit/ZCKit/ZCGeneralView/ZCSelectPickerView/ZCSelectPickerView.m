//
//  CustomSelectTypeView.m
//  PrivateAccountBook
//
//  Created by JiaPin on 14-6-24.
//  Copyright (c) 2014年 JiaPin. All rights reserved.
//

#import "ZCSelectPickerView.h"
#import "UIColor+ZCHEX.h"
#import "UIView+ZCUtilities.h"

@implementation ZCSelectPickerView

@synthesize dataArray = _dataArray, delegate = _delegate, currentSelectType = _currentSelectType;

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [_pickerView reloadAllComponents];
}

- (void)setCurrentSelectType:(NSString *)currentSelectType
{
    _currentSelectType = currentSelectType;
    for (NSUInteger i = 0; i < _dataArray.count; i++) {
        if ([_currentSelectType isEqualToString:[_dataArray objectAtIndex:i]]) {
            [_pickerView  selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        //[_pickerView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_pickerView];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return [_dataArray count];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return  50.0f;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.frame.size.width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = [self pickerView:pickerView widthForComponent:component];
    CGFloat height = [self pickerView:pickerView rowHeightForComponent:component];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width-10, height);
    UIView * returnView = [[UIView alloc]initWithFrame:rect];
    UILabel * label = [[UILabel alloc] initWithFrame:rect];
    [returnView addSubview:label];
    label.text = [_dataArray objectAtIndex:row];
    label.textAlignment = NSTextAlignmentCenter;
    return returnView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_delegate respondsToSelector:@selector(selectPickerView:didSelectRow:inComponent:selectData:)]) {
        [_delegate selectPickerView:self didSelectRow:row inComponent:component selectData:[_dataArray objectAtIndex:row]];
    }
}


- (void)showInView:(UIView *)view
{
    if (!_selectDatePickerBg) {
        _selectDatePickerBg = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _selectDatePickerBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBgTapAciton)];
        [_selectDatePickerBg addGestureRecognizer:tapGesture];
        
        _pickerView.height = 216;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_selectDatePickerBg addSubview:_pickerView];
        
        if (_inputView) {
            _inputView.frame = CGRectMake(0, _pickerView.y - _inputView.height, _inputView.width, _inputView.height);
            [_selectDatePickerBg addSubview:_inputView];
        }
    }
    
    if (_inputView) {
        _inputView.y = _selectDatePickerBg.height;
        _pickerView.y = _selectDatePickerBg.height + _inputView.height;
    }else{
        _pickerView.y = _selectDatePickerBg.height;
    }
    
    _selectDatePickerBg.alpha = 1;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_selectDatePickerBg];
    [UIView animateWithDuration:0.3 animations:^{
        
        if (_inputView) {
            _pickerView.y = _selectDatePickerBg.height - _pickerView.height;
            _inputView.y = _pickerView.y - _inputView.height;
            
        }else{
            _pickerView.y = _selectDatePickerBg.height - _pickerView.height;
        }
        //_selectDatePickerBg.alpha = 0.8;
    }completion:^(BOOL finished){}];
}

- (void)hiddenView
{
    [self selectBgTapAciton];
}

- (void)selectBgTapAciton
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectDatePickerBg.alpha = 0;
        if (_inputView) {
            _inputView.y = _selectDatePickerBg.height;
            _pickerView.y = _selectDatePickerBg.height + _inputView.height;
        }else{
            _pickerView.y = _selectDatePickerBg.height;
        }
    }completion:^(BOOL finished){
        [_selectDatePickerBg removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
