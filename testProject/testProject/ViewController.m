//
//  ViewController.m
//  testProject
//
//  Created by zhoucheng on 2016/10/10.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<ZCURLDataSourceDelegate>

@property(nonatomic, strong)ZCURLDataSource * urlDataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _urlDataSource = [[ZCURLDataSource alloc] init];
    [_urlDataSource setDelegate:self];
    _urlDataSource.url = @"http://platform.sina.com.cn/client/getHotBlogger?app_key=4135432745&deviceid=11111";
    [_urlDataSource reloadData];
    
    ZCRefreshTableDataController * tableDataController = [[ZCRefreshTableDataController alloc] init];
    [tableDataController topLoadingViewWithStyle:ZCRefreshLoadingViewStyle_ActivityIndicatorSystem];
    [tableDataController bottomLoadingViewWithStyle:ZCRefreshLoadingViewStyle_ActivityIndicatorSystem];
    [tableDataController notFoundDataWithAlertText:nil imageNamed:nil];
}

- (void)ZCDataSourceDidLoadResultsData:(ZCURLDataSource *)dataSource
{
    NSLog(@"%@", dataSource.dataObject);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
