//
//  LIBlogListViewModel.h
//  LoveiOS
//
//  Created by zhangruquan on 15/4/8.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "RVMViewModel.h"
#import "LIAPIManager.h"
@interface LIBlogListViewModel : RVMViewModel

- (instancetype)initWithType:(LIAPIBlogType)type;

- (RACSignal *)refreshBlogList;
- (RACSignal *)fetchMore;

- (NSInteger)countRowOfBlogList;
- (NSString *)titleOfBlogListWithRow:(NSInteger)row;
- (NSString *)desOfBlogListWithRow:(NSInteger)row;
- (NSString *)tagOfBlogListWithRow:(NSInteger)row;
- (NSString *)authorOfBlogListWithRow:(NSInteger)row;
- (NSString *)blogUrlOfBlogListWithRow:(NSInteger)row;
- (NSString *)pushDateOfBlogListWithRow:(NSInteger)row;
@end
