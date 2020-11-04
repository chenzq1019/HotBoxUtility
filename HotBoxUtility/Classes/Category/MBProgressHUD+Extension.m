//
//  MBProgressHUD+Extension.m
//
//
//  Created by chenzhuqing on 16/4/19.
//  Copyright © 2016年 hotBox. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import <objc/runtime.h>
static const void *BandNameKey = &BandNameKey;


@implementation MBProgressHUD (Extension)
@dynamic delegate1;

- (id<MBProgressHUDDelegate1>)delegate1 {
    return objc_getAssociatedObject(self, BandNameKey);
}
- (void)setDelegate1:(id<MBProgressHUDDelegate1>)delegate1{
    objc_setAssociatedObject(self, BandNameKey, delegate1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay dothing:(BOOL)b{
    [self performSelector:@selector(dohideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)dohideDelayed:(NSNumber *)animated {
    [self hideAnimated:[animated boolValue]];
    if ([self.delegate1 respondsToSelector:@selector(HUDdelayDo)]) {
        [self.delegate1 HUDdelayDo];
    }
}
@end
