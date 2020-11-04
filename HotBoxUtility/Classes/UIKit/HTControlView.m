//
//  HTControlView.m
//
//
//  Created by shengyang_yu on 16/7/12.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import "HTControlView.h"
//#import <YYWebImage/YYWebImage.h>
@interface HTControlView ()

@property (nonatomic, assign) CGPoint mPoint;
@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic, assign) BOOL mLongPressDetected;
@property (nonatomic, weak) id mTarget;
@property (nonatomic, assign) SEL mSEL;

@end


@implementation HTControlView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - <getter setter>

//- (YYAnimatedImageView *)mImageView {
//
//    if (!_mImageView) {
//        _mImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
//        _mImageView.backgroundColor = self.backgroundColor;
//        _mImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _mImageView.clipsToBounds = YES;
//        [self addSubview:_mImageView];
//    }
//    return _mImageView;
//}

- (SDAnimatedImageView *)mImageView {

    if (!_mImageView) {
        _mImageView = [[SDAnimatedImageView alloc] initWithFrame:CGRectZero];
        _mImageView.backgroundColor = self.backgroundColor;
        _mImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mImageView.clipsToBounds = YES;
        [self addSubview:_mImageView];
    }
    return _mImageView;
}

- (UILabel *)mTitleLabel {

    if (!_mTitleLabel) {
        _mTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _mTitleLabel.backgroundColor = self.backgroundColor;
        _mTitleLabel.textAlignment = NSTextAlignmentCenter;
        _mTitleLabel.textColor = [UIColor blackColor];
        [self addSubview:_mTitleLabel];
    }
    return _mTitleLabel;
}
//- (YYAnimatedImageView *)mBubbleImageView{
//    if (!_mBubbleImageView) {
//        _mBubbleImageView=[[YYAnimatedImageView alloc]initWithFrame:CGRectZero];
//        _mBubbleImageView.backgroundColor=self.backgroundColor;
//        [self addSubview:_mBubbleImageView];
//    }
//    return _mBubbleImageView;
//}
- (SDAnimatedImageView *)mBubbleImageView{
    if (!_mBubbleImageView) {
        _mBubbleImageView=[[SDAnimatedImageView alloc]initWithFrame:CGRectZero];
        _mBubbleImageView.backgroundColor=self.backgroundColor;
        [self addSubview:_mBubbleImageView];
    }
    return _mBubbleImageView;
}

-(UILabel *)mBubbleLabel{
    if (!_mBubbleLabel) {
        _mBubbleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        _mBubbleLabel.backgroundColor=self.backgroundColor;
        _mBubbleLabel.textAlignment=NSTextAlignmentCenter;
        _mBubbleLabel.textColor=[UIColor blackColor];
        [self.mBubbleImageView addSubview:_mBubbleLabel];
    }
    return _mBubbleLabel;
}
#pragma mark - <timer>

- (void)dealloc {
    
    [self endTimer];
}

- (void)startTimer:(NSSet<UITouch *> *)touches {

    [self.mTimer invalidate];
    self.mTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerFire:) userInfo:touches repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.mTimer forMode:NSRunLoopCommonModes];
}

- (void)endTimer {
    
    [self.mTimer invalidate];
    self.mTimer = nil;
}

- (void)timerFire:(NSSet<UITouch *> *)touches {
    
    [self touchesCancelled:touches withEvent:nil];
    self.mLongPressDetected = YES;
    if (self.longPressBlock) {
        self.longPressBlock(self, self.mPoint);
    }
    [self endTimer];
}

#pragma mark - <touch event>

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    self.mLongPressDetected = NO;
    if (self.touchBlock) {
        self.touchBlock(self, UIGestureRecognizerStateBegan, touches, event);
    }
    if (self.longPressBlock) {
        UITouch *touch = touches.anyObject;
        self.mPoint = [touch locationInView:self];
        [self startTimer:touches];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.mLongPressDetected) {
        return;
    }
    if (self.touchBlock) {
        self.touchBlock(self, UIGestureRecognizerStateChanged, touches, event);
    }
    [self endTimer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.mLongPressDetected) {
        return;
    }
    if (self.touchBlock) {
        self.touchBlock(self, UIGestureRecognizerStateEnded, touches, event);
    }
    else if (self.mTarget &&
             [self.mTarget respondsToSelector:self.mSEL]) {
        
        UITouch *touch = touches.anyObject;
        CGPoint p = [touch locationInView:self];
        if (CGRectContainsPoint(self.bounds, p)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.mTarget performSelector:self.mSEL withObject:self];
#pragma clang diagnostic pop
        }
    }
    [self endTimer];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.mLongPressDetected) {
        return;
    }
    if (self.touchBlock) {
        self.touchBlock(self, UIGestureRecognizerStateCancelled, touches, event);
    }
    [self endTimer];
}

- (void)addTouchTarget:(id)target action:(SEL)action {

    self.mTarget = target;
    self.mSEL = action;
}

@end
