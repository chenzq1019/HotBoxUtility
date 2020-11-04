//
//  UIButton+CountDown.h
//
//
//  Created by zemengli on 2017/5/25.
//  Copyright © 2017年 HotBox. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PayImagePosition) {
    PayImagePositionLeft = 0, //图片在左，文字在右，默认
    PayImagePositionRight = 1, //图片在右，文字在左
    PayImagePositionTop = 2, //图片在上，文字在下
    PayImagePositionBottom = 3, //图片在下，文字在上
};
@interface UIButton (CountDown)
/**
 * button样式
 */
- (void)borderStyle;

- (void)tintColorDidChange;

/**
 * 设置图片位置
 */
- (void)setImagePosition:(PayImagePosition)postion spacing:(CGFloat)spacing;

/**
 * 倒计时
 */
- (void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;
@end
