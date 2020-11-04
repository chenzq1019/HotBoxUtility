//
//  FileController.m
//  Hotel
//
//  Created by danal on 5/12/11.
//  Copyright 2011 danal. All rights reserved.
//

 
#import "FileController.h"


@implementation FileController

//获得document
+(NSString *)documentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

//读取工程文件
+(NSString *) ProductPath:(NSString*)filename{

    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@""];
    return  path;
}

//获得document文件路径，名字方便记忆
+(NSString *) DocumentPath:(NSString *)filename {
	NSString *documentsPath = [self documentsPath];
    // NSLog(@"documentsPath=%@",documentsPath);
	return [documentsPath stringByAppendingPathComponent:filename];
}

//获得document文件路径
+(NSString *)fullpathOfFilename:(NSString *)filename {
	NSString *documentsPath = [self documentsPath];
   // NSLog(@"documentsPath=%@",documentsPath);
	return [documentsPath stringByAppendingPathComponent:filename];
}

//写入文件沙盒位置NSDictionary
+(void)saveNSDictionaryForDocument:(NSDictionary *)list  FileUrl:(NSString*) FileUrl  {
	
    NSString *f = [self fullpathOfFilename:FileUrl];
    
	[list writeToFile:f atomically:YES];
}

//写入文件存放到工程位置NSDictionary
+(void)saveNSDictionaryForProduct:(NSDictionary *)list  FileUrl:(NSString*) FileUrl  {
	
    NSString *ProductPath =[[NSBundle mainBundle]  resourcePath];
    NSString *f=[ProductPath stringByAppendingPathComponent:FileUrl];
    
	[list writeToFile:f atomically:YES];
}

//写入文件 Array 工程
+(void)saveOrderArrayListProduct:(NSMutableArray *)list  FileUrl :(NSString*) FileUrl {

    NSString *ProductPath =[[NSBundle mainBundle]  resourcePath];
    NSString *f=[ProductPath stringByAppendingPathComponent:FileUrl];
    
	[list writeToFile:f atomically:YES];
}
//写入文件 Array 沙盒
+(void)saveOrderArrayList:(NSMutableArray *)list  FileUrl :(NSString*) FileUrl {
	NSString *f = [self fullpathOfFilename:FileUrl];
    
	[list writeToFile:f atomically:YES];
}

//写入文件 Array 沙盒 序列化内容
+ (void)saveArrayClassList:(NSMutableArray*)array forKey:(NSString*)key withFileName:(NSString*)fName withSort:(BOOL)isSort
{
    //排序字典
    if (isSort) {
        [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger num1 = [obj1[@"priority"] integerValue];
            NSInteger num2 = [obj2[@"priority"] integerValue];
            if (num1 < num2) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
    }
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    @try {
        if (documentDirectory)
        {
            NSString *fileName = [documentDirectory stringByAppendingPathComponent:fName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
            {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
                // NSData *encodedCurBirdSightingList = [NSKeyedArchiver archivedDataWithRootObject:array];
                [saveDic setObject:array forKey:key];
                BOOL iResult = [saveDic writeToFile:fileName atomically:NO];
                if (iResult) {
                    NSLog(@"______________");
                }
            }
            else
            {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] init];
                [saveDic setObject:array forKey:key];
                [saveDic writeToFile:fileName atomically:NO];
               
            }
        }
    }
    @catch (NSException* e) {
    }
}

/** 
 写入文件 Array 沙盒 序列化内容
 根据多字段排序存储
 20160823
 yushengyang
 */
