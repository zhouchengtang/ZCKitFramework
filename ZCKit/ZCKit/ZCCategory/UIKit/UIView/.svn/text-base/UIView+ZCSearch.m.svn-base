//
//  UIView+ZCSearch.m
//  ZCKit
//
//  Created by zhoucheng on 16/4/21.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "UIView+ZCSearch.h"

static void UIViewSearchForClass(UIView * view,Class clazz, NSMutableArray * items){
    if([view isKindOfClass:clazz]){
        [items addObject:view];
    }
    for(UIView * v in [view subviews]){
        UIViewSearchForClass(v,clazz,items);
    }
}

static void UIViewSearchForProtocol(UIView * view,Protocol * protocol, NSMutableArray * items){
    if([view conformsToProtocol:protocol]){
        [items addObject:view];
    }
    for(UIView * v in [view subviews]){
        UIViewSearchForProtocol(v,protocol,items);
    }
}

@implementation UIView (ZCSearch)

-(NSArray *) searchViewForClass:(Class) clazz{
    NSMutableArray * items = [NSMutableArray arrayWithCapacity:4];
    UIViewSearchForClass(self,clazz,items);
    return items;
}

-(NSArray *) searchViewForProtocol:(Protocol *) protocol{
    NSMutableArray * items = [NSMutableArray arrayWithCapacity:4];
    UIViewSearchForProtocol(self,protocol,items);
    return items;
}

@end
