//
//  HTDispatchProxy.h
//  MBProgressHUD
//
//  Created by 陈竹青 on 2020/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define DispatchForProtocol(__protocol__, ...) ((DispatchProxy <__protocol__> *)[DispatchProxy dispatchForProtocol:@protocol(__protocol__) withObjects:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])])

@interface HTDispatchProxy : NSProxy

@property (nonatomic, strong, readonly) Protocol * protocol;
@property (nonatomic, strong, readonly) NSArray * attachedObjects;

+ (instancetype)dispatchForProtocol:(Protocol*)protocol withObjects:(NSArray*)objects;
@end

NS_ASSUME_NONNULL_END
