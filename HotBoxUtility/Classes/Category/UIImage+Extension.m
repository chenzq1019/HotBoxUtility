//
//  UIImage+Extension.m
//
//
//  Created by chenzhuqing on 16/8/31.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

// 调整尺寸大小,重新绘制图片
+ (UIImage*)resizedImage:(UIImage*)image withFrame:(CGRect)imgFrame {
    
    UIGraphicsBeginImageContext(imgFrame.size);
    [image drawInRect:imgFrame];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

//view创建image
+ (UIImage *)makeImageWithView:(UIView *)view{
    
    CGSize s = view.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
