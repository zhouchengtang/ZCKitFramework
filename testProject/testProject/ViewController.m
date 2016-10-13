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
@property(nonatomic, strong)IBOutlet ZCTextView * textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView = [[ZCTextView alloc] initWithFrame:self.view.bounds];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_textView setText:@"loading"];
    [self.view addSubview:_textView];
    // Do any additional setup after loading the view, typically from a nib.
    _urlDataSource = [[ZCURLDataSource alloc] init];
    [_urlDataSource setDelegate:self];
    _urlDataSource.url = @"http://platform.sina.com.cn/client/getHotBlogger?app_key=4135432745&deviceid=11111";
    [_urlDataSource reloadData];
    
    ZCRefreshTableDataController * tableDataController = [[ZCRefreshTableDataController alloc] init];
    [tableDataController topLoadingViewWithStyle:ZCRefreshLoadingViewStyle_ActivityIndicatorSystem];
    [tableDataController bottomLoadingViewWithStyle:ZCRefreshLoadingViewStyle_ActivityIndicatorSystem];
    [tableDataController notFoundDataWithAlertText:nil imageNamed:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(testButtonClicked)];
}

- (void)testButtonClicked
{
    [self.navigationController pushViewController:[[ZCPContext sharedInstance] getViewController:[NSURL URLWithString:@"zckit://test/test"]] animated:true];
}

- (void)ZCDataSourceDidLoadResultsData:(ZCURLDataSource *)dataSource
{
    NSLog(@"%@", dataSource.dataObject);
    NSString * dataObjectStr = [NSString stringWithFormat:@"%@", dataSource.dataObject];
    _textView.text = [dataObjectStr makeUnicodeToString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
