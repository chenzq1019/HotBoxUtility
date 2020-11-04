//
//  MBProgressHUD+Extension.h
//  
//
//  Created by chenzhuqing on 16/4/19.
//  Copyright © 2016年 HotBox. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>


@protocol MBProgressHUDDelegate1<MBProgressHUDDelegate>

-(void)HUDdelayDo;

@end

@interface MBProgressHUD (Extension)

@property (nonatomic,weak) id<MBProgressHUDDelegate1> delegate1;

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay dothing:(BOOL)b;

@end
