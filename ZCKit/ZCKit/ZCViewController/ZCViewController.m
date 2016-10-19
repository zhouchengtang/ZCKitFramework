//
//  ZCViewController.m
//  zTeam
//
//  Created by t_zc on 16/1/19.
//  Copyright © 2016年 t_zc. All rights reserved.
//


#import "ZCViewController.h"
#import "ZCTableView.h"
#import "UIView+ZCUtilities.h"
#import "ZCAlertView.h"
#import "ZCPContext.h"
#import "NSURL+ZCParam.h"
#import "ZCNavigationController.h"

#define CARMERA_BUTTON_WIDTH 50

#define ZCScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ZCScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ZCViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    ZCAlertView * _alertView;
}

@property(nonatomic,strong) UIActivityIndicatorView * loadingView_System;

@property(nonatomic,strong) UIView * loadingBackgroundView;

@end

@implementation ZCViewController

@synthesize parentController = _parentController;
@synthesize config = _config;
@synthesize alias = _alias;
@synthesize url = _url;
@synthesize dataOutletContainer = _dataOutletContainer;
@synthesize scheme = _scheme;
@synthesize controllers = _controllers;
@synthesize viewControllerCallback = _viewControllerCallback;
@synthesize objectURLResultsCallback = _objectURLResultsCallback;
@synthesize parameterObject = _parameterObject;

-(BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL) isDisplaced{
    return _parentController == nil && ( ![self isViewLoaded] || self.view.superview == nil);
}

#pragma mark - WaitingViewMethod

- (void)showAlertViewWithViewWithWaitingText:(NSString *)waitingText afterDelay:(NSTimeInterval)delay
{//显示提示页面，自动消失
    ZCAlertView * alertView = [[ZCAlertView alloc] initWithTitle:waitingText];
    [alertView showDuration:delay];
}

- (void)showAlertViewWithViewWithWaitingText:(NSString *)waitingText
{//显示加载数据等待页面
    if (!_alertView) {
        _alertView = [[ZCAlertView alloc] initWithTitle:waitingText];
        [_alertView show];
    }
}

- (void)hiddenAlertView
{
    if (_alertView) {
        [_alertView close];
        _alertView = nil;
    }
}

#pragma mark - showLoaddingView
- (void)showLoadingViewWithStyle:(ZCViewControllerLoadingViewStyle)loadingStyle backgroundColor:(UIColor *)backgroundColor
{
    if (loadingStyle != ZCViewControllerLoadingViewStyle_None) {
        if (backgroundColor) {
            if (!_loadingBackgroundView) {
                _loadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ZCScreenWidth, ZCScreenHeight - 64)];
            }
            [_loadingBackgroundView setBackgroundColor:backgroundColor];
            [self.view addSubview:_loadingBackgroundView];
        }
        
        UIView * baseView = nil;
        if (_loadingBackgroundView) {
            baseView = _loadingBackgroundView;
        }else{
            baseView = self.view;
        }
        
        
        UIView * activityView = nil;
        if (loadingStyle == ZCViewControllerLoadingViewStyle_System) {
            if (!_loadingView_System) {
                _loadingView_System = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,
                                                                                                0,
                                                                                                20,
                                                                                                20)];
                _loadingView_System.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            }
            _loadingView_System.hidden = NO;
            [_loadingView_System startAnimating];
            activityView = _loadingView_System;
        }
        activityView.frame = CGRectMake(ZCScreenWidth / 2 - activityView.width / 2,
                                        ZCScreenHeight / 2 - activityView.height / 2 - 64,
                                        activityView.width,
                                        activityView.height);
        [baseView addSubview:activityView];
    }
}

- (void)hiddenLoadingView
{
    if (_loadingView_System.superview) {
        [_loadingView_System removeFromSuperview];
    }
    if (_loadingBackgroundView.superview){
        [_loadingBackgroundView removeFromSuperview];
    }
}

- (void)initTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)tableViewStylel
{
    _contentTableView = [[ZCTableView alloc] initWithFrame:frame style:tableViewStylel];
    if (tableViewStylel == UITableViewStyleGrouped){
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {//设置tableView分割线从顶端开始，IOS7默认有一点间隙
            [_contentTableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [_contentTableView setBackgroundColor:[UIColor whiteColor]];
    }
    _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    [_contentTableView setDataSource:_tableDataController];
    [_contentTableView setDelegate:_tableDataController];
    [self.view addSubview:_contentTableView];
    
    self.tableDataController.tableView = _contentTableView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#ifdef __IPHONE_7_0
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {self.edgesForExtendedLayout = UIRectEdgeNone;}
#endif
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    if (!_tableDataController) {
        _tableDataController = [[ZCTableDataController alloc] init];
    }
    _tableDataController.delegate = self;
    _tableDataController.dataSource = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (NSMutableArray *)dataObjects
{
    if (!_dataObjects) {
        _dataObjects = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataObjects;
}

#pragma mark - KeyBoardNotifcation
#pragma mark - Key Show
-(void)keybordShown:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        NSDictionary * info = [aNotification userInfo];
        NSValue * aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize keybordSize = [aValue CGRectValue].size;
        
        CGFloat keybordSizeHight = 0;
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            keybordSizeHight = keybordSize.width;
        }else{
            keybordSizeHight = keybordSize.height;
        }
        self.contentTableView.frame = CGRectMake(self.view.bounds.origin.x, self.contentTableView.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - keybordSizeHight);
    }completion:^(BOOL finish){}];
    
}
#pragma mark - Key Hidden
-(void)keybordHidden:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentTableView.frame = self.view.bounds;
    }completion:^(BOOL finish){}];
}

