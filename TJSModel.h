//
//    TJSModel.h
//    Quentin
//
//    Created by quentin on 15-05-13
//    Copyright (c) 2015年 tianjiashun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSModel : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *userId;

- (void)updateDataFromDictionary:(NSDictionary *)dict;

@end