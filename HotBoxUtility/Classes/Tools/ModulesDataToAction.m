//
//  ModulesDataToAction.m
//
//
//  Created by shengyang_yu on 16/8/23.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import "ModulesDataToAction.h"
#import "NSArray+ReplaceObjectAtIndex.h"
#import "NSString+Utility.h"

@implementation UCiOSAction

@end

@implementation ModulesDataToAction

#pragma mark - <公共方法>
/** 过滤banner等数据 */
+ (BOOL)canInputDataMin:(NSString *)minString withMax:(NSString *)maxString withDevice:(NSString *)devicetype withAppVersion:(NSInteger)appVersion  {
    
    BOOL isCan = NO;
    // 最小 minString
    // 最大 maxString
    // 设备类型 0为通用，1为android 2为ios devicetype
    BOOL isDevice = ([devicetype integerValue]==0 || [devicetype integerValue]== 2);
    minString=[NSString isNullToString:minString];
    maxString=[NSString isNullToString:maxString];
    // 有版本限制
    minString = [NSString isNullToString:minString];
    maxString = [NSString isNullToString:maxString];
    if (minString.length > 0 && maxString.length > 0) {
        
        NSArray *array1 = [minString componentsSeparatedByString:@"&"];
        NSArray *array2 = [maxString componentsSeparatedByString:@"&"];
        if (array1.count > 1 && array2.count > 1) {
            
            NSInteger minVersion = [[array1 objectAt:1] integerValue];
            NSInteger maxVersion = [[array2 objectAt:1] integerValue];
            BOOL isVersion = (appVersion >= minVersion && appVersion <= maxVersion);
            
            if (isDevice && isVersion) {
                isCan = YES;
            }
        }else{
            NSInteger minVersion = [[array1 objectAt:0] integerValue];
            NSInteger maxVersion = [[array2 objectAt:0] integerValue];
            BOOL isVersion = (appVersion >= minVersion && appVersion <= maxVersion);
            
            if (isDevice && isVersion) {
                isCan = YES;
            }
        }
    }
    // 无版本限制
    else if (isDevice) {
        isCan = YES;
    }
    
    return isCan;
}

+(BOOL)canInputWithProvinceList:(NSString *)provinceList currentUserProvinceCode:(NSString *)provinceCode
{
    if (!provinceList||provinceList.length==0) {
        return YES;
    }
    if ([provinceList containsString:provinceCode]) {
        return YES;
    }else return NO;
}

+ (BOOL)canInputActivityWithTime:(NSString *)timeSet andFormatter:(NSString *)formatter{
    BOOL isCan = NO;
    if (timeSet.length>1) {
        NSArray *array = [timeSet componentsSeparatedByString:@"#"];
        if (array.count>1) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:formatter];
            NSDate *startDate = [dateFormatter dateFromString:[array firstObject]];
            NSDate *endDate = [dateFormatter dateFromString:[array objectAt:1]];
            NSDate *currentDate = [NSDate date];
            isCan = ([currentDate compare:startDate] == NSOrderedDescending && [currentDate compare:endDate] == NSOrderedAscending);
        }
    }else {
        isCan = YES;//没有时间默认为有效数据
    }
    return isCan;
}


+(NSMutableDictionary *)parseWebKey_Value:(NSString *)sourceStr withOuter:(NSString *)outerStr withInner:(NSString *)innerStr
{
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    NSArray *keyValueArray = [sourceStr componentsSeparatedByString:outerStr];
    for (NSInteger j = 0; j < [keyValueArray count]; j ++) {
        NSArray *dicArray = [keyValueArray[j] componentsSeparatedByString:innerStr];
        if([dicArray count] == 2){
            [paramDic setObject:dicArray[1] forKey:dicArray[0]];
        }
    }
    return paramDic;
}

/** 解析首页module数据 */
+ (UCiOSAction *)resolveHomeModulesActionStr:(NSString *)actionStr {
    
    // 解析结果
    UCiOSAction *tClass = [[UCiOSAction alloc] init];
    if ([NSString isNullToString:actionStr].length>0) {
        // 分段 ex：ProductListCommonController::0&&mKey::mobile_daquwei_list1##pagetitle::年货筹备##showType::0##apiType::0
        NSArray *actions = [actionStr componentsSeparatedByString:@"&&"];
        // 所有参数 加入字典
        NSMutableDictionary *dataDic = [NSMutableDictionary new];
        for (NSInteger i = 1; i < actions.count; i ++) {
            NSArray *keyValueArray = [actions[i] componentsSeparatedByString:@"##"];
            for (NSInteger j = 0; j < [keyValueArray count]; j ++) {
                NSArray *dicArray = [keyValueArray[j] componentsSeparatedByString:@"::"];
                if([dicArray count] == 2){
                    [dataDic setObject:[dicArray objectAt:1] forKey:[dicArray objectAt:0]];
                }
            }
        }
        // 得到viewController信息
        NSMutableArray *dataArray = [[actions objectAt:0] componentsSeparatedByString:@"::"].mutableCopy;
        // 整合解析
        tClass.mViewControllerName = [[dataArray objectAt:0] mutableCopy];
        tClass.mIsXib = [[dataArray objectAt:1] boolValue];
        tClass.mParams = [dataDic mutableCopy];
    }
    return tClass;
}

+ (UCiOSAction *)resolveModulesActionStr:(NSString *)actionStr{
    /*184版本新加支持##和::分割*/
    if ([actionStr containsString:@"::"]) {
        return [self resolveHomeModulesActionStr:actionStr];
    }
    // 解析结果
    UCiOSAction *tClass = [[UCiOSAction alloc] init];
    if ([NSString isNullToString:actionStr].length>0) {
        // 分段 ex：ProductListCommonController::0&&mKey:mobile_daquwei_list1#pagetitle:年货筹备#showType:0##apiType:0
        NSArray *actions = [actionStr componentsSeparatedByString:@"&&"];
        // 所有参数 加入字典
        NSMutableDictionary *dataDic = [NSMutableDictionary new];
        for (NSInteger i = 1; i < actions.count; i ++) {
            NSArray *keyValueArray = [actions[i] componentsSeparatedByString:@"#"];
            for (NSInteger j = 0; j < [keyValueArray count]; j ++) {
                NSArray *dicArray = [keyValueArray[j] componentsSeparatedByString:@":"];
                if([dicArray count] == 2){
                    [dataDic setObject:[dicArray objectAt:1] forKey:[dicArray objectAt:0]];
                }
            }
        }
        // 得到viewController信息
        NSMutableArray *dataArray = [[actions objectAt:0] componentsSeparatedByString:@":"].mutableCopy;
        // 整合解析
        tClass.mViewControllerName = [[dataArray objectAt:0] mutableCopy];
        tClass.mIsXib = [[dataArray objectAt:1] boolValue];
        tClass.mParams = [dataDic mutableCopy];
    }
    return tClass;
}

@end

