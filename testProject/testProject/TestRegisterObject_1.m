//
//  TestRegisterObject_1.m
//  testProject
//
//  Created by tangzhoucheng on 16/10/19.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "TestRegisterObject_1.h"

@interface TestRegisterObject_1()<ZCURLDataSourceDelegate>

@property(nonatomic, strong)ZCURLDataSource * urlDataSource;

@end

@implementation TestRegisterObject_1

- (void)reloadURLWithURLString:(NSString *)url
{
    if (!_urlDataSource) {
        _urlDataSource = [[ZCURLDataSource alloc] init];
    }
    [_urlDataSource setDelegate:self];
    //_urlDataSource.url = @"http://platform.sina.com.cn/client/getHotBlogger?app_key=4135432745&deviceid=11111";
    _urlDataSource.url = url;
    [_urlDataSource reloadData];
}

- (void)reloadURLDefaultWithURL
{
    if (!_urlDataSource) {
        _urlDataSource = [[ZCURLDataSource alloc] init];
    }
    [_urlDataSource setDelegate:self];
    _urlDataSource.url = @"http://platform.sina.com.cn/client/getHotBlogger?app_key=4135432745&deviceid=11111";
    //_urlDataSource.url = url;
    [_urlDataSource reloadData];
}

- (void)ZCDataSourceDidLoaded:(ZCURLDataSource *)dataSource
{
    self.objectURLResultsCallback(dataSource.dataObject, self);
}

- (NSString *)getCurrentCalssName
{
    return NSStringFromClass([self class]);
}

- (id)getValueForObject:(id)object
{
    return object;
}

@end
