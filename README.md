# Model
编辑model类工具 只能在mac上使用

类似如下所示:
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


//
//    FileItem.m
//    Quentin
//
//    Created by quentin on 15-03-17
//    Copyright (c) 2015年 tianjiashun. All rights reserved.
//

#import "FileItem.h"

@implementation FileItem

@synthesize typeItems;
@synthesize parameterItems;
@synthesize fileName;

- (id)initWithCoder:(NSCoder *)aDecoder
{
     if (self = [super init]) {
        self.typeItems = [aDecoder decodeObjectForKey:@"typeItems"];
        self.parameterItems = [aDecoder decodeObjectForKey:@"parameterItems"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
     }
     return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
       [aCoder encodeObject:self.typeItems forKey:@"typeItems"];
       [aCoder encodeObject:self.parameterItems forKey:@"parameterItems"];
       [aCoder encodeObject:self.fileName forKey:@"fileName"];
}

- (void)updateDataFromDictionary:(NSDictionary *)dict
{
     id value = [dict objectForKey:@"typeItems"];
     if ([value isKindOfClass:[NSString class]]) {
         self.typeItems = value;
      }

     value = [dict objectForKey:@"parameterItems"];
     if ([value isKindOfClass:[NSString class]]) {
         self.parameterItems = value;
      }

     value = [dict objectForKey:@"fileName"];
     if ([value isKindOfClass:[NSString class]]) {
         self.fileName = value;
      }
}

@end
