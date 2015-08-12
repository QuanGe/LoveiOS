//
//  UITabBarController+HideTabBar.h
//  EducationVideo
//
//  Created by zhangruquan on 15/5/6.
//  Copyright (c) 2015年 net.csdn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (HideTabBar)

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
