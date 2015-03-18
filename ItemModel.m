//
//    ItemModel.m
//    Quentin
//
//    Created by quentin on 15-03-18
//    Copyright (c) 2015年 tianjiashun. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

@synthesize userId;

- (id)initWithCoder:(NSCoder *)aDecoder
{
     if (self = [super init]) {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
     }
     return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
       [aCoder encodeObject:self.userId forKey:@"userId"];
}

@end