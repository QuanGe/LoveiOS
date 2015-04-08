//
//  LIAPIManager.m
//  LoveiOS
//
//  Created by zhangruquan on 15/4/7.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "LIAPIManager.h"
#import <objc/runtime.h>

@implementation LIAPIManager

+ (instancetype)sharedManager
{
    static LIAPIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return instance;
}



- (RACSignal *)fetchDataWithURLString:(NSString *)urlString params:(NSDictionary *)parameters headers:(NSDictionary*)headers returnType:(LIAPIReturnType)type httpMethod:(NSString *)method{
    
    
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                   URLString:urlString
                                                                  parameters:parameters error:nil];
    if(headers)
    {
        for (NSString * key in headers) {
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
        AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (type == LIAPIManagerReturnTypePlain) {
                [subscriber sendNext:operation.responseString];
                [subscriber sendCompleted];
            }
            else
            {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                id dict= nil;//[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                
                if (data) {
                    if ([data length] > 0) {
                        dict = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                    } else {
                        [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                    }
                }
                if(![dict isKindOfClass:[NSDictionary class]] &&type == LIAPIManagerReturnTypeDic)
                    [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                else if(![dict isKindOfClass:[NSArray class]] &&type == LIAPIManagerReturnTypeArray)
                    [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                else if(![dict isKindOfClass:[NSString class]] &&type == LIAPIManagerReturnTypeStr)
                    [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                else if(![dict isKindOfClass:[NSValue class]] &&type == LIAPIManagerReturnTypeValue)
                    [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                else
                {
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];
                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [subscriber sendError:error];
            
        }];
        
        [self.operationQueue addOperation:operation];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }]  doError:^(NSError *error) {
        
    }];
    
}

/**
 获取各种博客列表
 @param type 博客类型
 @param page 页数.
 */
- (RACSignal *)fetchBlogsListWithType:(LIAPIBlogType)type pageIndex:(NSInteger)page
{
    return [[self fetchDataWithURLString:mUrlString(@"appWebservice.php")
                                  params:@{@"type":@(type).stringValue,@"page":@(page).stringValue,@"pageSize":@"10"}
                                 headers:@{@"METHOD":@"getBlogs"}
                              returnType:LIAPIManagerReturnTypeArray httpMethod:@"get"]
            map:^id(NSArray *jsonArray) {
            
        return [MTLJSONAdapter modelsOfClass:objc_getClass("LIBlogModel") fromJSONArray:jsonArray error:nil];
    }];

    
    
}

/**
 获取博客详情
 @param urlString 博客地址
 */
- (RACSignal *)fetchBlogDetailWithURLString:(NSString*)urlString
{
    return [self fetchDataWithURLString:urlString params:nil headers:nil returnType:LIAPIManagerReturnTypePlain httpMethod:@"get"];
}
@end
