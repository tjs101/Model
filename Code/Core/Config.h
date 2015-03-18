//
//  Config.h
//  Core
//
//  Created by tian on 15/3/17.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#ifndef Core_Config_h
#define Core_Config_h

//Log
#if DEBUG
#define NSLog(format, ...) NSLog(@"\n文件: %@ \n方法: %s \n内容: %@ \n行数: %d",[[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"] lastObject], __FUNCTION__,[NSString stringWithFormat:format, ##__VA_ARGS__],__LINE__);
#else
#define NSLog(format,...)
#endif

extern  NSString  *const ChangeDataFinishedNotification;//改变参数

#define kVersionKey @"version"
#define kVersion @"1.0"
#define kItemKey @"item"

#endif
