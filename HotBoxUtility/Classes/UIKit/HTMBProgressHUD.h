//
//  HTMBProgressHUD.h
//  \
//
//  Created by chenzhuqing on 16/8/9.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+Extension.h"

static CGFloat showDelayTime=1.5;
OBJC_EXPORT NSString *  const showText;

@interface HTMBProgressHUD : NSObject

@property (nonatomic,strong) MBProgressHUD * hud;

+ (instancetype) instantce;

//在view上显示
+ (void)showHUDAddedTo:(UIView *)view withText:(NSString *)text;
+ (void)hideHUDForView:(UIView *)view;
+ (void)showHUDAddedTo:(UIView*)view withText:(NSString *)text afterDelay:(NSTimeInterval)delay;
+ (void)showHUDAddedTo:(UIView*)view withText:(NSString *)text afterDelay:(NSTimeInterval)delay withTarget:(id)delegate dothing:(SEL)toDo;
+ (void)showHUDAddedTo:(UIView*)view withImage:(UIImage *)image afterDelay:(NSTimeInterval)delay;

//在window上显示
+ (void)showHUDWithText:(NSString *)text;
+ (void)hideHUD;
+ (void)showHUDWithText:(NSString *)text afterDelay:(NSTimeInterval)delay;
+ (void)showHUDWithText:(NSString *)text afterDelay:(NSTimeInterval)delay withTarget:(id)target dothing:(SEL)toDo;
+ (void)showHUDWithImage:(UIImage *)image afterDelay:(NSTimeInterval)delay;
@end
