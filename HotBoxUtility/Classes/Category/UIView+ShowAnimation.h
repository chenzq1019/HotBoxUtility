//
//  UIView+ShowAnimation.h
//
//
//  Created by chenzhuqing on 2016/11/17.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AniamtionTransform3D,
    AniamtionPresentBottom,
    AniamtionAlert,
    AnimationAlertClick,//背景有点击消失事件，
    AniamtionTypeNone,
} AniamtionType;

@interface UIView (ShowAnimation)

@property (nonatomic, strong) UIView * showBackgroundView;
@property (nonatomic, assign) NSString * alpha_backgroundView;
@property (nonatomic, strong) UIImageView * rootCutView;
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) AniamtionType animationType;
@property (nonatomic, assign) BOOL showToTop;
@property (nonatomic, strong) UIView * showRootView;
@property (nonatomic, copy) NSString    *bindVCName;
@property (nonatomic, assign)NSInteger  orderNum;
@property (nonatomic, copy) NSString * identify;
@property (nonatomic, copy) void (^mCompleteBlock)(void);

- (void)hiddenView;

- (void)hiddenViewWithCompletion:(void(^)(void))completion;

- (void)showViewWithAnimation:(AniamtionType) animationType;

- (void)showViewWithAnimation:(AniamtionType) animationType atView:(UIView *) rootView;

//弹出框永远显示到到最上层 （AniamtionTransform3D 方式除外，因为这种方式一般是用户主动点击显示）
- (void)showViewToTopWithAnimation:(AniamtionType) animationType;
@end
