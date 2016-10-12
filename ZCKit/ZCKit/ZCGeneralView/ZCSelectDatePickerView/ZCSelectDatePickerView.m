//
//  CustomSelectDateView.m
//  PrivateAccountBook
//
//  Created by JiaPin on 14-6-24.
//  Copyright (c) 2014年 JiaPin. All rights reserved.
//

#import "ZCSelectDatePickerView.h"
#import "UIColor+ZCHEX.h"
#import "UIView+ZCUtilities.h"

@implementation ZCSelectDatePickerView

@synthesize delegate = _delegate, currentDate = _currentDate;

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    [_datePicker setDate:currentDate animated:NO];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        //datePicker.frame = CGRectMake(0, 0, 1024, 400);
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePickerMode = UIDatePickerModeDate;
        NSDateFormatter * df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        //[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //[[NSDate alloc]initWithString:@"2000-01-01 00:00:00 -0500"];
        NSDate* maxDate = [NSDate date];
        _datePicker.maximumDate = maxDate;
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_datePicker];
    }
    return self;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    _datePickerMode = datePickerMode;
    _datePicker.datePickerMode = datePickerMode;
}

- (void)dateChange:(UIDatePicker *)datePicker
{
    if ([_delegate respondsToSelector:@selector(selectDatePickerView:dateDidChange:)]) {
        [_delegate selectDatePickerView:self dateDidChange:_datePicker.date];
    }
}

- (void)setMaxmumDate:(NSDate *)maxnumDate
{
    [_datePicker setMaximumDate:maxnumDate];
}

- (void)setMinmumDate:(NSDate *)minmumDate
{
    [_datePicker setMinimumDate:minmumDate];
}

- (void)showInView:(UIView *)view
{
    if (!_selectDatePickerBg) {
        _selectDatePickerBg = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _selectDatePickerBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBgTapAciton)];
        [_selectDatePickerBg addGestureRecognizer:tapGesture];
        
        _datePicker.height = 216;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_selectDatePickerBg addSubview:_datePicker];
        
        if (_inputView) {
            _inputView.frame = CGRectMake(0, _datePicker.y - _inputView.height, _inputView.width, _inputView.height);
            [_selectDatePickerBg addSubview:_inputView];
        }
    }
    
    if (_inputView) {
        _inputView.y = _selectDatePickerBg.height;
        _datePicker.y = _selectDatePickerBg.height + _inputView.height;
    }else{
        _datePicker.y = _selectDatePickerBg.height;
    }
    
    _selectDatePickerBg.alpha = 1;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_selectDatePickerBg];
    [UIView animateWithDuration:0.3 animations:^{
        
        if (_inputView) {
            _datePicker.y = _selectDatePickerBg.height - _datePicker.height;
            _inputView.y = _datePicker.y - _inputView.height;
            
        }else{
            _datePicker.y = _selectDatePickerBg.height - _datePicker.height;
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
            _datePicker.y = _selectDatePickerBg.height + _inputView.height;
        }else{
            _datePicker.y = _selectDatePickerBg.height;
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
