//
//  USImageDownloadManager.m
//  
//
//  Created by xulei on 2019/1/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USImageDownloadManager.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "NSString+Utility.h"

@interface USImageDownloadManager ()

@end

@implementation USImageDownloadManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)downloadImageList:(NSArray *)imgList success:(nonnull USImageListDownSuccessBlock)successBlock fail:(nonnull USDownFailureBlock)failBlock
{
    if (!imgList||imgList.count<=0) {
        return;
    }
    USImageListDownSuccessBlock mSucBlock = [successBlock copy];
    USDownFailureBlock mFailBlock = [failBlock copy];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    manager.config.downloadTimeout = 20;
    __block NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    __block NSMutableArray *resultArr = [NSMutableArray array];
    dispatch_group_t downloadGroup=dispatch_group_create();
    dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
    dispatch_apply(imgList.count, queue, ^(size_t index) {
        dispatch_group_enter(downloadGroup);
        [manager downloadImageWithURL:[NSURL URLWithString:imgList[index]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            dispatch_group_leave(downloadGroup);
            if (finished&&image&&!error) {
                [resultDic setObject:image forKey:@(index)];
            }
        }];
    });
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
//        全部下载成功
        if (resultDic.allKeys.count==imgList.count) {
            for (int i=0; i<imgList.count; i++) {
                [resultArr addObject:[resultDic objectForKey:@(i)]];
            }
            if (mSucBlock) {
                mSucBlock(resultArr);
            }
        }else {
            if (mFailBlock) {
                mFailBlock(nil);
            }
        }
    });
}

- (void)asyncDownloadWithLink:(NSString *)urlStr success:(USDataDownSuccessBlock)successBlock fail:(USDownFailureBlock)failBlock{
    USDataDownSuccessBlock mSucBlock=[successBlock copy];
    USDownFailureBlock mFailBlock=[failBlock copy];
    if ([NSString isNullToString:urlStr].length==0) {
        if (mFailBlock) {
            mFailBlock(nil);
        }
    }
    NSURLSessionDownloadTask *task=[[NSURLSession sharedSession]downloadTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // location 是沙盒中 tmp 文件夹下的一个临时 url，文件下载后会存到这个位置，由于 tmp 中的文件随时可能被删除，所以我们需要自己需要把下载的文件挪到 Caches 文件夹中
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
            // 剪切文件
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
            //切记当前为子线程，
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData *data=[NSData dataWithContentsOfFile:path];
                if (mSucBlock) {
                    mSucBlock(data);
                }
            });
        }else{
            if (mFailBlock) {
                mFailBlock(error);
            }
        }
    }];
    [task resume];
}

@end
