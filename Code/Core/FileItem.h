//
//    FileItem.h
//    Quentin
//
//    Created by quentin on 15-03-17
//    Copyright (c) 2015年 tianjiashun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileItem : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *typeItems;
@property (nonatomic, strong) NSArray *parameterItems;
@property (nonatomic, strong) NSString *fileName;

- (void)updateDataFromDictionary:(NSDictionary *)dict;

@end