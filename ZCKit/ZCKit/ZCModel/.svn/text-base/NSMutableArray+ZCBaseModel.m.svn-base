//
//  ZCBaseModelArray.m
//  PrivateAccountBook
//
//  Created by zhoucheng on 15/12/4.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import "NSMutableArray+ZCBaseModel.h"
#import <objc/runtime.h>

@implementation NSMutableArray(ZCBaseModel)

@dynamic modelProperty;

static void * ModelPropertyKey = (void *)@"ModelPropertyKey";

- (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray modelProperty:(ZCBaseModelClassProperty *)modelProperty
{
    self.modelProperty = modelProperty;
    if ( NSClassFromString(modelProperty.protocol) && [NSClassFromString(modelProperty.protocol) isSubclassOfClass:[ZCBaseModel class]]) {
        for (id data in dataArray) {
            id modelValue = nil;
            if ([data isKindOfClass:[NSDictionary class]]) {
                modelValue = [(ZCBaseModel *)[NSClassFromString(modelProperty.protocol) alloc] initWithDictionary:data];
            }else{
                modelValue = data;
            }
            if (modelValue) {
                [self addObject:modelValue];
            }
        }
    }
    return self;
}

- (NSMutableArray *)dataArrayWithModelArray:(NSArray *)modelArray
{
    NSMutableArray * dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    if ( NSClassFromString(self.modelProperty.protocol) && [NSClassFromString(self.modelProperty.protocol) isSubclassOfClass:[ZCBaseModel class]] ) {
        for (id modelData in modelArray) {
            id dataValue = nil;
            if ([[modelData class] isSubclassOfClass:[ZCBaseModel class]]) {
                dataValue = [(ZCBaseModel *)modelData dictionaryWithModel];
            }else{
                dataValue = modelData;
            }
            if (dataValue) {
                [dataArray addObject:dataValue];
            }
        }
    }
    return dataArray;
}

- (void)setModelProperty:(ZCBaseModelClassProperty *)modelProperty
{
    objc_setAssociatedObject(self, ModelPropertyKey, modelProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZCBaseModelClassProperty *)modelProperty
{
    return objc_getAssociatedObject(self, ModelPropertyKey);
}

@end
