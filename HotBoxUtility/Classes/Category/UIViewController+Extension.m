//
//  UIViewController+Extension.m
//
//
//  Created by shengyang_yu on 16/4/20.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>
#import <UIColor+ColorUtility.h>

@implementation UIViewController (Extension)

#pragma mark - perproty
- (void)setM_Params:(NSMutableDictionary *)m_Params {
    objc_setAssociatedObject(self, @"m_Params", m_Params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)m_Params {
    NSMutableDictionary *nObject = objc_getAssociatedObject(self, @"m_Params");
    return nObject;
}

- (void)setBackIconColorStr:(NSString *)backIconColorStr{
    objc_setAssociatedObject(self, @"backIconColorStr", backIconColorStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)backIconColorStr{
    NSString *nObject = objc_getAssociatedObject(self, @"backIconColorStr");
    return nObject;
}

- (void)setTitleColorStr:(NSString *)titleColorStr{
    objc_setAssociatedObject(self, @"titleColorStr", titleColorStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)titleColorStr{
    NSString *nObject = objc_getAssociatedObject(self, @"titleColorStr");
    return nObject;
}


- (void)setExitAfterJump:(NSString *)exitAfterJump {
    objc_setAssociatedObject(self, @"exitAfterJump", exitAfterJump, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)exitAfterJump {
    NSString *nObject = objc_getAssociatedObject(self, @"exitAfterJump");
    return nObject;
}

- (void)setBackJumpWebView:(NSString *)backJumpWebView {
    objc_setAssociatedObject(self, @"backJumpWebView", backJumpWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)backJumpWebView {
    NSString *nObject = objc_getAssociatedObject(self, @"backJumpWebView");
    return nObject;
}

#pragma mark - pushViewController
/**
 *  pushViewController
 *
 *  @param controllerName   push的目标页
 *  @param isNib            是否带 xib 文件
 *  @param mData            mData
 */
- (void)pushNewViewController:(NSString *)controllerName
                    isNibPage:(BOOL)isNib
                     withData:(NSMutableDictionary *)mData {
    
    [self pushNewViewController:controllerName isNibPage:isNib withData:mData withReplace:NO];
}

/** 如果push对象为self,直接替换更新 */
- (void)pushNewViewController:(NSString *)controllerName
                    isNibPage:(BOOL)isNib
                     withData:(NSMutableDictionary *)mData
                  withReplace:(BOOL)replace {
    
    if (controllerName.length <= 0)
        return;
    
#pragma tt 目前项目没有xib
    isNib = NO;
    // end
    
    Class class_Page = [UIViewController getClassMapViewController:controllerName];
    
    if (class_Page != nil) {
        
        id viewCtrl_Page = isNib ? [[class_Page alloc] initWithNibName:controllerName bundle:nil]
        : [[class_Page alloc] init];
        //1. 传递值,不需要记录上一vc所有值,需要传递的手动添加
        if (mData) {
            [viewCtrl_Page setM_Params:nil];
            [viewCtrl_Page setM_Params:mData];
        }
        Class webView=NSClassFromString(@"DetailWebViewController");
        if([self isMemberOfClass:[webView class]]){
            if([self.exitAfterJump isEqualToString:@"1"]){
                if(mData == nil){
                    mData = [[NSMutableDictionary alloc]init];
                }
                [mData setObject:@YES forKey:@"backJumpWebView"];
            }
        }
        //2. 关于需要设置代理统一命名为m_delegate即可
        SEL delegateMethod = NSSelectorFromString(@"setM_delegate:");
        if ([viewCtrl_Page respondsToSelector:delegateMethod]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [viewCtrl_Page performSelector:delegateMethod withObject:self];
#pragma clang diagnostic pop
        }
        //3. 如果是相同viewController,刷新即可
        if (replace && [self.navigationController.viewControllers.lastObject isKindOfClass:class_Page]) {
            NSArray *viewControllers = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(0, self.navigationController.viewControllers.count-1)];
            ((UIViewController *)viewCtrl_Page).hidesBottomBarWhenPushed = YES;
            [self.navigationController setViewControllers:[viewControllers arrayByAddingObject:viewCtrl_Page] animated:YES];
        }
        else {
            [self.navigationController pushViewController:viewCtrl_Page animated:YES];
        }
        NSString * fromVC= NSStringFromClass([self class]);
        NSString * toVC=controllerName;
    }
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - navigationItem
- (void)customTitleLabel:(NSString *)labelText{
    UILabel *lab = ({
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160-20, 44)];
        lab.text = labelText;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
        lab.backgroundColor = [UIColor clearColor];
        NSString * colorStr=self.titleColorStr.length>0?self.titleColorStr:@"333333";
        lab.textColor = [UIColor convertHexToRGB:colorStr];
        lab;
    });
    self.navigationItem.titleView = lab;
}

- (void)setNavigationBackButton {
    
    //若为主页，则不增加返回按钮
    UIButton *l_backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [l_backBtn setBackgroundColor:[UIColor clearColor]];
    NSString * colorStr=self.backIconColorStr.length>0?self.backIconColorStr:@"333333";
    l_backBtn.tintColor=[UIColor convertHexToRGB:colorStr];
    [l_backBtn setImage:[[UIImage imageNamed:@"utility_NavigationBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    l_backBtn.imageEdgeInsets = UIEdgeInsetsMake(9, 0, 9,18);
    [l_backBtn addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar_Btn = [[UIBarButtonItem alloc]initWithCustomView:l_backBtn];
    self.navigationItem.leftBarButtonItems = @[bar_Btn];
    //self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
}
- (void)goToBack{
    NSArray * controllers = self.navigationController.childViewControllers;
    if(controllers.count > 2){
        Class class_Page = [controllers objectAtIndex:controllers.count-2];
        NSString * objName=NSStringFromClass([class_Page class]);
        if([[self.m_Params objectForKey:@"backJumpWebView"]boolValue] && [objName isEqualToString:@"DetailWebViewController"]){
            [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-3] animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AppProtocol
/**
 设置背景色,去除默认透明背景色
 */
- (void)setWhiteBackGroundColor {
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - common Method

- (void)showAlert:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (Class)getClassMapViewController:(NSString *)controllerName{
    if (controllerName.length <= 0)
    return nil;
    NSURL *matchFileURL = [[NSBundle mainBundle] URLForResource:@"viewNameMatch" withExtension:@"plist"];
    NSDictionary *matchDic = [NSDictionary dictionaryWithContentsOfURL:matchFileURL];
    NSString * matchName=[matchDic objectForKey:controllerName];
    if (matchName.length>0) {
        controllerName=matchName;
    }
    
    Class class_Page = NSClassFromString((NSString *)controllerName);
    return class_Page;
}

/** appdelegate */
+ (id<UIApplicationDelegate>)applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

/** 返回当前控制器 */
+ (UIViewController *)currentViewController {
    
    UIViewController *rootViewController = [self applicationDelegate].window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

/** 返回当前的导航控制器 */
+ (UINavigationController *)currentNavigationViewController {
    
    UIViewController *currentViewController = [self currentViewController];
    return currentViewController.navigationController;
}

/** 通过递归拿到当前控制器 */
+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController {
    
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

#pragma mark --<屏幕方向>
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
