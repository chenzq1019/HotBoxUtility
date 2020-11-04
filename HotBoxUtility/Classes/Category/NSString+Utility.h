//
//  NSString+StringUtility.h
//  
//
//  Created by eachnet on 11/30/12.
//  Copyright (c) 2012 HotBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Utility)

+ (NSString *)isNullToString:(id)string;
/**
 字符串採用MD5加密
 @returns   返回使用MD5加密後的字符串
 */
- (NSString *) stringFromMD5;

/*
 加密函数
 param: key 密钥
 param: data 需要加密的字符串
 */
+ (NSString *)HMACMD5WithKey:(NSString *)key andData:(NSString *)data;


/**
 *url Encode编码
 */
- (NSString*) urlEncodedString;

/**
 *url Encode解码
 */
- (NSString*) urlDecodedString;

/**
 *去掉字符串中不显示的Unicode
 */
- (NSString *)removeUnicodeString;

/**
 判断字符串是否符合Email格式。
 @param input 字符串
 @returns 布尔值 YES: 符合 NO: 不符合
 */
+   (BOOL)isEmail:(NSString *)input;

/**
 判断字符串是否符合电话格式。
 @param input 字符串
 @returns 布尔值 YES: 符合 NO: 不符合
 */
+   (BOOL)isMobileNum:(NSString *)input;
/**
 判断字符串是否符合身份证号格式
 @param input 字符串
 @returns 布尔值 YES: 符合 NO: 不符合
 */
+ (BOOL)isIDNumber:(NSString *)input;
/**
 计算string的字节数
 @param str 字符串
 @returns 返回字符串的字节数量
 */
+ (int)calc_charsetNum:(NSString *)str;

/**
 获取中英文混合字符串长度 方法1
 @param str   字符串
 @returns   返回字符串的字节数量
 */
+ (int)convertToInt:(NSString *)str;

/**
 *判断是否符合正则表达式
 */
- (BOOL)isValidateByRegex:(NSString *)regex;

- (NSArray *)allURLs;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingArray:(NSDictionary *)params;
- (NSString *)urlByAppendingKeyValues:(NSDictionary *)first,...;

- (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
- (NSString *)queryStringFromArray:(NSArray *)array;
- (NSString *)queryStringFromKeyValues:(id)first, ...;

//手机马赛克
+(NSString*) mosaicMobilePhone:(NSString*) mobilePhone;
//字符串马赛克
+(NSString *) mosaicString:(NSString *) string;
//把一部分字符串替换成星号
+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght;

+ (UIImage *) tranforImageWithTargetText:(NSString *) targetText withColor:(UIColor *)color;
+ (UIImage *) tranforImageWithTargetText2:(NSString *) targetText withColor:(UIColor *)color;

/**
 *
 */
+ (NSMutableAttributedString *) transforAttributeWithString:(NSString *)targetStr Appends:(NSArray *) appends withPostion:(CGFloat)postion;

+ (CGSize) getSizeOfString:(NSString *)targetStr withFont:(UIFont*) font andMaxWidth:(CGFloat) maxWidth;
/**
 * 设置字符串部分字符的颜色
 */
- (NSMutableAttributedString *)setSubStrings:(NSArray *)subStrings showWithColor:(UIColor *)color;

/**
 * 是否包含字符串
 */
- (BOOL)stringRangeOfString:(NSString *)subString;

#pragma mark - NSDate
/**
 将NSString类型日期值转换为指定格式日期类型值
 @param input 字符串
 @param oldDate 原日期格式
 @param newDate 新日期格式
 @returns   返回新字符串
 */
+ (NSString *)stringToDate:(NSString *)input OldDateFormat:(NSString *)oldDate NewDateFormat:(NSString *)newDate;

/***    转化为时间格式         ***/
+(NSString*)dateToStringWithFormat:(NSDate*)date format:(NSString *) _format;
@end

@interface NSString (JsonString)

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
@end
