//
//  ZCNavigationController.m
//  zTeam
//
//  Created by t_zc on 16/1/19.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "ZCNavigationController.h"

@implementation ZCNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setNavigationBarColor:(UIColor *)color
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.navigationBar.barTintColor = color;
        [UIToolbar appearance].barTintColor = color;
        self.tabBarController.tabBar.barTintColor = color;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
