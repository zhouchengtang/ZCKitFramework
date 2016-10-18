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

- (void)dealloc
{
    NSLog(@"ViewController dealloc");
}

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
    
    UIBarButtonItem * push = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(testButtonClicked)];
    self.navigationItem.rightBarButtonItems = @[push];
    self.navigationItem.hidesBackButton = YES;
    
    if ([[ZCPContext sharedInstance] registerObjectForURL:[NSURL URLWithString:@"register://r_test_1"]]) {
        NSLog(@"%@", [[ZCPContext sharedInstance] getValueForRegisterObjectURL:[NSURL URLWithString:@"register://r_test_1/getCurrentCalssName"] object:nil]);
        NSLog(@"%@", [[ZCPContext sharedInstance] getValueForRegisterObjectURL:[NSURL URLWithString:@"register://r_test_1/getValueForObject:"] object:@{@"key":@"value"}]);
        [[ZCPContext sharedInstance] sendRegisterObjectURL:[NSURL URLWithString:@"register://r_test_1/reloadURLWithURLString:"] object:@"http://platform.sina.com.cn/client/getHotBlogger?app_key=4135432745&deviceid=11111" callback:^(id result, id sender){
            NSLog(@"%@", result);
            NSLog(@"%@", sender);
        }];
        [[ZCPContext sharedInstance] sendRegisterObjectURL:[NSURL URLWithString:@"register://r_test_1/reloadURLDefaultWithURL"] object:nil callback:^(id result, id sender){
            NSLog(@"%@", result);
            NSLog(@"%@", sender);
        }];
    }
    [[ZCPContext sharedInstance] resignObjectForURL:[NSURL URLWithString:@"register://r_test_1"]];
}

- (void)rootButtonClick
{
    [self openUrl:[NSURL URLWithString:@"pop://root"] animated:YES object:nil callback:nil];
}

- (void)testButtonClicked
{
    [self openUrl:[NSURL URLWithString:@"push://vc-a" queryValues:@{@"vid" : @"12345"}]
         animated:YES
           object:@{@"key1":@"value1", @"key2":@"value2"}
         callback:^(id resultsData,id sender){
             NSLog(@"%@", resultsData);
             NSLog(@"%@", sender);
    }];
}

- (void)reloadNetworkData
{
    [_urlDataSource reloadData];
}

- (void)ZCDataSourceDidLoadResultsData:(ZCURLDataSource *)dataSource
{
    NSLog(@"%@", dataSource.dataObject);
    NSString * dataObjectStr = [NSString stringWithFormat:@"%@", dataSource.dataObject];
    _textView.text = [dataObjectStr makeUnicodeToString];
    if (self.objectURLResultsCallback) {
        self.objectURLResultsCallback(dataSource.dataObject, self);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
