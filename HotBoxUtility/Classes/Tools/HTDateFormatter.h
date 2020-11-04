//
//  HTDateFormatter.h
//
//
//  Created by shengyang_yu on 2016/10/26.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDateFormatter : NSObject

//字符串转日期
+ (NSDate *)stringDateToNSDate:(NSString *)dateString;

//日期转字符串格式1
+ (NSString *)dateToNSString:(NSDate *)date;

//日期转字符串格式2
+ (NSString *)getCurrentDate:(NSDate *)date;

//日期转字符串格式3
+ (NSString *)GetCurrentDate2:(NSDate *)date;

//日期转字符串格式4
+ (NSString *)GetCurrentDate3:(NSDate *)date;

//日期转字符串格式5
+ (NSString *)GetCurrentDate4:(NSDate *)date;

+ (NSString *)GetCurrentDate5:(NSDate *)date;

// 转换成制定格式
+ (NSString *)GetCustomDate:(NSDate *)date dataFormat:(NSString *)dataFormat;

@end
