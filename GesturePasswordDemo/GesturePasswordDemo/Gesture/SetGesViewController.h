//
//  SetGesViewController.h
//  KCBuinessKey
//
//  Created by kc-mac1 on 15/9/17.
//  Copyright (c) 2015年 luhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetGesViewController : UIViewController


@property BOOL isSet;
@property (nonatomic, assign) CGPoint lineStartPoint;
@property (nonatomic, assign) CGPoint lineEndPoint;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *selectedButtons;

@property (nonatomic, assign) BOOL drawFlag;

@property (nonatomic, strong) UIImage *pointImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property IBOutlet UILabel *notifyLabel;

@end
