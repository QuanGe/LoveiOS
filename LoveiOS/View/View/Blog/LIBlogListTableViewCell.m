//
//  LIBlogListTableViewCell.m
//  LoveiOS
//
//  Created by zhangruquan on 15/4/8.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LIBlogListTableViewCell.h"

@implementation LIBlogListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.width = mScreenWidth;
    self.blogTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.blogTitleLabel.textColor = mRGBToColor(0x222222);
    self.blogTitleLabel.numberOfLines = 0;
    self.blogOrtherInfoLabel.textColor = mRGBToColor(0xcecece);
    
    self.blogDesLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.blogDesLabel.textColor = mRGBToColor(0x6d6d72);
    self.blogDesLabel.numberOfLines = 0;
    self.backgroundColor = mRGBToColor(0xeeeeee);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textSetTitle:(NSString*)titile
{
    self.blogTitleLabel.text = titile;
    CGRect rect = [titile boundingRectWithSize:CGSizeMake(self.width-30, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                    attributes:@{ NSFontAttributeName : self.blogTitleLabel.font }
                                       context:nil];
    self.blogTitleHeightConstraint.constant = rect.size.height+5;
    
}

- (void)textSetDes:(NSString*)Des
{
    self.blogDesLabel.text = Des;
    CGRect rect = [Des boundingRectWithSize:CGSizeMake(self.width-30, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                    attributes:@{ NSFontAttributeName : self.blogDesLabel.font }
                                       context:nil];
    self.blogDesHeightConstraint.constant = rect.size.height+5;
}

- (void)textSetAuthor:(NSString*)author pushDate:(NSString*)pushDate
{
    self.blogOrtherInfoLabel.text = [[pushDate stringByAppendingString:@" ∙ "] stringByAppendingString:author];
}
@end
