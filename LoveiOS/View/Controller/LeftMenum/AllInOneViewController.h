//
//  AllInOneViewController.h
//  LoveiOS
//
//  Created by zhangruquan on 15/3/9.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllInOneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *m_pLeftMenumContainerView;
@property (weak, nonatomic) IBOutlet UIView *m_pContentView;
@property (weak, nonatomic) IBOutlet UIView *m_pGestureView;
@property (weak, nonatomic) IBOutlet UIView *m_pContentBoxView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *m_pBackToMainPanGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *m_pBackToMainTapGesture;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *m_pContentPanGesture;
@property (nonatomic, strong) UIViewController *m_pContentViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_pContentBoxLeft;


- (void)openSideBarView;
- (void)closeSideBarView;
@end
