//
//  UIViewController+LogDealloc.m
//  LoveiOS
//
//  Created by zhangruquan on 15/4/7.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "UIViewController+LogDealloc.h"
#import <objc/runtime.h>
@implementation UIViewController (LogDealloc)
+ (void)load {
    SEL deallocSelector = sel_registerName("dealloc");
    Method dea = class_getInstanceMethod(self, deallocSelector);
    Method logdealloc = class_getInstanceMethod(self, @selector(logDealloc));
    method_exchangeImplementations(dea, logdealloc);
    
    
}


-(void)logDealloc
{
    //
    UALog(@"%@ 类型的viewcontroller进行了释放",NSStringFromClass(self.class));
    
    [self logDealloc];
}
@end
