//
//  LIBlogListTableViewCell.h
//  LoveiOS
//
//  Created by zhangruquan on 15/4/8.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIBlogListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *blogTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogOrtherInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blogTitleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blogDesHeightConstraint;

- (void)textSetTitle:(NSString*)titile;
- (void)textSetDes:(NSString*)Des;
- (void)textSetAuthor:(NSString*)author pushDate:(NSString*)pushDate;
@end
