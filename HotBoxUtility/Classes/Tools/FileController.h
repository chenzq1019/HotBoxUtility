//
//  FileController.h
//  Hotel
//
//  Created by danal on 5/12/11.
//  Copyright 2011 danal. All rights reserved.
//

 


#import <UIKit/UIKit.h>



@interface FileController : NSObject {

}



+(NSString *)documentsPath;

+(NSString *)fullpathOfFilename:(NSString *)filename;

//读取工程文件
+(NSString *) ProductPath:(NSString*)filename;
 
 
//获得document文件路径，名字方便记忆
+(NSString *) DocumentPath:(NSString *)filename;

 

//写入文件 Array 沙盒
+(void)saveOrderArrayList:(NSMutableArray *)list  FileUrl :(NSString*) FileUrl;

//写入文件 Array 沙盒 序列化内容
+ (void)saveArrayClassList:(NSMutableArray*)array forKey:(NSString*)key withFileName:(NSString*)fName withSort:(BOOL)isSort;
/**
 写入文件 Array 沙盒 序列化内容
 根据多字段排序存储
 20160823
 yushengyang
 */
+ (void)saveMorePriorityArrayClassList:(NSMutableArray*)array forKey:(NSString*)key withFileName:(NSString*)fName withSort:(BOOL)isSort;

//读取文件 沙盒 序列化内容
+ (id)readClassFile:(NSString*)key withFileName:(NSString*)fName;

//写入文件 Array 工程
+(void)saveOrderArrayListProduct:(NSMutableArray *)list  FileUrl :(NSString*) FileUrl;

 
//写入文件存放到工程位置NSDictionary
+(void)saveNSDictionaryForProduct:(NSDictionary *)list  FileUrl:(NSString*) FileUrl;
//写入文件沙盒位置NSDictionary
+(void)saveNSDictionaryForDocument:(NSDictionary *)list  FileUrl:(NSString*) FileUrl;


//加载文件沙盒NSDictionary
+(NSDictionary *)loadNSDictionaryForDocument  : (NSString*) FileUrl;

//加载文件工程位置NSDictionary
+(NSDictionary *)loadNSDictionaryForProduct   : (NSString*) FileUrl;

//加载文件沙盒NSArray
+(NSArray *)loadArrayList   : (NSString*) FileUrl;

//加载文件工程位置NSArray
+(NSArray *)loadArrayListProduct   : (NSString*) FileUrl;

//判断文件是否存在
+(BOOL) FileIsExists:(NSString*) checkFile;

//拷贝文件到沙盒
+(int) CopyFileToDocument:(NSString*)FileName;

//添加文件到沙盒 已存在 覆盖20150206
+(NSInteger) AddFileToDocument:(NSString*)FileName;

//+(NSString*) backPath:(FileMode) sourceMode  path:(NSString*)path;

+(BOOL) createDirectory:(NSString*) path   isDir:(BOOL)isDir;

// 从一个资源文件中读取一个NSData数据
+ (NSData *)dataFromResource:(NSString *)resourceName withExtension:(NSString *)ext;
//保存缓存数据
+ (void)saveCacheData:(id)data withKey:(NSString *)keyname;
//读取缓存数据
+ (id)getCacheDataWithKey:(NSString *)keyname;

+ (BOOL)saveInToFile:(NSString *)key withvalue:(id)value withFileName:(NSString *)saveFileName;

+ (id)readFileWithKey:(NSString*)key withFileName:(NSString *)saveFileName;

+ (void)writeInToFileDataArray:(NSMutableArray*)array forKey:(NSString*)key withFileName:(NSString *)saveFileName;

+ (BOOL)deleteFile:(NSString *)fileUrl;
@end
