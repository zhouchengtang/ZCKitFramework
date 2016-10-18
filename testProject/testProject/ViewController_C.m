//
//  ViewController_C.m
//  testProject
//
//  Created by zhoucheng on 2016/10/14.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ViewController_C.h"

@interface ViewController_C ()

@end

@implementation ViewController_C

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIBarButtonItem * push = [[UIBarButtonItem alloc] initWithTitle:@"pop_va" style:UIBarButtonItemStylePlain target:self action:@selector(popToA)];
//    self.navigationItem.rightBarButtonItems = @[push];
    
    UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItems = @[done];
    
    NSLog(@"%@", [[ZCPContext sharedInstance] getValueForRegisterObjectURL:[NSURL URLWithString:@"value://vc-a/testGetObjectWithURL"queryValues:@{@"vid" : @"12345"}] object:@{}]);
}

- (void)popToA
{
    [self openUrl:[NSURL URLWithString:@"pop://vc-b"] animated:YES];
}

- (void)done
{
    [self openUrl:[NSURL URLWithString:@"."] animated:YES];
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
