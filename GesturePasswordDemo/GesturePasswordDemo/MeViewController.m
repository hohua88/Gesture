//
//  MeViewController.m
//  GesturePasswordDemo
//
//  Created by eddy on 2016/11/24.
//  Copyright © 2016年 eddy. All rights reserved.
//

#import "MeViewController.h"
#import "SetGesViewController.h"

static NSString *const cellID = @"cell";

@interface MeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0x39353F)];
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    // Do any additional setup after loading the view.
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"手势密码";
        
        UISwitch *onSwitch = [[UISwitch alloc] init];
        onSwitch.on = [DBUtil boolForKey:kDB_GestureValid];
        [onSwitch addTarget:self action:@selector(valueChanded:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = onSwitch;
    }
    else{
        cell.textLabel.text = @"退出";
    }
    return cell;
}

#pragma  mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [DBUtil setBool:NO forKey:kDB_GestureValid];
        [DBUtil setObject:nil forKey:kDB_GesturePwd];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}
#pragma mark - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - private

- (void)valueChanded:(UISwitch *)sw{
    
    if (sw.on) {
        if (![DBUtil objectForKey:kDB_GesturePwd]) {
            SetGesViewController *setGes = [[SetGesViewController alloc] init];
            [setGes setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:setGes animated:YES];
        }
    }
    [DBUtil setBool:sw.on forKey:kDB_GestureValid];
}
@end
