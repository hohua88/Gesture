//
//  VertifyGesViewController.m
//  KCBuinessKey
//
//  Created by kc-mac1 on 15/9/17.
//  Copyright (c) 2015年 luhua. All rights reserved.
//

#import "VertifyGesViewController.h"

NSInteger maxCount = 5;

@interface VertifyGesViewController ()

@end

@implementation VertifyGesViewController
#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置头像位圆形
    self.iconImageV.layer.cornerRadius=self.iconImageV.bounds.size.height/2;
    self.iconImageV.layer.borderColor=[UIColor whiteColor].CGColor;
    self.iconImageV.layer.borderWidth=1;
    self.iconImageV.layer.masksToBounds=YES;
    
    [self createLockPoints];
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:frame];
    [bgIV setImage:[UIImage imageNamed:@"bg_dark"]];
    [self.view insertSubview:bgIV atIndex:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}


#pragma mark - 点击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        for (UIButton *btn in self.buttonArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            if ([btn pointInside:touchPoint withEvent:nil]) {
                self.lineStartPoint = btn.center;
                self.drawFlag = YES;
                
                if (!self.selectedButtons) {
                    self.selectedButtons = [NSMutableArray arrayWithCapacity:9];
                }
                [self.selectedButtons addObject:btn];
                [btn setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch && self.drawFlag) {
        self.lineEndPoint = [touch locationInView:self.imageView];
        
        for (UIButton *btn in self.buttonArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            
            if ([btn pointInside:touchPoint withEvent:nil]) {
                BOOL btnContained = NO;
                
                for (UIButton *selectedBtn in self.selectedButtons) {
                    if (btn == selectedBtn) {
                        btnContained = YES;
                        break;
                    }
                }
                
                if (!btnContained) {
                    [self.selectedButtons addObject:btn];
                    [btn setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
                }
            }
        }
        
        self.imageView.image = [self drawUnlockLine];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self outputSelectedButtons];
    
    self.drawFlag = NO;
    self.imageView.image = nil;
    self.selectedButtons = nil;
}


#pragma mark - 添加UI
- (void)createLockPoints
{
    self.pointImage = [UIImage imageNamed:@"gesture_node_normal"];
    self.selectedImage = [UIImage imageNamed:@"gesture_node_highlighted"];

    
    float y;
    for (int i = 0; i < 3; ++i) {
       y = i * (kScreenWidth-60) * 1/3.0 + 30;
        float x;
        for (int j = 0; j < 3; ++j) {
            x = 30 +j * (kScreenWidth-120)* 1/2.0 ;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
            [btn setBackgroundImage:self.selectedImage forState:UIControlStateHighlighted];
            [btn setFrame:CGRectMake(x, y, 60, 60)];
            [self.imageView addSubview:btn];
            
            btn.userInteractionEnabled = NO;
            btn.tag = 1 + i * 3 + j;
            
            if (!self.buttonArray) {
                self.buttonArray = [NSMutableArray arrayWithCapacity:9];
            }
            [self.buttonArray addObject:btn];
        }
    }
}

#pragma mark - 业务逻辑

- (UIImage *)drawUnlockLine
{
    UIImage *image = nil;
    
    UIColor *color = [UIColor colorWithRed:67.0/255.0  green:255.0/255.0 blue:45.0/255.0 alpha:0.6];
    CGFloat width = 8.0f;
    CGSize imageContextSize = self.imageView.frame.size;
    
    UIGraphicsBeginImageContext(imageContextSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextMoveToPoint(context, self.lineStartPoint.x, self.lineStartPoint.y);
    for (UIButton *selectedBtn in self.selectedButtons) {
        CGPoint btnCenter = selectedBtn.center;
        CGContextAddLineToPoint(context, btnCenter.x, btnCenter.y);
        CGContextMoveToPoint(context, btnCenter.x, btnCenter.y);
    }
    CGContextAddLineToPoint(context, self.lineEndPoint.x, self.lineEndPoint.y);
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -

- (void)outputSelectedButtons
{
    NSMutableString *pwd = [NSMutableString string];
    for (UIButton *btn in self.selectedButtons) {
        [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
        [pwd appendFormat:@"%ld",(long)btn.tag];
    }
    
    if (pwd.length) {
        NSString *savedPwd = [DBUtil objectForKey:kDB_GesturePwd];
        if ([[pwd md5] isEqualToString:savedPwd]) {
            if (self.navigationController) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            }
            else{
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }
        }else{
            maxCount--;
            if (maxCount) {
                self.showlbl.text = [NSString stringWithFormat:@"密码错误，还可以输入%ld次",(long)maxCount];
                self.showlbl.textColor = [UIColor redColor];
                [self resetBtnImageWithError];
                
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你已连续输错5次" message:@"需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [DBUtil setObject:nil forKey:kDB_GesturePwd];
                    [DBUtil setBool:NO forKey:kDB_GestureValid];
                    [self poptoRootVC];
                }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}
- (IBAction)forgetGesAction:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"忘记手势密码" message:@"需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [DBUtil setObject:nil forKey:kDB_GesturePwd];
        [DBUtil setBool:NO forKey:kDB_GestureValid];
        [self poptoRootVC];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resetBtnImageWithError{
    for (int i = 0; i < self.selectedButtons.count; i++) {
        UIButton *btn = self.selectedButtons[i];
        [btn setBackgroundImage:[UIImage imageNamed:@"ges_icon_red"] forState:UIControlStateNormal];
    }
    
    [self performSelector:@selector(afterShowError) withObject:self afterDelay:0.5];
}


- (void)afterShowError{
    for (UIButton *btn in self.buttonArray) {
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:0];
    }
}
-(void)poptoRootVC
{
     [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

@end
