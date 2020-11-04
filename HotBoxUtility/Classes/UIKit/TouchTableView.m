//
//  TouchTableView.m
//
//
//  Created by xiexin on 13-11-6.
//  Copyright (c) 2013年 HotBox. All rights reserved.
//

#import "TouchTableView.h"
@interface TouchTableView ()

@property (nonatomic, assign) CGRect   keyboardRect;
@property (nonatomic, assign) UIEdgeInsets priorInset;
@property (nonatomic, assign) BOOL priorInsetSaved;
@property (nonatomic, assign) BOOL      keyboardVisible;
@end
@implementation TouchTableView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
    {
        [_touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)])
    {
        [_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self findFristRespondsView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)])
    {
        [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)])
    {
        [_touchDelegate tableView:self touchesMoved:touches withEvent:event];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _priorInsetSaved = NO;
        [self addNotification];
    }
    return self;
}

-(void) addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma notificaton

-(void) keyboardWillShow:(NSNotification *)notification{
    //TODO:
    _keyboardRect=[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardVisible=YES;
    NSLog(@"_keyboarRectOrin==%@",NSStringFromCGRect(_keyboardRect));
    //调整scrollerView 的OffsetY值。
    if (!_priorInsetSaved) {
        _priorInset = self.contentInset;
        _priorInsetSaved = YES;
    }
    UIView *firstResponder = [self findFristRespondsView:self];
    if ( !firstResponder ) {
        // No child view is the first responder - nothing to do here
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.contentInset = [self contentInsetForKeyboard];
    [self setContentOffset:CGPointMake(self.contentOffset.x,
                                       [self idealOffsetForView:firstResponder withSpace:[self keyboardRect].origin.y - self.bounds.origin.y])
                  animated:YES];
    
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification *) notifcation{
    //TODO:
    _keyboardRect = CGRectZero;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notifcation userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notifcation userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    self.contentInset = _priorInset;
    _priorInsetSaved = NO;
    [UIView commitAnimations];
    _keyboardVisible=NO;
}

-(CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space {
    
    // Convert the rect to get the view's distance from the top of the scrollView.
    CGRect rect = [view convertRect:view.bounds toView:self];
    
    // Set starting offset to that point
    CGFloat offset = rect.origin.y;
    
    //距离键盘顶部的距离
    CGFloat gap=space-80;//space/2.0;
    if((rect.origin.y)<gap){
        offset=0;
    }else{
        offset=rect.origin.y-gap;
    }
    return offset;
    
}

- (void)adjustOffsetToIdealIfNeeded{
    //键盘已经出现的情况
    if (_keyboardVisible) {
        [self setContentOffset:CGPointMake(self.contentOffset.x,
                                           [self idealOffsetForView:[self findFristRespondsView:self] withSpace:[self keyboardRect].origin.y - self.bounds.origin.y])
                      animated:YES];
    }
    
    
}

- (UIEdgeInsets)contentInsetForKeyboard {
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = [self keyboardRect];
    newInset.bottom = keyboardRect.size.height - ((keyboardRect.origin.y+keyboardRect.size.height) - (self.bounds.origin.y+self.bounds.size.height));
    return newInset;
}

- (CGRect)keyboardRect {
    //将键盘坐标转换到self中，
    CGRect keyboardRect = [self convertRect:_keyboardRect fromView:nil];
    if ( keyboardRect.origin.y == 0 ) {
        CGRect screenBounds = [self convertRect:[UIScreen mainScreen].bounds fromView:nil];
        keyboardRect.origin = CGPointMake(0, screenBounds.size.height - keyboardRect.size.height);
    }
    return keyboardRect;
}

#pragma mark- 查找焦点视图

-(UIView *) findFristRespondsView:(UIView *) view{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFristRespondsView:childView];
        if ( result ) return result;
    }
    return nil;
}

@end

