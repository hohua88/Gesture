//
//  MainViewController.m
//  GesturePasswordDemo
//
//  Created by eddy on 2016/11/24.
//  Copyright © 2016年 eddy. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "MeViewController.h"
#import "PasswordCheckView.h"

@interface MainViewController () <PasswordCheckViewDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTarBarChildController];
    // Do any additional setup after loading the view.
}

- (void)setUpTarBarChildController{
    NSArray *titleArray = @[@"首页", @"通讯录", @"发现", @"我"];
    for (int i = 0; i < 3; i++) {
        ViewController *vc = [ViewController new];
        
        vc.tabBarItem.image = [[UIImage imageNamed:@"TabBar_home_23x23_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"TabBar_home_selected_23x23_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.title = titleArray[i];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
    }
    MeViewController *controller = [MeViewController new];
    controller.tabBarItem.image = [[UIImage imageNamed:@"TabBar_home_23x23_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"TabBar_home_selected_23x23_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.title = titleArray[3];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([DBUtil boolForKey:kDB_GestureValid]) { //手势密码有效
        //[self.window.rootViewController presentViewController:[VertifyGesViewController new] animated:NO completion:nil];
        
        PasswordCheckView *password = [PasswordCheckView sharedInstance];
        password.delegate = self;
        [password show];
    }
}

#pragma mark - PasswordCheckViewDelegate

- (void)forgetGesturePassword {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"忘记手势密码" message:@"需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [DBUtil setObject:nil forKey:kDB_GesturePwd];
//        [DBUtil setBool:NO forKey:kDB_GestureValid];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    NSLog(@"forgetGesturePassword");
}

- (void)passwordCheck5Error {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你已连续输错5次" message:@"需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [DBUtil setObject:nil forKey:kDB_GesturePwd];
//        [DBUtil setBool:NO forKey:kDB_GestureValid];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//    }];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:NO completion:nil];
    NSLog(@"passwordCheck5Error");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
