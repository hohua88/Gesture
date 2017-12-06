//
//  AppDelegate.m
//  GesturePasswordDemo
//
//  Created by eddy on 2016/11/24.
//  Copyright © 2016年 eddy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "VertifyGesViewController.h"
#import "PasswordCheckView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    if ([DBUtil objectForKey:kDB_GestureValid]) {
//        VertifyGesViewController *controller = [VertifyGesViewController new];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//        self.window.rootViewController = nav;
//    }
//    else{
//        [self loginStateChange:nil];
//    }
    [self loginStateChange:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

//     UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
//    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
//        return;
//    }
    if ([DBUtil boolForKey:kDB_GestureValid]) { //手势密码有效
        //[self.window.rootViewController presentViewController:[VertifyGesViewController new] animated:NO completion:nil];
        [[PasswordCheckView sharedInstance] show];
    }
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

- (void)loginStateChange:(NSNotification *)notification{
    if (notification == nil) {
        [self userLogined];
    }
    else{
        BOOL loginSuccess = [notification.object boolValue];
        if (loginSuccess) {
            [self userLogined];
        }
        else{
            [self userLoginOut];
        }
    }
}
- (void)userLogined{
    
    self.window.rootViewController = [[MainViewController alloc] init];
    [self.window makeKeyAndVisible];
}
- (void)userLoginOut{
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    [self.window makeKeyAndVisible];
}

@end
