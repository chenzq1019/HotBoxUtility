//
//  UIWindow+ScreenShot.h
//
//
//  Created by chenzhuqing on 16/9/29.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (ScreenShot)

- (UIImage *)screenshot;

- (UIImage *)screenshotWithRect:(CGRect)rect;
@end
