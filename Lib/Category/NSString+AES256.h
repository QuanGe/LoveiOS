//
//  NSString+AES256.h
//  EducationVideo
//
//  Created by zhangruquan on 15/5/12.
//  Copyright (c) 2015年 net.csdn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NSString (AES256)
-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;
@end
