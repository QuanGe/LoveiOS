//
//  AllInOneViewController.m
//  LoveiOS
//
//  Created by zhangruquan on 15/3/9.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "AllInOneViewController.h"
#import "BlogHomeViewController.h"

#define LeftWidth 205
#define RightWidth (CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds) - LeftWidth)
@interface AllInOneViewController ()

@end

@implementation AllInOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    @weakify(self);
    [self.m_pContentPanGesture.rac_gestureSignal subscribeNext:^(UIPanGestureRecognizer * recognizer) {
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
    [self.m_pBackToMainPanGesture.rac_gestureSignal subscribeNext:^(UIPanGestureRecognizer * recognizer) {
        @strongify(self);
        CGPoint point = [recognizer translationInView:self.view];
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            // 当rootView的中心点和self.view的中心点x差值很大的时候应该打开sidebar，既判断向内拉动sidebar才会关闭sidebar
            float changeX = abs(self.m_pContentBoxView.center.x - self.view.center.x);
            
            if (changeX >= LeftWidth) {
                [self openSideBarView];
            } else {
                [self closeSideBarView];
            }
            return;
        }
        CGPoint offsetPoint = CGPointZero;
        offsetPoint.x = point.x+(self.view.frame.size.width-RightWidth);
        [self openWithPoint:offsetPoint];
    }];
    [self.m_pBackToMainTapGesture.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * recognizer) {
        @strongify(self);
        [self closeSideBarView];
    }];
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BlogHomeViewController *listController = (BlogHomeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"BlogHomeViewController"];
    _m_pContentViewController = listController;
    listController.view.frame = self.m_pContentView.frame;
    [self.m_pContentView addSubview:listController.view];
    [self addChildViewController:listController];
    
    
    [[self.m_pContentView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[self.m_pContentView layer] setShadowRadius:5];
    [[self.m_pContentView layer] setShadowOpacity:1];
    [[self.m_pContentView layer] setShadowColor:[UIColor blackColor].CGColor];
    
    self.m_pContentBoxView.frame = self.view.frame;
    self.m_pGestureView.hidden = YES;
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
    if (point.x < 0 || point.x>LeftWidth) {
        return;
    }
    self.m_pContentBoxLeft.constant= point.x;
    
}
- (void)closeSideBarView {
    [UIView animateWithDuration:0.25 animations:^{
        //self.m_pContentBoxView.transform = CGAffineTransformIdentity;
        self.m_pContentBoxLeft.constant= 0;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.m_pGestureView.hidden = YES;
    }];
}

- (void)openSideBarView {
    
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint openPoint = CGPointMake((self.view.frame.size.width-RightWidth), 0);
        [self openWithPoint:openPoint];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.m_pGestureView.hidden = NO;
    }];
}
#pragma mark - 切换vc
- (void)setM_pFristLevelViewController:(UIViewController *)flvc {
    if (_m_pContentViewController != flvc) {
        //flvc.view.autoresizingMask = _m_pFristLevelViewController.view.autoresizingMask;
        flvc.view.frame = self.m_pContentView.frame;
        [self.m_pContentViewController removeFromParentViewController];
        [self.m_pContentViewController.view removeFromSuperview];
        _m_pContentViewController = flvc;
        [self.m_pContentView addSubview:flvc.view];
        [self addChildViewController:flvc];
        
    }
}
@end
