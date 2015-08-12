//
//  UIViewController+PopWindow.h
//  EducationVideo
//
//  Created by zhangruquan on 15/8/6.
//  Copyright (c) 2015年 net.csdn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PopWindow)

@property (nonatomic) UIView *popBoxView;
@property (nonatomic) UIViewController*presentingVC;
//创建显示层
- (void)buildPopBoxView;
//更新title的内容
- (void)updateTitle:(NSString*)title;
//在上面的view添加子控件
- (void)addTopSubView:(UIView*)sub;
//添加键盘监控
- (void)addKeyboardNotificationObserver;
//模态框的形式弹出
- (void)presentedByPresentingVC:(UIViewController*)presentingVC;
//显示的时候有个动画
- (void)popupAnimationWithSpring;
//必须调用 更新背景层大小
- (void)viewWillLayout;
//返回
-(void)dismissViewController:(BOOL)flag completion:(void (^)(void))completion;
@end