#pragma mark - openUrl
- (BOOL)canOpenUrl:(NSURL *)url
{
    NSString * scheme = [url scheme];
    if ([scheme isEqualToString:@"pop"] || [[url absoluteString] isEqualToString:@"."]) {
        return YES;
    }else if ([scheme isEqualToString:@"present"]){
        return YES;
    }else if([[ZCPContext sharedInstance] getViewControllerForURL:url]) {
        return YES;
    }
    return NO;
}

- (BOOL)openUrl:(NSURL *)url animated:(BOOL)animated
{
    return [self openUrl:url animated:animated object:nil callback:nil];
}

- (BOOL)openUrl:(NSURL *)url animated:(BOOL)animated object:(id)object
{
    return [self openUrl:url animated:animated object:object callback:nil];
}

- (BOOL)openUrl:(NSURL *)url animated:(BOOL)animated callback:(ZCViewConrollerCallback)callback
{
    return [self openUrl:url animated:animated callback:callback];
}

- (BOOL)openUrl:(NSURL *)url animated:(BOOL)animated object:(id)object callback:(ZCViewConrollerCallback)callback
{
    NSString * scheme = [url scheme];
    /*
    if (url.parameters.count <= 0 && [[url.absoluteString substringWithRange:NSMakeRange(url.absoluteString.length - 1, 1)] isEqualToString:@"?"]) {
        url = [NSURL URLWithString:[url.absoluteString stringByReplacingCharactersInRange:NSMakeRange(url.absoluteString.length - 1, 1) withString:@""]];
    }
    */
    if ([[url absoluteString] isEqualToString:@"."]) {
        if ([self.scheme isEqualToString:@"present"]) {
            [self dismissViewControllerAnimated:animated completion:nil];
            [[ZCPContext sharedInstance] removeRegisterObject:self];
        }else{
            id viewController = [self.navigationController popViewControllerAnimated:animated];
            [[ZCPContext sharedInstance] removeRegisterObject:viewController];
        }
        return YES;
    }else if ([scheme isEqualToString:@"pop"]) {
        NSURL * b_url = [ZCPContext removeSchemeWithURL:url];
        if (b_url.pathComponents.count == 1 && [[b_url firstPathComponent] isEqualToString:@"root"]) {
            NSArray * popViewControllers = [self.navigationController popToRootViewControllerAnimated:animated];
            [[ZCPContext sharedInstance] removeRegisterObject:popViewControllers];
            return YES;
        }else{
            for (NSInteger i = self.navigationController.viewControllers.count - 1; i >= 0 ; i--) {
                id viewController = [self.navigationController.viewControllers objectAtIndex:i];
                if ([[[viewController url] absoluteString] isEqualToString:[b_url absoluteString]]) {
                    NSArray * popViewControllers = [self.navigationController popToViewController:viewController animated:animated];
                    [[ZCPContext sharedInstance] removeRegisterObject:popViewControllers];
                    return YES;
                }
            }
        }
    }else if([scheme isEqualToString:@"present"]){
        
        NSURL * b_url = [ZCPContext removeSchemeWithURL:url];
        id viewController = nil;
        id navigationController = nil;
        if ([[b_url firstPathComponent] isEqualToString:@"nav"]) {
            url = [NSURL URLWithString:[[url absoluteString] stringByReplacingOccurrencesOfString:@"nav/" withString:@""]];
            viewController = [[ZCPContext sharedInstance] getViewControllerForURL:url];
            navigationController = [[ZCNavigationController alloc] initWithRootViewController:viewController];
        }else{
            viewController = [[ZCPContext sharedInstance] getViewControllerForURL:url];
        }
        
        if (viewController) {
            if (object) {
                [viewController setParameterObject:object];
            }
            if (callback) {
                [viewController setViewControllerCallback:callback];
            }
            if (navigationController) {
                [self presentViewController:navigationController animated:YES completion:nil];
            }else{
                [self presentViewController:viewController animated:YES completion:nil];
            }
            return YES;
        }
    }else{
        id viewController = [[ZCPContext sharedInstance] getViewControllerForURL:url];
        if (viewController) {
            if (object) {
                [viewController setParameterObject:object];
            }
            if (callback) {
                [viewController setViewControllerCallback:callback];
            }
            [self.navigationController pushViewController:viewController animated:animated];
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
-(BOOL)navigationShouldPopOnBackButton;
{
    [self openUrl:[NSURL URLWithString:@"."] animated:YES];
    return NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




@end
