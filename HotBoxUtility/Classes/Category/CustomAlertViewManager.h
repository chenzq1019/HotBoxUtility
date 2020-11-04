//
//  CustomAlertViewManager.h
//  
//
//  Created by xulei on 2019/5/6.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^CustomAlertViewManagerFinish)(void);
@interface CustomAlertViewManager : NSObject
@property (nonatomic, assign) BOOL              isCancelShowAutomic;//是否需要暂停弹框消失后自动弹下一个
@property (nonatomic, strong) UIView            * _Nullable currentShowedAlertView;//当前显示的弹框
@property (nonatomic, strong) NSMutableArray    *cacheViewsArray;//临时数据源
@property (nonatomic, strong) NSMutableArray    *mViewsArray;//真正的数据源
@property (nonatomic, strong) _Nullable CustomAlertViewManagerFinish  finishBlock;

@property (nonatomic, strong) UIViewController * _Nullable currentViewController;
+ (instancetype)sharedManager;
//添加view
- (BOOL)addCustomAlertView:(UIView *)alertView;
//添加view并设置identify唯一值
- (BOOL)addCustomAlertView:(UIView *)alertView identify:(NSString *)identify;
//插入一个view到最顶
- (void)insertCustAlertView:(UIView *)alertView atIndex:(NSInteger)index;
//移除view
- (void)removeAlertView:(UIView *)alertView;
//排序
- (void)sortCurrentAlertViews;
//触发弹框显示
- (void)showApplicationAlertView;

@end

NS_ASSUME_NONNULL_END
