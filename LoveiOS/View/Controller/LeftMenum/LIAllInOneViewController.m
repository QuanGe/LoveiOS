//
//  AllInOneViewController.m
//  LoveiOS
//
//  Created by zhangruquan on 15/3/9.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LIAllInOneViewController.h"
#import "LIBlogHomeViewController.h"

#define kLeftWidth 205
#define kRightWidth ([UIScreen mainScreen].bounds.size.width - kLeftWidth)
@interface LIAllInOneViewController ()

@end

@implementation LIAllInOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    @weakify(self);
    [self.contentPanGesture.rac_gestureSignal subscribeNext:^(UIPanGestureRecognizer * recognizer) {
        @strongify(self);
        CGPoint point = [recognizer translationInView:self.view];
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            // 判断poinx.x落在的位置离边缘是否贴近，太近就关闭sidebar
            if (abs(point.x) < 50) {
                [self closeSideBarView];
            } else if (point.x > 50) {
                [self openSideBarView];
            } else {
                [self closeSideBarView];
            }
            return;
        }
        [self openWithPoint:point];
    }];
    [self.backToMainPanGesture.rac_gestureSignal subscribeNext:^(UIPanGestureRecognizer * recognizer) {
        @strongify(self);
        CGPoint point = [recognizer translationInView:self.view];
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            // 当rootView的中心点和self.view的中心点x差值很大的时候应该打开sidebar，既判断向内拉动sidebar才会关闭sidebar
            float changeX = abs(self.contentBoxView.center.x - self.view.center.x);
            
            if (changeX >= kLeftWidth) {
                [self openSideBarView];
            } else {
                [self closeSideBarView];
            }
            return;
        }
        CGPoint offsetPoint = CGPointZero;
        offsetPoint.x = point.x+(self.view.frame.size.width-kRightWidth);
        [self openWithPoint:offsetPoint];
    }];
    [self.backToMainTapGesture.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * recognizer) {
        @strongify(self);
        [self closeSideBarView];
    }];
    
//    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    LIBlogHomeViewController *listController = (LIBlogHomeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"LIBlogHomeViewController"];
//    _contentViewController = listController;
//    listController.view.frame = self.contentView.frame;
//    [self.contentView addSubview:listController.view];
//    [self addChildViewController:listController];
    
    
//    [[self.contentView layer] setShadowOffset:CGSizeMake(1, 1)];
//    [[self.contentView layer] setShadowRadius:5];
//    [[self.contentView layer] setShadowOpacity:1];
//    [[self.contentView layer] setShadowColor:[UIColor blackColor].CGColor];
    
    self.contentBoxView.frame = self.view.frame;
    self.gestureView.hidden = YES;
    NSString* fo =  [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstOpenLeft"];
    if(fo== nil)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.8 target:self
                                       selector:@selector(openSideBarView) userInfo:nil repeats:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"FirstOpenLeft"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)openWithPoint:(CGPoint)point
{
    if (point.x < 0 || point.x>kLeftWidth) {
        return;
    }
    self.contentBoxLeft.constant= point.x;
    self.contentBoxRight.constant = -point.x;
    
}
- (void)closeSideBarView {
    [UIView animateWithDuration:0.25 animations:^{
        //self.m_pContentBoxView.transform = CGAffineTransformIdentity;
        self.contentBoxLeft.constant= 0;
        self.contentBoxRight.constant = 0;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.gestureView.hidden = YES;
    }];
}

- (void)openSideBarView {
    
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint openPoint = CGPointMake((self.view.frame.size.width-kRightWidth), 0);
        [self openWithPoint:openPoint];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.gestureView.hidden = NO;
    }];
}
#pragma mark - 切换vc
- (void)setContentViewController:(UIViewController *)flvc {
    if (_contentViewController != flvc) {
        //flvc.view.autoresizingMask = _m_pFristLevelViewController.view.autoresizingMask;
        flvc.view.frame = self.contentView.frame;
        [self.contentViewController removeFromParentViewController];
        [self.contentViewController.view removeFromSuperview];
        _contentViewController = flvc;
        [self.contentView addSubview:flvc.view];
        [self addChildViewController:flvc];
        
    }
}
@end
