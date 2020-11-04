//
//  NSDate+USAddtion.m
//  
//
//  Created by chenzhuqing on 2018/12/24.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "NSDate+USAddtion.h"

@implementation NSDate (USAddtion)

+ (void)saveDate:(NSDate *)date Forkey:(NSString*) key{
    [[NSUserDefaults standardUserDefaults]setObject:date forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate *)getDateForkey:(NSString *)key{
    NSDate *date = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return date;
}

+ (BOOL)todayHadRequestForKey:(NSString *)key{
    BOOL hasReuest=NO;
    NSDate *latestDate = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    hasReuest=[NSDate isSameDay:latestDate date2:[NSDate date]];
    return hasReuest;
}

+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2{
    if (!date1||!date2) {
        return NO;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

+ (NSDate *)getCustomDateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitMinute;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    [resultComps setSecond:second];
    
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return [resultCalendar dateFromComponents:resultComps];
    
}


+ (BOOL)isBetweenFromHour:(NSInteger)fromHour fromMinute:(NSInteger)fromMinute fromSecond:(NSInteger)fromSecond toHour:(NSInteger)toHour toMinute:(NSInteger)toMinute toSecond:(NSInteger)toSecond{
    NSDate *dateFrom = [NSDate getCustomDateWithHour:fromHour minute:fromMinute second:fromSecond];
    
    NSDate *dateTo = [NSDate getCustomDateWithHour:toHour minute:toMinute second:toSecond];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:dateFrom]==NSOrderedDescending && [currentDate compare:dateTo]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:%ld:%ld-%ld:%ld:%ld 之间！", (long)fromHour, (long)fromMinute, (long)fromSecond, (long)toHour, (long)toMinute, (long)toSecond);
        return YES;
    }
    return NO;
}

+ (NSString *)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

//日期转字符串(按天)
+(NSString*)GetCurrentDateByDay:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentDay = [dateFormatter stringFromDate:date];
    return currentDay;
}

// 时间戳—>字符串时间
+ (NSString *)DateStringFromTimestamp:(NSTimeInterval )timestamp DateFormat:(NSString *)dateFormat{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

//获取日期前后几个月的日期
+ (NSDate *)getEarlierOrLaterDateFromDate:(NSDate *)date withMonth:(int)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}
@end
