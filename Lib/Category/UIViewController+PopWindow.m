//
//  UIViewController+PopWindow.m
//  EducationVideo
//
//  Created by zhangruquan on 15/8/6.
//  Copyright (c) 2015年 net.csdn. All rights reserved.
//

#import "UIViewController+PopWindow.h"
static char popBoxViewTag;
static char presentingVCTag;
@implementation UIViewController (PopWindow)

- (void)setPopBoxView:(UIView *)popBoxView {
    objc_setAssociatedObject(self, &popBoxViewTag,
                             popBoxView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)popBoxView {
    return objc_getAssociatedObject(self, &popBoxViewTag);
}

- (void)setPresentingVC:(UIViewController *)presentingVC {
    objc_setAssociatedObject(self, &presentingVCTag,
                             presentingVC,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)presentingVC {
    return objc_getAssociatedObject(self, &presentingVCTag);
}

- (void)buildPopBoxView
{

    self.view.superview.frame=[[UIScreen mainScreen] bounds];
    self.view.superview.backgroundColor = kClearColor;
    
    UIControl * backgroundView=[[UIControl alloc] init];
    {
        [self.view addSubview:backgroundView];
        backgroundView.backgroundColor=kClearColor;
        [backgroundView addTarget:self action:@selector(onPopoverDismissAction:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    
    self.popBoxView = [[UIView alloc] init];
    {
        self.popBoxView.backgroundColor=kWhiteColor;
        self.popBoxView.layer.cornerRadius=5;
        [self.view addSubview:self.popBoxView];
        [self.popBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(mScreenWidth-2*170);
            make.height.mas_equalTo(mScreenHeight-140*2);
            make.center.equalTo(self.view);
            
        }];
       
        UIView *topBarView=[[UIView alloc] init];
        {
            topBarView.tag = 100;
            [self.popBoxView addSubview:topBarView];
           
            [topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(60);
            }];
            UILabel * titileLabel = [[UILabel alloc] init];
            {
                titileLabel.textAlignment = NSTextAlignmentCenter;
                titileLabel.font = [UIFont systemFontOfSize:22];
                [topBarView addSubview:titileLabel];
                titileLabel.tag = 1000;
                [titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(70);
                    make.right.mas_equalTo(-70);
                    make.top.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                }];
            }
            UIView * line = [[UIView alloc] init];
            {
                [topBarView addSubview:line];
                line.backgroundColor =kLineColor;
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                    make.bottom.mas_equalTo(0);
                }];
            }
            
        }
        
        
        
        
    }
    
}

-(void)dismissViewController:(BOOL)flag completion:(void (^)(void))completion{
    
    [self removeNotification];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.popBoxView.transform=CGAffineTransformMakeScale(0.001, 0.001);
        self.popBoxView.alpha=0.f;
    } completion:^(BOOL finish){
        [self dismissViewControllerAnimated:flag completion:completion];
    }];
}

-(void)onPopoverDismissAction:(UIControl *)controlView{
    
    [self dismissViewController:NO completion:nil];
}

-(void)addKeyboardNotificationObserver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notif {
    
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         self.popBoxView.transform=CGAffineTransformMakeTranslation(0, -100);
                     }
                     completion:NULL];
}

- (void)keyboardShow:(NSNotification *)notif {
    
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         self.popBoxView.transform=CGAffineTransformIdentity;
                         
                     }
                     completion:NULL];
}

- (void)keyboardHide:(NSNotification *)notif {
    
    
}


-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidHideNotification];
}

- (void)updateTitle:(NSString*)title
{
    if(self.popBoxView == nil)
        return;
    ((UILabel*)[[self.popBoxView viewWithTag:100] viewWithTag:1000]).text =  title;
    
}

- (void)addTopSubView:(UIView*)sub
{
    [[self.popBoxView viewWithTag:100] addSubview:sub];
    
}

- (void)presentedByPresentingVC:(UIViewController*)presentingVC
{
    
    self.preferredContentSize=CGSizeMake(mScreenWidth-170*2, mScreenHeight-140*2);
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    self.presentingVC = presentingVC;
    [presentingVC presentViewController:self animated:NO completion:NULL];
    
}

-(void)popupAnimationWithSpring{
    self.popBoxView.transform=CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.popBoxView.transform=CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finish){
    }];

}

- (void)viewWillLayout
{
    self.view.superview.frame=[[UIScreen mainScreen] bounds];
    self.view.superview.backgroundColor = kClearColor;
}
@end
