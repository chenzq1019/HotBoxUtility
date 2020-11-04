//
//  UIView+Shade.m
//  
//
//  Created by mac_chen on 2019/7/11.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UIView+Shade.h"

@implementation UIView (Shade)

//渐变
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor gradualType:(GradualType)gradualType {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds; // 创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    // 设置渐变颜色方向为水平方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    CGPoint directionPoint;
    switch (gradualType) {
        case GradualTypeVertical:
            directionPoint = CGPointMake(0, 1);
            break;
        case GradualTypeHorizontal:
            directionPoint = CGPointMake(1, 0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = directionPoint; // 设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0, @1.0];
    return gradientLayer;
}

+ (CAGradientLayer *)setGradualSizeChangingColor:(CGSize)viewSize fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor gradualType:(GradualType)gradualType{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0,0,viewSize.width,viewSize.height); // 创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    // 设置渐变颜色方向为水平方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    CGPoint directionPoint;
    switch (gradualType) {
        case GradualTypeVertical:
            directionPoint = CGPointMake(0, 1);
            break;
        case GradualTypeHorizontal:
            directionPoint = CGPointMake(1, 0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = directionPoint; // 设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0, @1.0];
    return gradientLayer;
}

+ (UIView *)setDirectionBorderWithView:(UIView *)view top:(BOOL)hasTopBorder left:(BOOL)hasLeftBorder bottom:(BOOL)hasBottomBorder right:(BOOL)hasRightBorder borderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth {
    
    float height = view.frame.size.height;
    
    float width = view.frame.size.width;
    
    CALayer *topBorder = [CALayer layer];
    
    topBorder.frame = CGRectMake(0, 0, width, borderWidth);
    
    topBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *leftBorder = [CALayer layer];
    
    leftBorder.frame = CGRectMake(0, 0, 1, height);
    
    leftBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0, height, width, borderWidth);
    
    bottomBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(width, 0, borderWidth, height);
    
    rightBorder.backgroundColor = borderColor.CGColor;
    
    if (hasTopBorder) {
        [view.layer addSublayer:topBorder];
    }
    if (hasLeftBorder) {
        [view.layer addSublayer:leftBorder];
    }
    if (hasBottomBorder) {
        [view.layer addSublayer:bottomBorder];
    }
    if (hasRightBorder) {
        [view.layer addSublayer:rightBorder];
    }
    return view;
}

+ (CAShapeLayer *)drawCornerRadiusWithRect:(CGRect)rect corners:(UIRectCorner)corners size:(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    return maskLayer;
}

@end
