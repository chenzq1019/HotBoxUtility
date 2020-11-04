//
//  UM_LaunchAdCache.h
//  VideoDemo
//
//  Created by czq on 2020/4/9.
//  Copyright © 2020 HotBox. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UM_LaunchAdCache : NSObject

// MARK: - Check
+ (BOOL)checkIsHaveVideoCachePathWithURL:(NSURL *)url;


// MARK: - Getter -
+ (nullable NSURL *)getVideoCacheURLWithURL:(NSURL *)url;

+ (NSString *)getVideoPathWithURL:(NSURL *)url;


// MARK: - Clear
+(void)clearDiskCache;

+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray;

+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray;

// MARK: - Change
+ (NSString *)md5String:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
