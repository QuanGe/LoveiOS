//
//  LIAPIManager.h
//  LoveiOS
//
//  Created by zhangruquan on 15/4/7.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef NS_ENUM(NSInteger, LIAPIReturnType)
{
    LIAPIManagerReturnTypeDic,
    LIAPIManagerReturnTypeArray,
    LIAPIManagerReturnTypeStr,
    LIAPIManagerReturnTypeValue,
    LIAPIManagerReturnTypePlain
    
};

typedef NS_ENUM(NSInteger, LIAPIBlogType)
{
    LIAPIManagerBlogTypeUI,
    LIAPIManagerBlogTypeFramework,
    LIAPIManagerBlogTypeExperience,
    LIAPIManagerBlogTypeInterview
    
};


@interface LIAPIManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

/**
 获取各种博客列表
 @param type 博客类型
 @param page 页数.
 */
- (RACSignal *)fetchBlogsListWithType:(LIAPIBlogType)type pageIndex:(NSInteger)page ;

/**
 获取博客详情
 @param urlString 博客地址
 */
- (RACSignal *)fetchBlogDetailWithURLString:(NSString*)urlString ;

@end
