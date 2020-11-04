//
//  HTMBProgressHUD.m
//
//
//  Created by chenzhuqing on 16/8/9.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import "HTMBProgressHUD.h"
#import <objc/message.h>

NSString *  const showText=@"正在加载";

#define msgSend(...) ((void (*)(void *, SEL, id))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)

@interface HTMBProgressHUD ()<MBProgressHUDDelegate1>
@property (nonatomic,weak) id target;
@property (nonatomic,assign) SEL method;
@property (nonatomic,strong) UIWindow * keyWindow;
@end

@implementation HTMBProgressHUD

+ (instancetype) instantce{
    static dispatch_once_t onceToken;
    static HTMBProgressHUD * obj=nil;
    dispatch_once(&onceToken, ^{
        obj=[[HTMBProgressHUD alloc] init];
    });
    return obj;
}

+ (void)showHUDAddedTo:(UIView *)view withText:(NSString *)text{
        [HTMBProgressHUD hideHUDForView:view];
        MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:view];
        hud.layer.zPosition=4000;
        hud.removeFromSuperViewOnHide=YES;
        hud.detailsLabel.text= text;
        hud.detailsLabel.font=[UIFont boldSystemFontOfSize:16.0];
        [view addSubview:hud];
        [hud showAnimated:YES];
}



+ (void)hideHUDForView:(UIView *)view{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            if (subview != nil) {
                ((MBProgressHUD * )subview).removeFromSuperViewOnHide = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [((MBProgressHUD * )subview) hideAnimated:YES];
                });
            }
        }
    }
}

+ (MBProgressHUD *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            return (MBProgressHUD *)subview;
        }
    }
    return nil;
}

+ (void)showHUDAddedTo:(UIView*)view withText:(NSString *)text afterDelay:(NSTimeInterval)delay{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HTMBProgressHUD hideHUDForView:view];
        MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:view];
        hud.layer.zPosition=4000;
        hud.removeFromSuperViewOnHide=YES;
        hud.detailsLabel.text=text;
        hud.detailsLabel.font=[UIFont boldSystemFontOfSize:16.0];
        hud.mode = MBProgressHUDModeText;
        hud.delegate=[HTMBProgressHUD instantce];
        [view addSubview:hud];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:delay];
        [HTMBProgressHUD instantce].hud=hud;
    });
}

+ (void)showHUDAddedTo:(UIView*)view withText:(NSString *)text afterDelay:(NSTimeInterval)delay withTarget:(id)target dothing:(SEL)toDo{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HTMBProgressHUD hideHUDForView:view];
        MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:view];
        hud.layer.zPosition=4000;
        hud.removeFromSuperViewOnHide=YES;
        hud.detailsLabel.text=text;
        hud.detailsLabel.font=[UIFont boldSystemFontOfSize:16.0];
        hud.mode = MBProgressHUDModeText;
        hud.delegate1=[HTMBProgressHUD instantce];
        [view addSubview:hud];
        [hud showAnimated:YES];
        [hud hide:YES afterDelay:delay dothing:YES];
        [HTMBProgressHUD instantce].target=target;
        [HTMBProgressHUD instantce].method=toDo;
        [HTMBProgressHUD instantce].hud=hud;
    });
}

+ (void)showHUDAddedTo:(UIView*)view withImage:(UIImage *)image afterDelay:(NSTimeInterval)delay{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];;
        hud.mode = MBProgressHUDModeCustomView;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor clearColor];
        hud.animationType=MBProgressHUDAnimationZoom;
        UIImageView *imgV = [[UIImageView alloc] initWithImage:image];
        hud.customView = imgV;
        hud.square = YES;
        hud.label.text = @"";
        [hud hideAnimated:YES afterDelay:delay];
    });
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    [[HTMBProgressHUD instantce].hud removeFromSuperview];
    [HTMBProgressHUD instantce].hud=nil;
}

- (void)HUDdelayDo{
    
    if ([[HTMBProgressHUD instantce].target respondsToSelector:[HTMBProgressHUD instantce].method]) {
        msgSend(msgTarget([HTMBProgressHUD instantce].target),[HTMBProgressHUD instantce].method,nil);
    }

}


#pragma mark - window
+ (void)showHUDWithText:(NSString *)text{
    UIWindow * window=[[UIApplication sharedApplication] keyWindow];
    [HTMBProgressHUD showHUDAddedTo:window withText:text];
}

+ (void)hideHUD{
    UIWindow * window=[[UIApplication sharedApplication] keyWindow];
    [HTMBProgressHUD hideHUDForView:window];
}

+ (void)showHUDWithText:(NSString *)text afterDelay:(NSTimeInterval)delay{
    UIWindow * window=[[UIApplication sharedApplication] keyWindow];
    [HTMBProgressHUD showHUDAddedTo:window withText:text afterDelay:delay];
}

+ (void)showHUDWithText:(NSString *)text afterDelay:(NSTimeInterval)delay withTarget:(id)delegate dothing:(SEL)toDo{
    UIWindow * window=[[UIApplication sharedApplication] keyWindow];
    [HTMBProgressHUD showHUDAddedTo:window withText:text afterDelay:delay withTarget:delegate dothing:toDo];
}

+ (void)showHUDWithImage:(UIImage *)image afterDelay:(NSTimeInterval)delay{
    UIWindow * window=[[UIApplication sharedApplication] keyWindow];
    [HTMBProgressHUD showHUDAddedTo:window withImage:image afterDelay:delay];
}
@end
