//
//  DeviceInfoHelper.h
//  u_store
//
//  Created by xulei on 2018/6/14.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,UIDeviceResolution) {
    
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes = 3,
    // iPhone 6 高清分辨率(750x1334px)
    UIDevice_iPhone6Res = 4,
    // iPhone 6 PLUS 高清分辨率(1242x2208px)
    UIDevice_iPhone6PlusRes = 5,
    // iPhone X 高清分辨率(1125x2436px)
    UIDevice_iPhoneXRes = 6,
    // iPhone Xr 高清分辨率(828x1792px)
    UIDevice_iPhoneXrRes = 7,
    // iPhone XMax 高清分辨率(1242x2688px)
    UIDevice_iPhoneXMaxRes = 8,
    
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes = 3,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes = 3
};

@interface DeviceInfoHelper : NSObject
//获取手机platformString
+ (NSString *) platformString;

//根据当前设备分辨率来判断机型
+ (UIDeviceResolution) currentResolution;

//获取当前launchImage名称
+ (NSString *)queryLaunchImage;
//获取分辨率
+ (NSString *)getScreenPix;

+ (NSString *)getAppName;

+ (NSString *)getAppVersion;

+ (NSInteger)getAppVersionNum;

@end
