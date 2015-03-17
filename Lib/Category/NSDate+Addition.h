//
//  NSDate+HW.h
//  StringDemo
//
//  Created by 何 振东 on 12-10-11.
//  Copyright (c) 2012年 wsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

/**
 *  将日期转化为字符串。
 *  @param  format:转化格式，形如@"yyyy年MM月dd日hh时mm分ss秒"。
 *  return  返回转化后的字符串。
 */
- (NSString *)convertDateToStringWithFormat:(NSString *)format;

/**
 *  将字符串转化为日期。
 *  @param  string:给定的字符串日期。
 *  @param  format:转化格式，形如@"yyyy年MM月dd日hh时mm分ss秒"。日期格式要和string格式一致，否则会为空。
 *  return  返回转化后的日期。
 */
- (NSDate *)convertStringToDate:(NSString *)string format:(NSString *)format;

/**
 *  将字符串转化为日期。yyyy-MM-dd HH:mm:ss
 *  @param  string:给定的字符串日期。
 *  return  返回转化后的日期。
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

/**
 *  将日期转化为简短的日期格式字符串
 *
 *  return  日期的简短字符串。
 */
- (NSString *)timestampForDate;

@end
