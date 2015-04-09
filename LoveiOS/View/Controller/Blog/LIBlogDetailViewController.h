//
//  BlogDetailViewController.h
//  LoveiOS
//
//  Created by zhangruquan on 15/3/9.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCoreText.h"
@interface LIBlogDetailViewController : UIViewController<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet DTAttributedTextView *dtAttributeText;
@property (nonatomic) NSString* blogURLString;

- (IBAction)back:(UIButton *)sender;

@end
