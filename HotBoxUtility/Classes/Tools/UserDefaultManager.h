//
//  UserDefaulfManager.h
//  
//
//  Created by zemengli on 2018/12/6.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultManager : NSObject


/**
 *  从本地数据库获对应key值下的数据(字符串)
 */
+ (NSString *)getLocalDataString:(NSString *)aKey;

/**
 *  设置本地数据库对应key值下的数据(字符串)
 */
+ (void)setLocalDataString:(NSString *)aValue key:(NSString *)aKey;

/**
 *  从本地数据库获对应key值下的数据(bool)
 */
+ (BOOL)getLocalDataBoolen:(NSString *)aKey;

/**
 *  设置本地数据库对应key值下的数据(bool)
 */
+ (void)setLocalDataBoolen:(BOOL)bValue key:(NSString *)aKey;

/**
 *  从本地数据库获对应key值下的数据(int)
 */
+ (NSInteger)getLocalDataInt:(NSString *)aKey;

/**
 *  从本地数据库获得对应key值下的数据（CGfloat）
 */
+ (CGFloat)getLocalDataCGfloat:(NSString *)aKey;

/**
 *  设置本地数据库对应key值下的数据(CGfloat)
 */
+ (void)setLocalDataCGfloat:(CGFloat)num key:(NSString *)aKey;

/**
 *  设置本地数据库对应key值下的数据(int)
 */
+ (void)setLocalDataInt:(NSInteger)num key:(NSString *)aKey;

/**
 *  从本地数据库获对应key值下的(object)
 */
+ (id)getLocalDataObject:(NSString *)aKey;

/**
 *  设置本地数据库对应key值下的数据(字object串)
 */
+ (void)setLocalDataObject:(id)aValue key:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
