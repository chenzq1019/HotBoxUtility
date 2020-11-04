//
//  UM_ADDownloadManager.h
//  VideoDemo
//
//  Created by czq on 2020/4/9.
//  Copyright © 2020 HotBox. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UM_ADVideoDownloadProgressBlock)(unsigned long long current, unsigned long long total);
typedef void(^UM_ADVideoDownloadCompletedBlock)(BOOL success, NSURL * _Nullable location, NSError * _Nullable error);
typedef void(^UM_ADVideoDownloadArrayCompletedBlock) (NSArray * _Nonnull completedArray);

@protocol UM_ADVideoDownloadDelegate <NSObject>

- (void)downloadFinishWithURL:(nonnull NSURL *)url;

@end

@interface UM_ADVideoDownload : NSObject

@property (assign, nonatomic ,nonnull)id<UM_ADVideoDownloadDelegate> delegate;

@end

@interface UM_ADDownloadManager : NSObject

+ (nonnull instancetype )share;

- (void)downloadVideoWithURL:(nonnull NSURL *)url;

- (void)downloadVideoWithURL:(nonnull NSURL *)url progress:(UM_ADVideoDownloadProgressBlock)progressBlock completeBlock:(UM_ADVideoDownloadCompletedBlock)completeBlock;

- (void)downLoadVideoWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable UM_ADVideoDownloadArrayCompletedBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
