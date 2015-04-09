//
//  LIBlogListViewModel.m
//  LoveiOS
//
//  Created by zhangruquan on 15/4/8.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LIBlogListViewModel.h"
#import "LIBlogModel.h"
@interface LIBlogListViewModel ()
@property (nonatomic) NSArray* blogs;
@property (nonatomic) LIAPIBlogType type;
@property (nonatomic) NSInteger pageIndex;
@end

@implementation LIBlogListViewModel

- (instancetype)initWithType:(LIAPIBlogType)type
{
    self = [super init];
    self.type = type;
    if (self) {
        self.blogs = [NSArray array];
    }
    return self;
}

-(RACSignal*)refreshBlogList
{
    self.pageIndex = 1;
    return [[[LIAPIManager sharedManager] fetchBlogsListWithType:self.type pageIndex:1] map:^id(NSArray *value) {
        self.blogs = value;
        return value;
    }];
    
}

-(RACSignal*)fetchMore
{
    
    return [[[LIAPIManager sharedManager] fetchBlogsListWithType:self.type pageIndex:++self.pageIndex] map:^id(NSArray *value) {
        
        NSMutableArray *mutablePins = [NSMutableArray arrayWithArray:self.blogs];
        [mutablePins addObjectsFromArray:value];
        self.blogs = [mutablePins copy];
        return value;
    }];
    
}

-(NSInteger)countRowOfBlogList
{
    return self.blogs.count;
}

- (NSString *)titleOfBlogListWithRow:(NSInteger)row
{
    return [self.blogs[row] blogTitle];
}

- (NSString *)desOfBlogListWithRow:(NSInteger)row
{
    return [self.blogs[row] blogDes];
}

- (NSString *)tagOfBlogListWithRow:(NSInteger)row
{
    return [self.blogs[row] blogTags];
}

- (NSString *)authorOfBlogListWithRow:(NSInteger)row
{
    return [self.blogs[row] blogWriter];
}

- (NSString *)blogUrlOfBlogListWithRow:(NSInteger)row
{
    return mEncodedUrlString([self.blogs[row] blogUrl]);
}

- (NSString *)pushDateOfBlogListWithRow:(NSInteger)row
{
    return [[NSDate dateFromString:[self.blogs[row] blogPushdate]] timestampForDate];
}


@end
