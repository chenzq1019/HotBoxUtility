//
//  HTDateFormatter.m
//
//
//  Created by shengyang_yu on 2016/10/26.
//  Copyright © 2016年 HotBox. All rights reserved.
//
//  转换NSDate NSSTring格式
//

#import "HTDateFormatter.h"

@implementation HTDateFormatter

//字符串转日期
+ (NSDate *)stringDateToNSDate:(NSString *)dateString {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyyMMdd HH:mm"];
    NSDate *dt = [formatter dateFromString:dateString];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dt];
    NSDate *localeDate = [dt  dateByAddingTimeInterval:interval];
    return localeDate;
}

//日期转字符串格式1
+ (NSString *)dateToNSString:(NSDate *)date {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy年MM月dd日HH时mm分"];
    NSString *dateString = [formatter stringFromDate:date ];
    return dateString;
}

//日期转字符串格式2
+ (NSString *)getCurrentDate:(NSDate *)date {
    //得到毫秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *currentdt = [dateFormatter stringFromDate:date];
    return currentdt;
}

//日期转字符串格式3
+ (NSString *)GetCurrentDate2:(NSDate *)date {
    //得到毫秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentdt = [dateFormatter stringFromDate:date];
    return currentdt;
}

//日期转字符串格式4
+ (NSString *)GetCurrentDate3:(NSDate *)date {
    //得到毫秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *currentdt = [dateFormatter stringFromDate:date];
    return currentdt;
}

//日期转字符串格式5
+ (NSString *)GetCurrentDate4:(NSDate *)date {
    //得到毫秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentdt = [dateFormatter stringFromDate:date];
    return currentdt;
}

+ (NSString*)GetCurrentDate5:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:-interval];
    [dateFormatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
    NSString *currentdt = [dateFormatter stringFromDate:localeDate];
    return currentdt;
}

// 转换成制定格式
+ (NSString *)GetCustomDate:(NSDate *)date dataFormat:(NSString *)dataFormat {
    //得到毫秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:dataFormat];
    NSString *currentdt = [dateFormatter stringFromDate:date];
    return currentdt;
}

@end
