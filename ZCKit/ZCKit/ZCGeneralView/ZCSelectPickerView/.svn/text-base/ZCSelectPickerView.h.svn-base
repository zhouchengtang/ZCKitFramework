//
//  CustomSelectTypeView.h
//  PrivateAccountBook
//
//  Created by JiaPin on 14-6-24.
//  Copyright (c) 2014年 JiaPin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCSelectPickerView;

@protocol ZCSelectPickerViewDelegate <NSObject>

- (void)selectPickerView:(ZCSelectPickerView *)selectTypeView didSelectRow:(NSInteger)row inComponent:(NSInteger)component selectData:(id)data;

@end

@interface ZCSelectPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView * _pickerView;
    UIView * _selectDatePickerBg;
}

@property(nonatomic, strong)NSArray * dataArray;
@property(nonatomic, assign)id <ZCSelectPickerViewDelegate>delegate;
@property(nonatomic, strong)NSString * currentSelectType;
@property(nonatomic, strong)UIView * inputView;

- (void)showInView:(UIView *)view;

- (void)hiddenView;

@end
