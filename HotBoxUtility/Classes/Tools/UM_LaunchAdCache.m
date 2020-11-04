//
//  UM_LaunchAdCache.m
//  VideoDemo
//
//  Created by czq on 2020/4/9.
//  Copyright © 2020 HotBox. All rights reserved.
//

#import "UM_LaunchAdCache.h"
#import <CommonCrypto/CommonDigest.h>

#define UMISVideoTypeWithPath(path)\
({\
BOOL result = NO;\
if([path hasSuffix:@".mp4"])  result =  YES;\
(result);\
})


@implementation UM_LaunchAdCache

// MARK: - Clear
+(void)clearDiskCache {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [UM_LaunchAdCache getLaunchAdCachePath];
        [fileManager removeItemAtPath:path error:nil];
        [UM_LaunchAdCache checkDirectory:[UM_LaunchAdCache getLaunchAdCachePath]];
    });
}

+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray{
    if(videoUrlArray.count==0) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [videoUrlArray enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([UM_LaunchAdCache checkIsHaveVideoCachePathWithURL:obj]){
                [[NSFileManager defaultManager] removeItemAtPath:[UM_LaunchAdCache getVideoPathWithURL:obj] error:nil];
            }
        }];
    });
}

+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *allFilePaths = [UM_LaunchAdCache allFilePathWithDirectoryPath:[UM_LaunchAdCache getLaunchAdCachePath]];
        NSArray *exceptVideoPaths = [UM_LaunchAdCache filePathsWithFileUrlArray:exceptVideoUrlArray];
        [allFilePaths enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![exceptVideoPaths containsObject:obj] && UMISVideoTypeWithPath(obj)){
                [[NSFileManager defaultManager] removeItemAtPath:obj error:nil];
            }
        }];
    });
}

// MARK: - Check
+ (BOOL)checkIsHaveVideoCachePathWithURL:(NSURL *)url {
    NSString *savePath = [UM_LaunchAdCache getVideoPathWithURL:url];
    //如果存在
    if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
        return YES;
    }
    return NO;
}

// MARK: - Getter -
+ (NSString *)getVideoPathWithURL:(NSURL *)url {
    if (url==nil) {
        return @"";
    }
    NSString *savePath = [[UM_LaunchAdCache getLaunchAdCachePath] stringByAppendingPathComponent:[UM_LaunchAdCache getVideoNameWithURL:url]];
    return savePath;
}

+ (nullable NSURL *)getVideoCacheURLWithURL:(NSURL *)url {
    NSString *savePath = [[UM_LaunchAdCache getLaunchAdCachePath] stringByAppendingPathComponent:[UM_LaunchAdCache getVideoNameWithURL:url]];
    //如果存在
    if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
        return [NSURL fileURLWithPath:savePath];
    }
    return nil;
}

+ (NSString *)getLaunchAdCachePath{
    NSString *path =[NSHomeDirectory() stringByAppendingPathComponent:@"Library/UM_LaunchAdCache"];
    [UM_LaunchAdCache checkDirectory:path];
    return path;
}

+ (NSString *)getVideoNameWithURL:(NSURL *)url{
     return [[UM_LaunchAdCache md5String:url.absoluteString] stringByAppendingString:@".mp4"];
}

+(NSArray*)allFilePathWithDirectoryPath:(NSString*)directoryPath{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* tempArray = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [directoryPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

+(NSArray *)filePathsWithFileUrlArray:(NSArray <NSURL *> *)fileUrlArray {
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    [fileUrlArray enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path;
        path = [self getVideoPathWithURL:obj];
        [filePaths addObject:path];
    }];
    return filePaths;
}

// MARK: - Add 添加
+ (void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [UM_LaunchAdCache createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [UM_LaunchAdCache createBaseDirectoryAtPath:path];
        }
    }
}

+ (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        
    } else {
        [UM_LaunchAdCache addDoNotBackupAttribute:path];
    }
}

+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        
    }
}

// MARK: - Change
+ (NSString *)md5String:(NSString *)string {
    if (string == nil || string.length ==0) {
        return @"";
    }
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

@end
