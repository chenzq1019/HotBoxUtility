//
//  UIImage+Extension.h
//
//
//  Created by chenzhuqing on 16/8/31.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
// 调整尺寸大小,重新绘制图片
+ (UIImage*)resizedImage:(UIImage*)image withFrame:(CGRect)imgFrame;

+ (UIImage *)makeImageWithView:(UIView *)view;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (void) GetGifImages:(CFURLRef) url timeArray: (NSMutableArray *)timeArray imageArray:(NSMutableArray *)imageArray width:(CGFloat *) width height:(CGFloat *) height totalTime:(CGFloat *)totalTime;
@end
