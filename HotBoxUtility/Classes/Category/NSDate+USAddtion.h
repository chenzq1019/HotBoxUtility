//
//  NSDate+USAddtion.h
//  
//
//  Created by chenzhuqing on 2018/12/24.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (USAddtion)

+ (void)saveDate:(NSDate *)date Forkey:(NSString *)key;

+ (NSDate *)getDateForkey:(NSString *)key;

+ (BOOL)todayHadRequestForKey:(NSString *)key;

+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2;

+ (NSDate *)getCustomDateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

+ (BOOL)isBetweenFromHour:(NSInteger)fromHour fromMinute:(NSInteger)fromMinute fromSecond:(NSInteger)fromSecond toHour:(NSInteger)toHour toMinute:(NSInteger)toMinute toSecond:(NSInteger)toSecond;

+ (NSString *)getCurrentTimes;

+ (NSString*)GetCurrentDateByDay:(NSDate*)date;

+ (NSString *)DateStringFromTimestamp:(NSTimeInterval )timestamp DateFormat:(NSString *)dateFormat;

+ (NSDate *)getEarlierOrLaterDateFromDate:(NSDate *)date withMonth:(int)month;

@end

NS_ASSUME_NONNULL_END
