//
//  USImageDownloadManager.h
//  
//
//  Created by xulei on 2019/1/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^USImageListDownSuccessBlock)(NSMutableArray * _Nullable resultArr);
typedef void(^USDataDownSuccessBlock)(NSData * _Nullable data);
typedef void(^USDownFailureBlock)(NSError * _Nullable error);
NS_ASSUME_NONNULL_BEGIN

@interface USImageDownloadManager : NSObject

+ (instancetype)sharedManager;

///  下载图片集（有序）
/// @param imgList 链接数组
/// @param successBlock 返回image数组
/// @param failBlock 返回NSError
- (void)downloadImageList:(NSArray *)imgList success:(USImageListDownSuccessBlock)successBlock fail:(USDownFailureBlock)failBlock;


/// 异步下载数据
/// @param urlStr 链接
/// @param successBlock 返回NSData
/// @param failBlock 返回NSError
- (void)asyncDownloadWithLink:(NSString *)urlStr success:(USDataDownSuccessBlock)successBlock fail:(USDownFailureBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
