//
//  BaseTestViewController.m
//  testProject
//
//  Created by zhoucheng on 2016/10/14.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "BaseTestViewController.h"

@interface BaseTestViewController ()

@end

@implementation BaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
}

- (void)back
{
    [self openUrl:[NSURL URLWithString:@"."] animated:YES object:nil callback:nil];
}

- (NSString *)navigationItemBackBarButtonTitle
{
    return @"";
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
