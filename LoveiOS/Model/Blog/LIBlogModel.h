//
//  LIBlogModel.h
//  LoveiOS
//
//  Created by zhangruquan on 15/4/7.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LIBaseModel.h"

@interface LIBlogModel : LIBaseModel
@property (nonatomic,copy) NSString * blogId;
@property (nonatomic,copy) NSString * blogTitle;
@property (nonatomic,copy) NSString * blogDes;
@property (nonatomic,copy) NSString * blogWriter;
@property (nonatomic,copy) NSString * blogTags;
@property (nonatomic,copy) NSString * blogPushdate;
@property (nonatomic,copy) NSString * blogUrl;
@end
