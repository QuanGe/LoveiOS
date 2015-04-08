//
//  LIBlogModel.m
//  LoveiOS
//
//  Created by zhangruquan on 15/4/7.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LIBlogModel.h"

@implementation LIBlogModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"blogId":@"blogId",
             @"blogTitle":@"title",
             @"blogDes":@"des",
             @"blogWriter":@"writer",
             @"blogTags":@"tag",
             @"blogPushdate":@"pushdate",
             @"blogUrl":@"blogUrl"
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil)
        return nil;
    
    
    return self;
}
@end
