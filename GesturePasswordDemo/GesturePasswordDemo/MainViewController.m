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

@interface MainViewController ()

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
