//
//  UserDefaulfManager.m
//  
//
//  Created by zemengli on 2018/12/6.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

+ (NSString *)getLocalDataString:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || nil == aKey) {
        return nil;
    }
    
    NSString *strRet = [defaults objectForKey:aKey];
    
    return strRet;
}

+ (void)setLocalDataString:(NSString *)aValue key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || nil == aKey) {
        return;
    }
    
    [defaults setObject:aValue forKey:aKey];
    [defaults synchronize];
}

+ (BOOL)getLocalDataBoolen:(NSString *)aKey {
    BOOL bRet = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey) {
        bRet = NO;
    } else {
        bRet = [defaults boolForKey:aKey];
    }
    
    return bRet;
}

+ (void)setLocalDataBoolen:(BOOL)bValue key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey) {
        return;
    }
    
    [defaults setBool:bValue forKey:aKey];
    [defaults synchronize];
}

+ (NSInteger)getLocalDataInt:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || aKey == nil) {
        return 0;
        
    } else {
        return [defaults integerForKey:aKey];
    }
}

+ (CGFloat)getLocalDataCGfloat:(NSString *)aKey {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || aKey == nil) {
        return 0;
        
    } else {
        return [defaults floatForKey:aKey];
    }
}

+ (void)setLocalDataCGfloat:(CGFloat)num key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || aKey == nil) {
        return ;
    }
    [defaults setFloat:num forKey:aKey];
    [defaults synchronize];
    
}

+ (void)setLocalDataInt:(NSInteger)num key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || aKey == nil) {
        return;
    }
    [defaults setInteger:num forKey:aKey];
    [defaults synchronize];
}

+ (id)getLocalDataObject:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey) {
        return nil;
    }
    
    id strRet = [defaults objectForKey:aKey];
    
    return strRet;
}

+ (void)setLocalDataObject:(id)aValue key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey) {
        return;
    }
    
    [defaults setObject:aValue forKey:aKey];
    [defaults synchronize];
}

@end
