//
//  UIView+ShowAnimation.m
//
//
//  Created by chenzhuqing on 2016/11/17.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import "UIView+ShowAnimation.h"
#import "UIWindow+ScreenShot.h"
#import <objc/runtime.h>
#import "CustomAlertViewManager.h"
#define kScreenW   [[UIScreen mainScreen] bounds].size.width
#define kScreenH   [[UIScreen mainScreen] bounds].size.height
#define kTopViewTag                 3215
#define kTopViewBackgroundViewTag   3214


static char TAG_ROOTCUTVIEW;
static char TAG_BACKGROUND;
static char TAG_ALPHA_BACKGROUND;
static char TAG_ANIMATION;
static char TAG_ANIMATIONTYPE;
static char TAG_SHOWTOTOP;
static char TAG_ROOTVIEW;
static char TAG_COMPLETEBLOCK;
static char TAG_BINDVCNAME;
static char TAG_ORDERNUM;
static char TAG_IDENTIFY;

@implementation UIView (ShowAnimation)

- (void)setMCompleteBlock:(void (^)(void))mCompleteBlock
{
    objc_setAssociatedObject(self, &TAG_COMPLETEBLOCK, mCompleteBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))mCompleteBlock
{
    return objc_getAssociatedObject(self, &TAG_COMPLETEBLOCK);
}

