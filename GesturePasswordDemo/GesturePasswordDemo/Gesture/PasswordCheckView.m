//
//  PasswordCheckView.m
//  GesturePasswordDemo
//
//  Created by eddy on 2017/12/5.
//  Copyright © 2017年 eddy. All rights reserved.
//

#import "PasswordCheckView.h"

@interface PasswordCheckView ()

@property (nonatomic, assign) CGPoint lineStartPoint;
@property (nonatomic, assign) CGPoint lineEndPoint;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *selectedButtons;

@property (nonatomic, assign) BOOL drawFlag;
@property (nonatomic, strong) UIImage *pointImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong)  UIImageView *bgView;

@property (strong, nonatomic)  UILabel *showlbl;

@property (strong, nonatomic)  UIImageView *imageView;

@property (strong, nonatomic)  UIImageView *iconImageV;

@property (strong, nonatomic)  UILabel *nameLabel;

@property (strong, nonatomic)  UIButton *forgetBtn;

@end

NSInteger maxCount1 = 5;

@implementation PasswordCheckView

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.showlbl];
        [self addSubview:self.imageView];
        [self addSubview:self.iconImageV];
        [self addSubview:self.forgetBtn];
        
        [self setNeedsUpdateConstraints];
        
        [self createLockPoints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(70);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@70);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageV.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.height.equalTo(@21);
    }];
    
    [_showlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.height.equalTo(@21);
    }];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.centerX.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showlbl.mas_bottom).offset(10);
        make.bottom.equalTo(_forgetBtn.mas_top).offset(-10);
        make.width.equalTo(self.mas_width);
        make.centerX.equalTo(self);
    }];
    
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
            [self resignKeyWindow];
            self.hidden = YES;
        }else{
            maxCount1--;
            if (maxCount1>0) {
                _showlbl.text = [NSString stringWithFormat:@"密码错误，还可以输入%ld次",(long)maxCount1];
                _showlbl.textColor = [UIColor redColor];
                [self resetBtnImageWithError];
                
            }else if(maxCount1 == -1){
                
                if ([self.delegate respondsToSelector:@selector(passwordCheck5Error)]) {
                    [self.delegate passwordCheck5Error];
                }
            }
            else {
                return;
            }
        }
    }
}
- (void)forgetGesAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(forgetGesturePassword)]) {
        [self.delegate forgetGesturePassword];
    }
}

- (void)resetBtnImageWithError{
    for (int i = 0; i < self.selectedButtons.count; i++) {
        UIButton *btn = self.selectedButtons[i];
        [btn setBackgroundImage:[UIImage imageNamed:@"ges_icon_red"] forState:UIControlStateNormal];
    }
    
    [self performSelector:@selector(afterShowError) withObject:self afterDelay:0.1];
}


- (void)afterShowError{
    for (UIButton *btn in self.buttonArray) {
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:0];
    }
}

- (void)show {
    self.windowLevel = UIWindowLevelAlert;
    [self makeKeyWindow];
    self.hidden = NO;
}

#pragma mark - getter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgView.image = [UIImage imageNamed:@"Home_refresh_bg"];
    }
    return _bgView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImageView *)iconImageV {
    if (!_iconImageV) {
        _iconImageV = [[UIImageView alloc] init];
        _iconImageV.image = [UIImage imageNamed:@"default_avatar"];
    }
    return _iconImageV;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"测试";
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)showlbl {
    if (!_showlbl) {
        _showlbl = [UILabel new];
        _showlbl.text = @"绘制解锁图案";
        _showlbl.font = [UIFont systemFontOfSize:15];
        _showlbl.textColor = [UIColor whiteColor];
    }
    return _showlbl;
}

- (UIButton *)forgetBtn {
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_forgetBtn setTitle:@"忘记手势密码？" forState:0];
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_forgetBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_forgetBtn addTarget:self action:@selector(forgetGesAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}
@end
