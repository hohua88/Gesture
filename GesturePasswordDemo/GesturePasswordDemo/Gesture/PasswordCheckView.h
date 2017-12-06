//
//  PasswordCheckView.h
//  GesturePasswordDemo
//
//  Created by eddy on 2017/12/5.
//  Copyright © 2017年 eddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasswordCheckViewDelegate <NSObject>

- (void)passwordCheck5Error;

- (void)forgetGesturePassword;

@end

@interface PasswordCheckView : UIWindow

@property (nonatomic, weak) id <PasswordCheckViewDelegate> delegate;
+ (instancetype)sharedInstance;

- (void)show;

@end