- (void)setShowRootView:(UIView *)showRootView{
    objc_setAssociatedObject(self, &TAG_ROOTVIEW, showRootView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)showRootView{
    return objc_getAssociatedObject(self, &TAG_ROOTVIEW);
}

- (void)setRootCutView:(UIImageView *)rootCutView{
    objc_setAssociatedObject(self, &TAG_ROOTCUTVIEW, rootCutView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)rootCutView{
    return (UIImageView*)objc_getAssociatedObject(self, &TAG_ROOTCUTVIEW);
}

- (void)setShowBackgroundView:(UIView *)showBackgroundView{
    objc_setAssociatedObject(self, &TAG_BACKGROUND, showBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)showBackgroundView{
    return (UIView*)objc_getAssociatedObject(self, &TAG_BACKGROUND);
}

- (void)setAlpha_backgroundView:(NSString *)alpha_backgroundView{
    objc_setAssociatedObject(self, &TAG_ALPHA_BACKGROUND, alpha_backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)alpha_backgroundView{
    return objc_getAssociatedObject(self, &TAG_ALPHA_BACKGROUND);
}

- (void)setAnimation:(BOOL)animation{
    objc_setAssociatedObject(self, &TAG_ANIMATION,  [NSNumber numberWithBool:animation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)animation{
    return [objc_getAssociatedObject(self, &TAG_ANIMATION) boolValue];
}

- (void)setAnimationType:(AniamtionType)animationType{
    objc_setAssociatedObject(self, &TAG_ANIMATIONTYPE, [NSNumber numberWithInteger:animationType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AniamtionType)animationType{
    return [objc_getAssociatedObject(self, &TAG_ANIMATIONTYPE) integerValue];
}

- (void)setShowToTop:(BOOL)showToTop{
    objc_setAssociatedObject(self, &TAG_SHOWTOTOP,  [NSNumber numberWithBool:showToTop], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)showToTop{
    return [objc_getAssociatedObject(self, &TAG_SHOWTOTOP) boolValue];
}
- (void)setBindVCName:(NSString *)bindVCName{
    objc_setAssociatedObject(self, &TAG_BINDVCNAME, bindVCName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)bindVCName{
    return objc_getAssociatedObject(self, &TAG_BINDVCNAME);
}

- (void)setOrderNum:(NSInteger)orderNum{
    objc_setAssociatedObject(self, &TAG_ORDERNUM, [NSNumber numberWithInteger:orderNum], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)orderNum{
    return [objc_getAssociatedObject(self, &TAG_ORDERNUM) integerValue];
}

- (void)setIdentify:(NSString *)identify{
    objc_setAssociatedObject(self, &TAG_IDENTIFY, identify, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)identify{
    return objc_getAssociatedObject(self, &TAG_IDENTIFY);
}


- (void)hiddenView{
    if ([self isEqual:[CustomAlertViewManager sharedManager].currentShowedAlertView]) {
        [CustomAlertViewManager sharedManager].currentShowedAlertView = nil;
    }
    switch (self.animationType) {
        case AniamtionTransform3D:{
            [self dimissTransform3DView];
        }
            break;
        case AniamtionPresentBottom:{
            [self dismissPresentView];
        }
            break;
        case AniamtionAlert:{
            [self dismissAlertView];
        }
            break;
        case AnimationAlertClick:{
            [self dismissAlertView];
        }
        case AniamtionTypeNone:{
            [self dismissAlertViewAniamtionNone];
        }
            break;
        default:
            break;
    }
}

- (void)hiddenViewWithCompletion:(void (^)(void))completion
{
    self.mCompleteBlock = completion;
    [self hiddenView];
}

//当有多个弹出框同时显示 此弹出框永远显示到到最上层 （AniamtionTransform3D 方式除外，因为这种方式一般是用户主动点击显示）
- (void)showViewToTopWithAnimation:(AniamtionType) animationType{
    self.showToTop=YES;
    [self showViewWithAnimation:animationType];
}

- (void)hiddeCurrentAlertAndShowNewAlert:(AniamtionType)animationType{
    [CustomAlertViewManager sharedManager].isCancelShowAutomic = YES;
    [[CustomAlertViewManager sharedManager].currentShowedAlertView hiddenView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow * window=[UIApplication sharedApplication].delegate.window;
        [self showViewWithAnimation:animationType atView:window];
        [CustomAlertViewManager sharedManager].currentShowedAlertView = self;
        [[CustomAlertViewManager sharedManager] removeAlertView:self];
    });
}

- (void)showViewWithAnimation:(AniamtionType) animationType{
    //判断当前是否有Alert处于显示状态
    if ([CustomAlertViewManager sharedManager].currentShowedAlertView) {
        //如果当前有显示判断优先级，如果即将显示的优先级高则直接显示，
        if ([CustomAlertViewManager sharedManager].currentShowedAlertView.orderNum < self.orderNum) {
            //现将当前显示的插入到待显示的第一个位置，然后将其隐藏显示一个优先级更好的Alert
            [[CustomAlertViewManager sharedManager] insertCustAlertView:[CustomAlertViewManager sharedManager].currentShowedAlertView atIndex:0];
            [self hiddeCurrentAlertAndShowNewAlert:animationType];
        }else {
            //如果identify相同且优先级相同则不要添加到数组中，直接隐藏并显示一个新的
            if ([CustomAlertViewManager sharedManager].currentShowedAlertView.orderNum == self.orderNum&&[CustomAlertViewManager sharedManager].currentShowedAlertView.identify.length>0&&[[CustomAlertViewManager sharedManager].currentShowedAlertView.identify isEqualToString:self.identify]) {
                [self hiddeCurrentAlertAndShowNewAlert:animationType];
                return;
            }else{
                //添加到待显示数组中，并重新排序
                self.animationType=animationType;
                [[CustomAlertViewManager sharedManager] insertCustAlertView:self atIndex:0];
                [[CustomAlertViewManager sharedManager] sortCurrentAlertViews];
            }
        }
    }else {
        //当前没有则直接显示新的Alert。
        UIWindow * window=[UIApplication sharedApplication].delegate.window;
        [self showViewWithAnimation:animationType atView:window];
        [CustomAlertViewManager sharedManager].currentShowedAlertView = self;
        [[CustomAlertViewManager sharedManager] removeAlertView:self];
    }
}

- (void)showViewWithAnimation:(AniamtionType) animationType atView:(UIView *) rootView{
    self.showRootView=rootView;
    if (animationType == AniamtionTransform3D) {
        if (self.rootCutView==nil) {
            self.rootCutView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rootViewClick:)];
            self.rootCutView.userInteractionEnabled=YES;
            [self.rootCutView addGestureRecognizer:tap];
        }
        self.rootCutView.image=[[UIApplication sharedApplication].delegate.window screenshot];
    }
    if (self.showBackgroundView==nil) {
        self.showBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        self.showBackgroundView.backgroundColor=[UIColor blackColor];
        self.showBackgroundView.alpha=0.0;
        
    }
    [self setViewTag];
    [self.showRootView addSubview:self.showBackgroundView];
    self.animationType=animationType;
    switch (animationType) {
        case AniamtionTransform3D:{
            [self.showRootView addSubview:self.rootCutView];
            [self.showRootView addSubview:self];
            [self showTransForm3DAnimation];
        }
            break;
        case AniamtionPresentBottom:{
            [self.showRootView addSubview:self];
            [self windowBringViewToFront:self.showRootView];
            [self showPresentAnimation];
        }
            break;
        case AniamtionAlert:{
            [self.showRootView addSubview:self];
            [self windowBringViewToFront:self.showRootView];
            [self showAlertAnimation];
        }
            break;
        case AnimationAlertClick:{
            [self.showRootView addSubview:self];
            [self windowBringViewToFront:self.showRootView];
            [self showAlertAnimationWithTapClick:YES];
        }
        case AniamtionTypeNone:{
            [self.showRootView addSubview:self];
            [self windowBringViewToFront:self.showRootView];
            [self showAlertAniamtionNone];
        }
            break;
        default:
            break;
    }
}

- (void)setViewTag{
    if (self.showToTop) {
        UIWindow * window=[UIApplication sharedApplication].delegate.window;
        NSArray * array=window.subviews;
        for (UIView * view in array) {
            if (view.tag==kTopViewTag || view.tag==kTopViewBackgroundViewTag) {
                view.tag=0;
            }
        }
        self.tag=kTopViewTag;
        self.showBackgroundView.tag=kTopViewBackgroundViewTag;
    }
}

- (void)windowBringViewToFront:(UIView * )window{
    NSArray * array=window.subviews;
    for (UIView * view in array) {
        if (view.tag==kTopViewBackgroundViewTag) {
            [window bringSubviewToFront:view];
            break;
        }
    }
    for (UIView * view in array) {
        if (view.tag==kTopViewTag) {
            [window bringSubviewToFront:view];
            break;
        }
    }
}

- (void)showTransForm3DAnimation{
    CGFloat frameH=CGRectGetHeight(self.frame);
    self.frame=CGRectMake(0, kScreenH, kScreenW,frameH);
    self.rootCutView.layer.zPosition = 400;
    self.layer.zPosition=500;
    self.showBackgroundView.alpha=1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.rootCutView.alpha=0.6;
        self.frame=CGRectMake(0, kScreenH-frameH, kScreenW,frameH);
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -300;
        self.rootCutView.layer.shadowOpacity = 0.01;
        self.rootCutView.layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, 8.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.rootCutView.layer.affineTransform = CGAffineTransformMakeScale(0.93, 0.93);
            
        }];
    }];
}

- (void)showPresentAnimation{
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rootViewClick:)];
    self.showBackgroundView.userInteractionEnabled=YES;
    [self.showBackgroundView addGestureRecognizer:tap];
    
    CGFloat frameH=CGRectGetHeight(self.frame);
    self.frame=CGRectMake(0, kScreenH, kScreenW,frameH);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(0, kScreenH-frameH, kScreenW,frameH);
        if (self.alpha_backgroundView&&self.alpha_backgroundView.length>0) {
            self.showBackgroundView.alpha=[self.alpha_backgroundView floatValue];
        }else{
            self.showBackgroundView.alpha=0.4;
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAlertAnimation{
    CGFloat frameH=CGRectGetHeight(self.frame);
    CGFloat framW=CGRectGetWidth(self.frame);
    self.frame=CGRectMake((kScreenW-framW)/2.0, (kScreenH-frameH)/2.0, framW,frameH);
    [self setNeedsDisplay];
    self.transform= CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:0.2f animations:^{
        if (self.alpha_backgroundView&&self.alpha_backgroundView.length>0) {
            self.showBackgroundView.alpha=[self.alpha_backgroundView floatValue];
        }else{
            self.showBackgroundView.alpha=0.4;
        }
        self.transform= CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)showAlertAnimationWithTapClick:(BOOL)tapClick{
    if (tapClick) {
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rootViewClick:)];
        self.showBackgroundView.userInteractionEnabled=YES;
        [self.showBackgroundView addGestureRecognizer:tap];
    }
    [self showAlertAnimation];
}

- (void)showAlertAniamtionNone{
    CGFloat frameH=CGRectGetHeight(self.frame);
    CGFloat framW=CGRectGetWidth(self.frame);
    self.frame=CGRectMake((kScreenW-framW)/2.0, (kScreenH-frameH)/2.0, framW,frameH);
    [self setNeedsDisplay];
    if (self.alpha_backgroundView&&self.alpha_backgroundView.length>0) {
        self.showBackgroundView.alpha=[self.alpha_backgroundView floatValue];
    }else{
        self.showBackgroundView.alpha=0.4;
    }
}

- (void)dimissTransform3DView{
    [UIView animateWithDuration:0.3 animations:^{
        CALayer *layer = self.rootCutView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 300;
        layer.shadowOpacity = 0.01;
        layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, -10.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.rootCutView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.rootCutView.alpha=1.0;
            self.frame=CGRectMake(0, kScreenH, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame));
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.rootCutView removeFromSuperview];
            [self.showBackgroundView removeFromSuperview];
            [self dismissComplentFunction];
        }];
    }];
}

