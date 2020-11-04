//
//  UIViewController+Extension.h
//
//
//  Created by shengyang_yu on 16/4/20.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

/**
 * 值传递
 */
@property (nonatomic, strong) NSMutableDictionary *m_Params;
/**
 * 跳转下一页关闭当页 实际只是返回时候跳过这一页返回
 */
@property (nonatomic, copy) NSString * exitAfterJump;
/**
 * 返回时候跳过webView页
 */
@property (nonatomic, strong) NSString *backJumpWebView;
/**
 *返回按键的颜色
 */
@property (nonatomic, strong) NSString * backIconColorStr;
/**
 *导航栏Title字体颜色
 */
@property (nonatomic, strong) NSString * titleColorStr;

/**
 * push pop
 */
- (void)pushNewViewController:(NSString *)controllerName
                    isNibPage:(BOOL)isNib
                     withData:(NSMutableDictionary *)mData;

- (void)pushNewViewController:(NSString *)controllerName
                    isNibPage:(BOOL)isNib
                     withData:(NSMutableDictionary *)mData
                  withReplace:(BOOL)replace;

- (void)popViewController;

/**
 * navigationItem
 */
- (void)customTitleLabel:(NSString *)labelText;
//- (void)titleLabel:(NSString *)labelText;
- (void)setNavigationBackButton;
/**
 常用方法
 */
- (void)showAlert:(NSString *)message;

/**
 获取类对象
 */
+ (Class)getClassMapViewController:(NSString *)controllerName;

/**
 *  返回当前控制器
 *  @return 控制器
 */
+ (UIViewController *)currentViewController;

/**
 *  返回当前的导航控制器
 *  @return 控制器
 */
+ (UINavigationController *)currentNavigationViewController;

/** 通过递归拿到当前控制器 */
+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController;

@end
