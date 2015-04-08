//
//  AllInOneViewController.h
//  LoveiOS
//
//  Created by zhangruquan on 15/3/9.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIAllInOneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *leftMenumContainerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *gestureView;
@property (weak, nonatomic) IBOutlet UIView *contentBoxView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *backToMainPanGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *backToMainTapGesture;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *contentPanGesture;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBoxLeft;


- (void)openSideBarView;
- (void)closeSideBarView;
@end
