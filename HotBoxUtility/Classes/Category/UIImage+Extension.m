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

//获取GIF的images以及总的播放时间
+ (void) GetGifImages:(CFURLRef) url timeArray: (NSMutableArray *)timeArray imageArray:(NSMutableArray *)imageArray width:(CGFloat *) width height:(CGFloat *) height totalTime:(CGFloat *)totalTime{
    NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:@{@0:(NSString *)kCGImagePropertyGIFLoopCount} forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //拿到ImageSourceRef后获取gif内部图片个数
    CGImageSourceRef ref = CGImageSourceCreateWithURL(url, (CFDictionaryRef)gifProperty);
    size_t count = CGImageSourceGetCount(ref);
    for (int i = 0; i < count; i++) {
        //添加图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(ref, i, (CFDictionaryRef)gifProperty);
        [imageArray addObject:CFBridgingRelease(imageRef)];
        //取每张图片的图片属性,是一个字典
        NSDictionary *dict = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(ref, i, (CFDictionaryRef)gifProperty));
        //取宽高
        if (width != NULL && height != NULL) {
            *width = [[dict valueForKey:(NSString *)kCGImagePropertyPixelWidth] floatValue];
            *height = [[dict valueForKey:(NSString *)kCGImagePropertyPixelHeight] floatValue];
        }
        //添加每一帧时间
        NSDictionary *tmp = [dict valueForKey:(NSString *)kCGImagePropertyGIFDictionary];
        [timeArray addObject:[tmp valueForKey:(NSString *)kCGImagePropertyGIFDelayTime]];
        //总时间
        *totalTime = *totalTime + [[tmp valueForKey:(NSString *)kCGImagePropertyGIFDelayTime] floatValue];
    }
}
@end
