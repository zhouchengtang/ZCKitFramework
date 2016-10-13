//
//  AppDelegate.m
//  testProject
//
//  Created by zhoucheng on 2016/10/10.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "AppDelegate.h"
#import <ZCKit/ZCKit.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    UINavigationController * nav = [[ZCNavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = nav;
    
    ZCBaseModel * model = [[ZCBaseModel alloc] init];
    [model dictionaryWithModel];
    
    NSDictionary * dict = @{@"key":@"value"};
    NSLog(@"%@", [dict toJsonString]);
    
    
    NSString *const tableName = @"testTable";
    
    ZCSQDataCache * sq = [[ZCSQDataCache alloc] initDBWithName:@"test.db"];
    if (![sq isTableExists:tableName]) {
        [sq createTableWithName:tableName];
    }
//    [sq setObject:@[@"1", @"2"] withId:@"object_key" intoTable:tableName];
//    [sq setNumber:@(1) withId:@"number_key" intoTable:tableName];
//    [sq setString:@"string" withId:@"string_key" intoTable:tableName];
    
    NSLog(@"%@", [sq getAllItemsFromTable:tableName]);
    NSLog(@"%@", @([sq getCountFromTable:tableName]));
    NSLog(@"%@", [sq getNumberById:@"number_key" fromTable:tableName]);
    NSLog(@"%@", [sq getObjectById:@"object_key" fromTable:tableName]);
    NSLog(@"%@", [sq getStringById:@"string_key" fromTable:tableName]);
    
    NSData * data = [@"dasjkdjalskdjalsdjlajd" dataUsingEncoding:NSUTF8StringEncoding];
    NSData * enData = [data encryptedWithAES256UsingKey:@"12345"];
    NSLog(@"%@", enData);
    NSLog(@"%@", [[NSString alloc] initWithData:[enData decryptedWithAES256UsingKey:@"12345"] encoding:NSUTF8StringEncoding]);
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    NSLog(@"%@", @([view isVisable]));
    
    [[ZCPContext sharedInstance] loadConfig:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cfg" ofType:@"plist"]] bundle:nil];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