- (void)dismissPresentView{
    [UIView animateWithDuration:0.3 animations:^{
        self.showBackgroundView.alpha=0.0;
        self.frame=CGRectMake(0, kScreenH, kScreenW,self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.showBackgroundView removeFromSuperview];
        self.showBackgroundView=nil;
        [self dismissComplentFunction];
    }];
}

- (void)dismissAlertView{
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.transform = CGAffineTransformMakeScale(1.0,1.0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
        self.showBackgroundView.alpha=0.0;
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished2){
        self.transform = CGAffineTransformIdentity;
        self.alpha=1.0;
        [self removeFromSuperview];
        [self.showBackgroundView removeFromSuperview];
        self.showBackgroundView=nil;
        [self dismissComplentFunction];
    }];
}

- (void)dismissAlertViewAniamtionNone{
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.alpha = 0;
    self.showBackgroundView.alpha=0.0;
    [self removeFromSuperview];
    [self.showBackgroundView removeFromSuperview];
    self.showBackgroundView=nil;
    [self dismissComplentFunction];
}

- (void)dismissComplentFunction{
    [[CustomAlertViewManager sharedManager] showApplicationAlertView];
    if (self.mCompleteBlock) {
        self.mCompleteBlock();
    }
}

- (void) rootViewClick:(UIGestureRecognizer *)sender{
    [self hiddenView];
}
@end