+ (void)saveMorePriorityArrayClassList:(NSMutableArray*)array forKey:(NSString*)key withFileName:(NSString*)fName withSort:(BOOL)isSort
{
    //排序字典
    if (isSort) {
        // groupid
        NSSortDescriptor *groupidSort = [NSSortDescriptor sortDescriptorWithKey:@"groupid" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSInteger num1 = [obj1 integerValue];
            NSInteger num2 = [obj2 integerValue];
            if (num1 < num2) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        // groupsort
        NSSortDescriptor *groupsortSort = [NSSortDescriptor sortDescriptorWithKey:@"groupsort" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSInteger num1 = [obj1 integerValue];
            NSInteger num2 = [obj2 integerValue];
            if (num1 < num2) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        [array sortedArrayUsingDescriptors:@[groupidSort,groupsortSort]];
    }
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    @try {
        if (documentDirectory)
        {
            NSString *fileName = [documentDirectory stringByAppendingPathComponent:fName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
            {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
                //NSData *encodedCurBirdSightingList = [NSKeyedArchiver archivedDataWithRootObject:array];
                [saveDic setObject:array forKey:key];
                BOOL iResult = [saveDic writeToFile:fileName atomically:NO];
                if (iResult) {
                    NSLog(@"______________");
                }
            }
            else
            {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] init];
                [saveDic setObject:array forKey:key];
                [saveDic writeToFile:fileName atomically:NO];
                
            }
        }
    }
    @catch (NSException* e) {
    }
}



//读取文件 沙盒 序列化内容
+ (id)readClassFile:(NSString*)key withFileName:(NSString*)fName
{
    id result = nil;
    @try {
       	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [path objectAtIndex:0];
        
        if (documentDirectory)
        {
            NSString *fileName = [documentDirectory stringByAppendingPathComponent:fName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
            {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
                //NSData *savedEncodedData = [saveDic objectForKey:key];
                //result = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
                result = (NSMutableArray *)[saveDic objectForKey:key];
                return result;
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        return result;
    }
}


//加载文件沙盒NSDictionary
+(NSDictionary *)loadNSDictionaryForDocument  : (NSString*) FileUrl {

	NSString *f = [self fullpathOfFilename:FileUrl];
	NSDictionary *list = [ [NSDictionary alloc] initWithContentsOfFile:f];
	 
	return list;
}

//加载文件工程位置NSDictionary
+(NSDictionary *)loadNSDictionaryForProduct   : (NSString*) FileUrl {
   
	NSString *f = [self ProductPath:FileUrl];
    NSDictionary *list =[NSDictionary dictionaryWithContentsOfFile:f];
    
	return list;
}


//加载文件沙盒NSArray
+(NSArray *)loadArrayList   : (NSString*) FileUrl {
    
	NSString *f = [self fullpathOfFilename:FileUrl];
    
	NSArray *list = [NSArray  arrayWithContentsOfFile:f];
    
	return list;
}

//加载文件工程位置NSArray
+(NSArray *)loadArrayListProduct   : (NSString*) FileUrl {
    
	NSString *f = [self ProductPath:FileUrl];
    
    NSArray *list = [NSArray  arrayWithContentsOfFile:f];
    
	return list;
}

//拷贝文件到沙盒
+(int) CopyFileToDocument:(NSString*)FileName{
    

    NSString *appFileName =[self fullpathOfFilename:FileName];

    
    NSFileManager *fm = [NSFileManager defaultManager];  
    
    //判断沙盒下是否存在 
    BOOL isExist = [fm fileExistsAtPath:appFileName];  
    
    if (!isExist)   //不存在，把工程的文件复制document目录下
    {  
        
        //获取工程中文件
        NSString *backupDbPath = [[NSBundle mainBundle]  
                                  pathForResource:FileName  
                                  ofType:@""];  
    
        
        //这一步实现数据库的添加，  
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径复制到应用程序的路径上  
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:appFileName error:nil];  
      
    
        return cp;
        
    } else {
        
        return  -1; //已经存在
    } 
    
}

//添加文件到沙盒 已存在覆盖 20150206
+(NSInteger) AddFileToDocument:(NSString*)FileName
{
    NSString *appFileName =[self fullpathOfFilename:FileName];
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //判断沙盒下是否存在
    BOOL isExist = [fm fileExistsAtPath:appFileName];
    
    if (!isExist)   //不存在，把工程的文件复制document目录下
    {
        //获取工程中文件
        NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:FileName
                                  ofType:@""];
        //这一步实现数据库的添加，
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径复制到应用程序的路径上
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:appFileName error:nil];
        
        return cp;
        
    } else {
        //获取工程中文件
        NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:FileName
                                  ofType:@""];
        BOOL move = [fm removeItemAtPath:appFileName error:nil];
        if (move) {
            BOOL cp=[fm copyItemAtPath:backupDbPath toPath:appFileName error:nil];
            return cp;
        }
        return  -1; //失败
    }
}

//判断文件是否存在
+(BOOL) FileIsExists:(NSString*) checkFile{
     
    if([[NSFileManager defaultManager]fileExistsAtPath:checkFile])
    {
        return true;
    }
    return  false;

}
//
//+(NSString*) backPath:(FileMode) sourceMode  path:(NSString*)path{
//    
//    NSString *filepath=@"";
//    if (sourceMode==FileModeProduct) {
//        
//        filepath = [[NSBundle mainBundle] pathForResource:path ofType:nil];
//    }
//    else{
//        
//        filepath = [FileController DocumentPath:path];
//    }
//    
//    return filepath;
//}

- (void)dealloc {
//    [super dealloc];
}



