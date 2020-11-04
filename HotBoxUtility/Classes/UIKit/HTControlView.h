//
//  HTControlView.h
//
//
//  Created by shengyang_yu on 16/7/12.
//  Copyright © 2016年 HotBox. All rights reserved.
//
//  布局图片和文字view 响应点击
//

#import <UIKit/UIKit.h>
//#import <YYWebImage/YYWebImage.h>
//#import <SDAnimatedImageView.h>
#import <SDWebImage/SDAnimatedImageView.h>

@interface HTControlView : UIView

//@property (nonatomic, strong) YYAnimatedImageView *mImageView;
@property (nonatomic, strong) SDAnimatedImageView *mImageView;
@property (nonatomic, strong) UILabel *mTitleLabel;
//@property (nonatomic, strong) YYAnimatedImageView   *mBubbleImageView;//气泡背景
@property (nonatomic, strong) SDAnimatedImageView   *mBubbleImageView;//气泡背景
@property (nonatomic, strong) UILabel   *mBubbleLabel;

/** target action */
- (void)addTouchTarget:(id)target action:(SEL)action;
/** 点击block */
@property (nonatomic, copy) void (^touchBlock)(HTControlView *view, UIGestureRecognizerState state, NSSet *touches, UIEvent *event);
/** 长按block */
@property (nonatomic, copy) void (^longPressBlock)(HTControlView *view, CGPoint point);

@end
