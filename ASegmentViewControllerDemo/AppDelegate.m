//
//  AppDelegate.m
//  ASegmentViewControllerDemo
//
//  Created by anders on 16/03/2014.
//  Copyright (c) 2014 anders. All rights reserved.
//

#import "AppDelegate.h"
#import "ASegmentViewController.h"
#import "DemoViewController.h"
#import "TestTableViewController.h"
#import "ANavViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController *randomViewController1 = [[UIViewController alloc] init];
    [randomViewController1.view setBackgroundColor:[UIColor greenColor]];
    
    UIViewController *randomViewController2 = [[DemoViewController alloc] init];
    [randomViewController2.view setBackgroundColor:[UIColor blueColor]];
    
    UITableViewController *randomViewController3 = [[UITableViewController alloc] init];
    [randomViewController3.view setBackgroundColor:[UIColor whiteColor]];
    randomViewController3.automaticallyAdjustsScrollViewInsets = NO;
    ((UIScrollView *)randomViewController3.view).contentOffset = CGPointZero;
    
//    TestTableViewController
    TestTableViewController *randomViewController4 = [[TestTableViewController alloc] init];
    [randomViewController4.view setBackgroundColor:[UIColor whiteColor]];
    randomViewController4.automaticallyAdjustsScrollViewInsets = NO;
    ((UIScrollView *)randomViewController4.view).contentOffset = CGPointZero;
    
    NSArray *randomViewControllers = [[NSArray alloc] initWithObjects:randomViewController1,randomViewController2, randomViewController3, randomViewController4, nil];
    NSArray *randomItems = [[NSArray alloc] initWithObjects:@"FirstViewC", @"secondVC", @"thirdViewC", @"fourth", nil];
    ASegmentViewController *aSegmentViewController = [[ASegmentViewController alloc] initWithItems:randomItems forControllers:randomViewControllers];
    
    UINavigationController *navC = [[ANavViewController alloc] initWithRootViewController:aSegmentViewController];
    
	self.window.rootViewController = navC;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
