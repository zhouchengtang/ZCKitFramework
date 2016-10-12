//
//  CustomSelectDateView.h
//  PrivateAccountBook
//
//  Created by ； on 14-6-24.
//  Copyright (c) 2014年 JiaPin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCSelectDatePickerView;
@protocol ZCSelectDatePickerViewDelegate <NSObject>

- (void)selectDatePickerView:(ZCSelectDatePickerView *)selectDateView dateDidChange:(NSDate *)date;

@end

@interface ZCSelectDatePickerView : UIView
{
    UIDatePicker * _datePicker;
    UIView * _selectDatePickerBg;
}

@property(nonatomic, strong)id <ZCSelectDatePickerViewDelegate> delegate;
@property(nonatomic, strong)NSDate * currentDate;
@property(nonatomic, strong)NSDate * maxmumDate;
@property(nonatomic, strong)NSDate * minmumDate;
@property(nonatomic, assign)UIDatePickerMode datePickerMode;
@property(nonatomic, strong)UIView * inputView;

- (void)showInView:(UIView *)view;

- (void)hiddenView;

@end
