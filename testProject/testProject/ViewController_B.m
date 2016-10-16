//
//  ViewController_B.m
//  testProject
//
//  Created by zhoucheng on 2016/10/14.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ViewController_B.h"

@interface ViewController_B ()

@property(nonatomic, strong)UINavigationController * navController;

@end

@implementation ViewController_B

- (void)setNavigationbar
{
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen width], 44+20)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //action：@selector:设置按钮的点击事件
    //创建一个按钮
    UIBarButtonItem * push = [[UIBarButtonItem alloc] initWithTitle:@"push_vc" style:UIBarButtonItemStylePlain target:self action:@selector(pushToB)];
    
    //设置导航栏的内容
    [navItem setTitle:@"导航栏"];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:YES];
    
    // 把左右两个按钮添加到导航栏集合中去
    [navItem setRightBarButtonItems:@[push]];
    
    // 将导航栏中的内容全部添加到主视图当中
    [self.view addSubview:navBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen width], 44)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.text = @"ViewController_B";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    //[self setNavigationbar];
    UIBarButtonItem * presentToC = [[UIBarButtonItem alloc] initWithTitle:@"present_vc" style:UIBarButtonItemStylePlain target:self action:@selector(presentToC)];
    self.navigationItem.rightBarButtonItems = @[presentToC];
    
    UIBarButtonItem * popRoot = [[UIBarButtonItem alloc] initWithTitle:@"pop_root" style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    UIBarButtonItem * popToVc = [[UIBarButtonItem alloc] initWithTitle:@"pop_cv_root" style:UIBarButtonItemStylePlain target:self action:@selector(popToCustomVC)];
    self.navigationItem.leftBarButtonItems = @[popRoot, popToVc];
}

- (void)popToCustomVC
{
    [self openUrl:[NSURL URLWithString:@"pop://test" queryValues:nil] animated:YES];
}

- (void)popToRoot
{
    [self openUrl:[NSURL URLWithString:@"pop://root"] animated:YES];
}

- (void)presentToC
{
    [self openUrl:[NSURL URLWithString:@"present://nav/vc-c"] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
