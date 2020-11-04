//
//  UIView+Shade.h
//  
//
//  Created by mac_chen on 2019/7/11.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    GradualTypeVertical, //垂直渐变
    GradualTypeHorizontal, //水平渐变
} GradualType;

@interface UIView (Shade)

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor gradualType:(GradualType)gradualType;

+ (CAGradientLayer *)setGradualSizeChangingColor:(CGSize)viewSize fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor gradualType:(GradualType)gradualType;

//设置view指定边框样式
+ (UIView *)setDirectionBorderWithView:(UIView *)view top:(BOOL)hasTopBorder left:(BOOL)hasLeftBorder bottom:(BOOL)hasBottomBorder right:(BOOL)hasRightBorder borderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth;

//设置指定圆角
+ (CAShapeLayer *)drawCornerRadiusWithRect:(CGRect)rect corners:(UIRectCorner)corners size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
