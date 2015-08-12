//
//  UIViewController+backBtn.m
//  EducationVideo
//
//  Created by zhangruquan on 15/6/1.
//  Copyright (c) 2015年 net.csdn. All rights reserved.
//

#import "UIViewController+BackBtn.h"

@implementation UIViewController (BackBtn)

- (void)buildBackBtn
{
    //返回按钮
    {
        UIView * customBarButtonBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        //customBarButtonBox.backgroundColor = [UIColor blackColor];
        {
            UIButton * backBtn = [[UIButton alloc] init];
            backBtn.tag = 2222;
            [backBtn setImage:[[UIImage imageNamed:@"nav_return"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [customBarButtonBox addSubview:backBtn];
            [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo( 24);
                make.width.mas_equalTo(24);
                make.top.mas_equalTo(0);
                make.left.mas_equalTo((kLeftOrRightEdgeInset-kNavIconSpace));
            }];
            @weakify(self)
            backBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
                return [RACSignal empty];
            }];
            UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonBox];
            [self.navigationItem setLeftBarButtonItem:rightBtn];
            
            
        }
        
    }
    
}
@end
