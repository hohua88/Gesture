//
//  SetGesViewController.m
//  KCBuinessKey
//
//  Created by kc-mac1 on 15/9/17.
//  Copyright (c) 2015年 luhua. All rights reserved.
//

#import "SetGesViewController.h"  

@interface SetGesViewController ()
{
    NSString *gesturePwd;
}

@property (weak, nonatomic) IBOutlet UIView *smallGestureView;

@end

@implementation SetGesViewController
#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title=@"设置手势密码";
    //布局大的解锁视图
    [self createLockPoints];
    //在小手势视图的布局
    [self addSmallGestureViewButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

#pragma mark - 添加UI
//在小手势视图的布局
-(void)addSmallGestureViewButton{
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnWH = 30;
    int cloumn = 3;
    CGFloat margin = (self.smallGestureView.bounds.size.width - (cloumn * btnWH)) / (cloumn + 1);
    int curCloumn = 0;
    int curRow = 0;
    
    for(int i = 0; i < 9; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.tag = i + 1;
        //正常状态图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        [self.smallGestureView addSubview:btn];
        curCloumn = i % cloumn;
        curRow =  i / cloumn;
        
        x = margin + (btnWH + margin) *curCloumn;
        y = (btnWH + margin) * curRow;
        
        //设置每一个按钮的尺寸
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
        
    }

}

//布局大的解锁视图
- (void)createLockPoints
{
    self.pointImage = [UIImage imageNamed:@"gesture_node_normal"];
    self.selectedImage = [UIImage imageNamed:@"gesture_node_highlighted"];
    
    float y;
    for (int i = 0; i < 3; ++i) {
        y = i * (kScreenWidth-60) * 1/3.0;
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
    [self smallGestureViewButtonHightLight];
    self.drawFlag = NO;
    self.imageView.image = nil;
    self.selectedButtons = nil;
}
//返回上一级控制器
-(void)backToPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自定义方法
//绘出手势路线
- (UIImage *)drawUnlockLine
{
    UIImage *image = nil;
    
    UIColor *color = [UIColor colorWithRed:67.0/255.0  green:255.0/255.0 blue:45.0/255.0 alpha:0.6];
    CGFloat width = 10.0f;
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
/**
 * 绘制完手势后的小视图高亮按钮
 */
-(void)smallGestureViewButtonHightLight{
    for (UIButton *smallGestureViewBtn in self.smallGestureView.subviews) {
        [smallGestureViewBtn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < self.selectedButtons.count; i++) {
        UIButton *selectBtn = self.selectedButtons[i];
        UIButton *smallGestureViewBtn = [self.smallGestureView viewWithTag:selectBtn.tag];
        //选中状态图片
        [smallGestureViewBtn setBackgroundImage:[UIImage imageNamed:@"gps_card"] forState:UIControlStateNormal];
    }

}

#pragma mark - 业务逻辑的处理
- (void)outputSelectedButtons
{
    NSMutableString *pwd = [NSMutableString string];
    for (UIButton *btn in self.selectedButtons) {
        [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
        [pwd appendFormat:@"%ld",(long)btn.tag];
    }
    if (pwd.length) {
        if (pwd.length<4) {
            if (!gesturePwd) {
                self.notifyLabel.text = @"至少连接4个点，请重新绘制";
                [self resetBtnImageWithError];
            }else{
                self.notifyLabel.text = @"与上次绘制不一致，请重新绘制";
                [self resetBtnImageWithError];
            }
        }else{
            if (!gesturePwd) {
                gesturePwd = pwd;
                self.notifyLabel.text = @"再次绘制解锁图案";
            }else{
                if (![pwd isEqualToString:gesturePwd]) {
                    self.notifyLabel.textColor = [UIColor redColor];
                    self.notifyLabel.text = @"与上次绘制不一致，请重新绘制";
                    [self resetBtnImageWithError];
                }else{
                    [DBUtil setObject:[gesturePwd md5] forKey:kDB_GesturePwd];
                     [self performSelector:@selector(popbackview) withObject:nil afterDelay:0.3];
                }
            }
        }
    }
}

//绘制错误时按钮的显示状态
- (void)resetBtnImageWithError{
    
    for (int i = 0; i < self.selectedButtons.count; i++) {
        UIButton *btn = self.selectedButtons[i];
        [btn setBackgroundImage:[UIImage imageNamed:@"ges_icon_red"] forState:UIControlStateNormal];
    }

    [self performSelector:@selector(afterShowError) withObject:self afterDelay:0.5];

}

- (void)afterShowError{
    for (UIButton *btn in self.buttonArray) {
        [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
    }
}

-(void)popbackview
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
