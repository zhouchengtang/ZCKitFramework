//
//  ViewController_A.m
//  testProject
//
//  Created by zhoucheng on 2016/10/14.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ViewController_A.h"

@interface ViewController_A ()

- (IBAction)callbackButtonAction:(id)sender;

@end

@implementation ViewController_A

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * push = [[UIBarButtonItem alloc] initWithTitle:@"push_vb" style:UIBarButtonItemStylePlain target:self action:@selector(pushToB)];
    self.navigationItem.rightBarButtonItems = @[push];
}

- (void)pushToB
{
    [self openUrl:[NSURL URLWithString:@"push://vc-b"] animated:YES object:nil callback:nil];
}

- (id)testGetObjectWithURL
{
    return @"testGetObjectWithURL";
}

- (id)testGetObjectWithURL:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        return @[@"testArray", @"testArray"];
    }else if ([object isKindOfClass:[NSDictionary class]])
    {
        return @{@"testKey":@"testValue"};
    }
    return nil;
}

- (IBAction)callbackButtonAction:(id)sender
{
    self.viewControllerCallback(self.url, self);
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
