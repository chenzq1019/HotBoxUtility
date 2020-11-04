//
//  UM_ADDownloadManager.m
//  VideoDemo
//
//  Created by czq on 2020/4/9.
//  Copyright © 2020 HotBox. All rights reserved.
//

#import "UM_ADDownloadManager.h"
#import "UM_LaunchAdCache.h"

@interface UM_ADVideoDownload () <NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>

@property (strong, nonatomic)   NSURLSession                *session;
@property (strong, nonatomic)   NSURLSessionDownloadTask    *downloadTask;
@property (strong, nonatomic)   NSURL                       *url;

@property (nonatomic, copy ) UM_ADVideoDownloadCompletedBlock completedBlock;
@property (nonatomic, copy)  UM_ADVideoDownloadProgressBlock             progressBlock;

@end

@implementation UM_ADVideoDownload

- (instancetype)initWithUrl:(nonnull NSURL *)url delegateQueue:(nonnull NSOperationQueue *)queue progress:(nullable UM_ADVideoDownloadProgressBlock)progressBlock completed:(nullable UM_ADVideoDownloadCompletedBlock)completedBlock {
    self = [super init];
    if (self) {
        [self setupWithUrl:url delegateQueue:queue progress:progressBlock completed:completedBlock];
    }
    return self;
}

- (void)setupWithUrl:(nonnull NSURL *)url delegateQueue:(nonnull NSOperationQueue *)queue progress:(UM_ADVideoDownloadProgressBlock)progressBlock completed:(nullable UM_ADVideoDownloadCompletedBlock)completedBlock {
    self.url = url;
    self.completedBlock = completedBlock;
    self.progressBlock = progressBlock;
    NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest = 15.0;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:queue];
    self.downloadTask =  [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:url]];
    [self.downloadTask resume];
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    NSLog(@"下载开屏广告视频成功--\n源路径 \n%@",location);
    
    NSString *toPath = [UM_LaunchAdCache getVideoPathWithURL:self.url];
    NSURL *toURL = [NSURL fileURLWithPath:toPath];
    
    NSError *error=nil;
    //复制到缓存目录
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:toURL error:&error];
    if (error) {
        NSLog(@"视频复制到缓存失败--\n 缓存的路径 \n%@", toPath);
    } else {
        NSLog(@"视频复制到缓存成功--\n 缓存的路径 \n%@", toPath);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //下载任务记录处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadFinishWithURL:)]) {
            [self.delegate downloadFinishWithURL:self.url];
        }
        
        if (self.completedBlock) {
            if (!error) {
                self.completedBlock(YES, toURL, nil);
            } else {
                self.completedBlock(NO, nil, error);
            }
            // 防止重复调用
            self.completedBlock = nil;
        }
        
    });
    
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (self.progressBlock) {
        self.progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //下载任务记录处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadFinishWithURL:)]) {
            [self.delegate downloadFinishWithURL:self.url];
        }
        
        if (self.completedBlock) {
            self.completedBlock(NO, nil, error);
            // 防止重复调用
            self.completedBlock = nil;
        }
    });
}

@end

@interface UM_ADDownloadManager () <UM_ADVideoDownloadDelegate>

@property (strong, nonatomic, nonnull) NSOperationQueue *downloadVideoQueue;
@property (strong, nonatomic) NSMutableDictionary *allDownloadDict;

@end

@implementation UM_ADDownloadManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [UM_ADDownloadManager share];
}

- (id)copyWithZone:(NSZone *)zone {
    return [UM_ADDownloadManager share];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [UM_ADDownloadManager share];
}

+ (nonnull instancetype )share {
    static UM_ADDownloadManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

- (void)downloadVideoWithURL:(nonnull NSURL *)url {
    if ([UM_LaunchAdCache checkIsHaveVideoCachePathWithURL:url]) {
        return;
    }
    NSString *key = [self keyWithURL:url];
    if (self.allDownloadDict[key]) {
        return;
    }
    UM_ADVideoDownload *download = [[UM_ADVideoDownload alloc] initWithUrl:url delegateQueue:self.downloadVideoQueue progress:nil completed:nil];
    download.delegate = self;
    [self.allDownloadDict setObject:download forKey:key];
}

- (void)downloadVideoWithURL:(nonnull NSURL *)url progress:(UM_ADVideoDownloadProgressBlock)progressBlock completeBlock:(UM_ADVideoDownloadCompletedBlock)completeBlock {
    if ([UM_LaunchAdCache checkIsHaveVideoCachePathWithURL:url]) {
        completeBlock(YES, [UM_LaunchAdCache getVideoCacheURLWithURL:url], nil);
        return;
    }
    NSString *key = [self keyWithURL:url];
    if (self.allDownloadDict[key]) {
        completeBlock(NO, nil, nil);
        return;
    }
    UM_ADVideoDownload *download = [[UM_ADVideoDownload alloc] initWithUrl:url delegateQueue:self.downloadVideoQueue progress:progressBlock completed:completeBlock];
    download.delegate = self;
    [self.allDownloadDict setObject:download forKey:key];
}

- (void)downLoadVideoWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable UM_ADVideoDownloadArrayCompletedBlock)completedBlock {
    if (urlArray.count ==0) {
        completedBlock([NSArray array]);
        return;
    }
    __block NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    dispatch_group_t downLoadGroup = dispatch_group_create();
    [urlArray enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([UM_LaunchAdCache checkIsHaveVideoCachePathWithURL:url]) {
            [resultArray addObject:@{@"url":url.absoluteString,@"result":@(YES)}];
        } else {
            dispatch_group_enter(downLoadGroup);
            [self downloadVideoWithURL:url progress:^(unsigned long long current, unsigned long long total) {
                
            } completeBlock:^(BOOL success, NSURL * _Nullable location, NSError * _Nullable error) {
                dispatch_group_leave(downLoadGroup);
                [resultArray addObject:@{@"url":url.absoluteString,@"result":@(success)}];
            }];
        }
    }];
    dispatch_group_notify(downLoadGroup, dispatch_get_main_queue(), ^{
        if(completedBlock) {
            completedBlock(resultArray);
        }
    });
}

-(NSString *)keyWithURL:(NSURL *)url{
    return [UM_LaunchAdCache md5String:url.absoluteString];
}

// MARK: - UM_ADVideoDownloadDelegate
- (void)downloadFinishWithURL:(NSURL *)url{
    [self.allDownloadDict removeObjectForKey:[self keyWithURL:url]];
}

// MARK: - Getter -
- (NSMutableDictionary *)allDownloadDict {
    if (!_allDownloadDict) {
        _allDownloadDict = [[NSMutableDictionary alloc] init];
    }
    return _allDownloadDict;
}

- (NSOperationQueue *)downloadVideoQueue {
    if (!_downloadVideoQueue) {
        _downloadVideoQueue = [[NSOperationQueue alloc] init];
        _downloadVideoQueue.maxConcurrentOperationCount = 6;
        _downloadVideoQueue.name = @"com.HT.UM_ADDownloadManagerQueue";
    }
    return _downloadVideoQueue;
}

@end