+(BOOL) createDirectory:(NSString*) path   isDir:(BOOL)isDir{
    
    NSFileManager *filesManager = [NSFileManager defaultManager];
    BOOL existed = [filesManager fileExistsAtPath:path isDirectory:&isDir];
    
    if (!existed )//不存在该目录,则创建目录
    {
      return    [filesManager createDirectoryAtPath:path
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    
    return true;
}


// 从一个资源文件中读取一个NSData数据
+ (NSData *)dataFromResource:(NSString *)resourceName withExtension:(NSString *)ext {
    if (nil == resourceName) {
        return nil;
    }
    
    NSURL *path = [[NSBundle mainBundle] URLForResource:resourceName withExtension:ext];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:[path path]] || ![manager isReadableFileAtPath:[path path]]) {
        return nil;
    }
    
    return [NSData dataWithContentsOfURL:path];
}

+ (void)saveCacheData:(id)data withKey:(NSString *)keyname{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //归档
        NSMutableData *dt = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dt];
        [archiver encodeObject:data forKey:keyname];
        [archiver finishEncoding];
        //写入文件
        NSString * fileName=[NSString stringWithFormat:@"%@.archiver",keyname];
        NSString *filePath = [FileController DocumentPath:fileName];
        [dt writeToFile:filePath atomically:YES];
    });
}

+ (id)getCacheDataWithKey:(NSString *)keyname{
    
    NSString * fileName=[NSString stringWithFormat:@"%@.archiver",keyname];
    NSString *filePath1 =[FileController DocumentPath:fileName];
    NSData *data1 = [[NSMutableData alloc] initWithContentsOfFile:filePath1];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
    //获得类
    id data= [unarchiver decodeObjectForKey:keyname];
    [unarchiver finishDecoding];
    return data;
}

+ (BOOL)saveInToFile:(NSString *)key withvalue:(id)value withFileName:(NSString *)saveFileName
{
    NSArray *   path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *  documentDirectory = [path objectAtIndex:0];
    @try {
        if (documentDirectory)
        {
            NSString *fileName = [documentDirectory stringByAppendingPathComponent:saveFileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
            {
                NSMutableDictionary *   saveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
                [saveDic setValue:value forKey:key];
                
                [saveDic writeToFile:fileName atomically:NO];
            }
            else
            {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] init];
                [saveDic setObject:value forKey:key];
                [saveDic writeToFile:fileName atomically:NO];
            }
            return YES;
        }
        return NO;
    }
    @catch (NSException * e) {
        return NO;
    }
}

+ (id)readFileWithKey:(NSString*)key withFileName:(NSString *)saveFileName
{
    id result = nil;
    @try {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [path objectAtIndex:0];
        
        if (documentDirectory)
        {
            NSString *fileName = [documentDirectory stringByAppendingPathComponent:saveFileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
            {
                NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
                NSData *savedEncodedData = [saveDic objectForKey:key];
                result = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
                
                return result;
            }
            else{
                if([saveFileName rangeOfString:@"."].location !=NSNotFound)
                {
                    NSArray *array = [saveFileName componentsSeparatedByString:@"."];
                    
                    NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]]];
                    NSData *savedEncodedData = [saveDic objectForKey:key];
                    result = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
                    
                    return result;
                }
            }
        }
        
    }
    @catch (NSException *exception) {
    }
    @finally {
        return result;
    }
}

+ (void)writeInToFileDataArray:(NSMutableArray*)array forKey:(NSString*)key withFileName:(NSString *)saveFileName
{
    NSArray *   path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *  documentDirectory = [path objectAtIndex:0];
    @try {
        if (documentDirectory)
        {
            NSString *  fileName = [documentDirectory stringByAppendingPathComponent:saveFileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
            {
                NSMutableDictionary *   saveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
                
                
                
                NSData *encodedCurBirdSightingList = [NSKeyedArchiver archivedDataWithRootObject:array];
                
                [saveDic setObject:encodedCurBirdSightingList forKey:key];
                
                BOOL iResult = [saveDic writeToFile:fileName atomically:NO];
                if (iResult) {
                    NSLog(@"______________");
                }
            }
            else
            {
                NSMutableDictionary *   saveDic = [[NSMutableDictionary alloc] init];
                [saveDic setObject:array forKey:key];
                [saveDic writeToFile:fileName atomically:NO];
            }
        }
    }
    @catch (NSException* e) {
        
    }
}

+(BOOL)deleteFile:(NSString *)fileUrl{
    NSString *f = [self fullpathOfFilename:fileUrl];
    BOOL isHave = [[NSFileManager defaultManager] fileExistsAtPath:f];
    if (!isHave) {
        return YES;
    }else{
        BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:f error:nil];
        return isDelete;
    }
}
@end
