//
//  PathManager.m
//  Core
//
//  Created by tian on 15/3/17.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#import "PathManager.h"

@implementation PathManager

+ (NSString *)rootPath
{
    NSString *path = [[NSBundle mainBundle] resourceURL].path;
    path = [path stringByAppendingPathComponent:@"Data"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return path;
}

+ (NSString *)fileDirPath
{
    NSString *path = [PathManager rootPath];
    
    path = [path stringByAppendingPathComponent:@"File"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return path;
}

+ (NSArray *)fileNames
{
    NSString *path = [PathManager fileDirPath];
    
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
}

+ (NSString *)filePathWithFileName:(NSString *)fileName
{
    NSString *path = [PathManager fileDirPath];
    
    fileName = [NSString stringWithFormat:@"%@_%@",fileName,[PathManager localeDate]];
    
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString *)pathWithFileName:(NSString *)fileName
{
    NSString *path = [PathManager fileDirPath];
    return [path stringByAppendingPathComponent:fileName];
}

+ (BOOL)deleteFile:(NSString *)path
{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

+ (NSDate *)localeDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

@end
