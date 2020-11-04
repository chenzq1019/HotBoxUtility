//
//  CustomAlertViewManager.m
//  
//
//  Created by xulei on 2019/5/6.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "CustomAlertViewManager.h"
#import "UIView+ShowAnimation.h"

@implementation CustomAlertViewManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (BOOL)addCustomAlertView:(UIView *)alertView{
    return  [self addCustomAlertView:alertView identify:@""];
}

- (BOOL)addCustomAlertView:(UIView *)alertView identify:(NSString *)identify{
    BOOL findSame=NO;
    for (UIView *subAlert in self.cacheViewsArray) {
        if ([subAlert.identify isEqualToString:identify]&&subAlert.identify.length>0) {
            findSame=YES;
            break;
        }
    }
    if (findSame==NO) {
        alertView.identify=identify;
        [self.cacheViewsArray addObject:alertView];
    }
    return YES;
}

- (void)insertCustAlertView:(UIView *)alertView atIndex:(NSInteger)index{
    BOOL findSame=NO;
    for (UIView *subAlert in self.mViewsArray) {
        if ([subAlert.identify isEqualToString:alertView.identify]&&subAlert.identify.length>0) {
            findSame=YES;
            break;
        }
    }
    if (findSame==NO) {
        //如果index<0则再数组后面插入视图
        if (index<0) {
            [self.mViewsArray addObject:alertView];
        }else{
            [self.mViewsArray insertObject:alertView atIndex:index];
        }
    }
}


//移除view
- (void)removeAlertView:(UIView *)alertView{
    if ([self.mViewsArray containsObject:alertView]) {
        [self.mViewsArray removeObject:alertView];
    }
}



- (void)sortCurrentAlertViews{
    if (self.cacheViewsArray.count>0) {
        for (UIView *subAlert in self.cacheViewsArray) {
            [self insertCustAlertView:subAlert atIndex:-1];
        }
        [self.cacheViewsArray removeAllObjects];
    }
    if (self.mViewsArray.count<=0) {
        return;
    }
    NSArray *sortedArray = [self.mViewsArray sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        return obj1.orderNum < obj2.orderNum;
    }];
    self.mViewsArray = [sortedArray mutableCopy];
    //    self.mViewsArray=[self.cacheViewsArray mutableCopy];
}

- (void)showApplicationAlertView{
    if (self.mViewsArray.count<=0 || self.isCancelShowAutomic) {
        self.isCancelShowAutomic=NO;
        if (self.mViewsArray.count<=0) {
            if (self.finishBlock) {
                self.finishBlock();
                self.finishBlock = nil;
            }
        }
        return;
    }
    UIView *alertView = [self.mViewsArray firstObject];
    if (alertView.bindVCName.length>0&&![alertView.bindVCName isEqualToString:NSStringFromClass([self.currentViewController class])]) {
        return;
    }else {
        AniamtionType animation=alertView.animationType?alertView.animationType:AniamtionAlert;
        [alertView showViewWithAnimation:animation];
    }
}

#pragma mark - <getters>
- (NSMutableArray *)cacheViewsArray{
    if (!_cacheViewsArray) {
        _cacheViewsArray = [NSMutableArray array];
    }
    return _cacheViewsArray;
}

- (NSMutableArray *)mViewsArray{
    if (!_mViewsArray) {
        _mViewsArray = [NSMutableArray array];
    }
    return _mViewsArray;
}

#pragma mark - 获取当前viewController
/** appdelegate */
- (id<UIApplicationDelegate>)applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

/** 返回当前控制器 */
- (UIViewController *)currentViewController {
    
    UIViewController *rootViewController = self.applicationDelegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

/** 返回当前的导航控制器 */
- (UINavigationController *)currentNavigationViewController {
    
    UIViewController *currentViewController = self.currentViewController;
    return currentViewController.navigationController;
}

/** 通过递归拿到当前控制器 */
- (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController {
    
    // 如果传入的控制器是导航控制器,则返回最后一个
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }
    // 如果传入的控制器是tabBar控制器,则返回选中的那个
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    }
    // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    }
    else {
        return viewController;
    }
}

@end
