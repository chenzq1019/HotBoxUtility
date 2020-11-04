//
//  ModulesDataToAction.h
//
//
//  Created by shengyang_yu on 16/8/23.
//  Copyright © 2016年 HotBox. All rights reserved.
//
//  处理首页、个人中心模块数据划分，iOS action解析
//

#import <Foundation/Foundation.h>

/** iOS action */
@interface UCiOSAction : NSObject

/** ViewController Name */
@property (nonatomic, copy) NSString *mViewControllerName;
/** 是否有xib */
@property (nonatomic, assign) BOOL mIsXib;
/** 初始化参数 */
@property (nonatomic, strong) NSMutableDictionary *mParams;

@end
/** 用来解析data对象iOS action */
@interface ModulesDataToAction : NSObject

/** 过滤banner等数据 */
+ (BOOL)canInputDataMin:(NSString *)minString withMax:(NSString *)maxString withDevice:(NSString *)devicetype withAppVersion:(NSInteger)appVersion;

//根据用户属性和所选省机构过滤
+(BOOL)canInputWithProvinceList:(NSString *)provinceList currentUserProvinceCode:(NSString *)provinceCode;

//根据活动起始/结束时间过滤
+ (BOOL)canInputActivityWithTime:(NSString *)timeSet andFormatter:(NSString *)formatter;

//解析H5的键值对
+ (NSMutableDictionary *)parseWebKey_Value:(NSString *)sourceStr withOuter:(NSString *)outStr withInner:(NSString *)innerStr;

/** 解析module数据(参数分割符为#，: 或者##, ::) */
+ (UCiOSAction *)resolveModulesActionStr:(NSString *)actionStr;

@end
