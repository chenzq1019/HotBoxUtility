//
//  HTMarco.h
//  NewProjectOC
//
//  Created by 陈竹青 on 2020/4/2.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#ifndef HTMarco_h
#define HTMarco_h

//*屏幕尺寸相关*//
// 判断是否是刘海屏幕
#define kIphoneX1 \
({\
    BOOL INTERFACE_IS_IPHONEX = NO;\
    if (@available(iOS 11.0, *)) {\
        if([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {\
            INTERFACE_IS_IPHONEX = YES;\
        }\
}\
    INTERFACE_IS_IPHONEX;\
})
#define kIphoneX2 [UIScreen mainScreen].bounds.size.height >= 812
#define kIphoneX (kIphoneX1?kIphoneX1:kIphoneX2)
// 状态栏高度
#define kStatusBarHeight            (kIphoneX ? 44.f : 20.f)
#define kTabBarHeight               ((kStatusBarHeight) > (20) ? (83) : (49))
#define KTabbarSafeBottomMargin     (kIphoneX ? 34.f : 0.f)// Tabbar safe bottom margin.
#define __MainScreenFrame           [[UIScreen mainScreen] bounds]
// 设备屏幕宽
#define __MainScreen_Width          __MainScreenFrame.size.width
// 设备屏幕高
#define __MainScreen_Height         __MainScreenFrame.size.height

#define kSystemVersion              [[[UIDevice currentDevice] systemVersion] floatValue]

#define NonEmpty(A)                 (A==nil?@"":A)

//缩放比例
#define SCALEWIDTH(x)   __MainScreen_Width/320.0*(x)
#define KScreenScale(x) __MainScreen_Width/750.0*(x)
#define kSystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]

/********weak/strong********/
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


/********log********/
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define USLog( s, ... ) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] )
#define debugMethod() NSLog(@"%s", __func__)
#else// 发布状态, 关闭LOG功能
#define NSLog(...)
#define USLog( s, ... )
#define debugMethod()
#endif

#define kViewCtrBackColor [UIColor convertHexToRGB:@"f2f2f2"]

#endif /* HTMarco_h */
