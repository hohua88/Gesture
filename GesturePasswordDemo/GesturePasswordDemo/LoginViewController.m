//
//  LoginViewController.m
//  GesturePasswordDemo
//
//  Created by eddy on 2016/11/24.
//  Copyright © 2016年 eddy. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UIButton *loginButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0x39353F)];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    [self.view setNeedsUpdateConstraints];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - updateViewConstraints(更新约束)
- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    //用户名输入框布局
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(30);
        make.top.equalTo(self.view).with.offset(100);
        make.height.mas_equalTo(40 *kScreenHeight/480);
        make.right.mas_equalTo(self.view).with.offset(-30);
    }];
    
    //密码输入框布局
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(30);
        make.top.equalTo(self.nameTextField).with.offset(100);
        make.height.mas_equalTo(40 *kScreenHeight/480);
        make.right.mas_equalTo(self.view).with.offset(-30);
    }];
    //登录按钮布局
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(30);
        make.top.equalTo(self.passwordTextField).with.offset(100);
        make.height.mas_equalTo(40 *kScreenHeight/480);
        make.right.mas_equalTo(self.view).with.offset(-30);
    }];

}
#pragma mark - lazy load

- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.borderStyle = UITextBorderStyleLine;
        _nameTextField.font = [UIFont systemFontOfSize:16*0.9*kScreenWidth/320];
        _nameTextField.textColor = [UIColor whiteColor];
        _nameTextField.placeholder = @"请输入密码";
        
        [_nameTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTextField;
}
- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [UITextField new];
        _passwordTextField.borderStyle = UITextBorderStyleLine;
        _passwordTextField.font = [UIFont systemFontOfSize:16*0.9*kScreenWidth/320];
        _passwordTextField.textColor = [UIColor whiteColor];
        _passwordTextField.placeholder = @"请输入用户名";
        [_passwordTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}
- (UIButton *)loginButton{
    
    if (!_loginButton) {
        _loginButton = [UIButton new];
        [_loginButton setBackgroundColor:[UIColor lightGrayColor]];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18*0.9*kScreenWidth/320];
        [_loginButton setTitle:@"Log in" forState:0];
        _loginButton.enabled = NO;
        
        [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

#pragma mark private

- (void)textChanged:(UITextField *)textField{
    if (self.nameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.loginButton.enabled = YES;
    }
}

- (void)loginButtonClicked:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
}
@end
