//
//  PathManager.h
//  Core
//
//  Created by tian on 15/3/17.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathManager : NSObject

//文件保存根目录
+ (NSString *)rootPath;
//根据文件名保存数据
+ (NSString *)filePathWithFileName:(NSString *)fileName;
//名称路径
+ (NSString *)pathWithFileName:(NSString *)fileName;
//文件保存目录
+ (NSString *)fileDirPath;

//文件中文件名称
+ (NSArray *)fileNames;

+ (BOOL)deleteFile:(NSString *)path;
@end
