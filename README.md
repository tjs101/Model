# Model
#编辑model类工具 只能在mac上使用

[@田家顺](https://github.com/tjs101)

###类似如下所示:

######//
######//    TJSModel.h
######//    Quentin
######//
######//    Created by quentin on 15-05-13
######//    Copyright (c) 2015年 tianjiashun. All rights reserved.
######//

import <Foundation/Foundation.h>

@interface TJSModel : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *userId;

- (void)updateDataFromDictionary:(NSDictionary *)dict;

@end


######//
######//    TJSModel.m
######//    Quentin
######//
######//    Created by quentin on 15-05-13
######//    Copyright (c) 2015年 tianjiashun. All rights reserved.
######//

#######import "TJSModel.h"

    @implementation TJSModel

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

    - (void)updateDataFromDictionary:(NSDictionary *)dict
    {
        [self setValuesForKeysWithDictionary:dict];
    }

    - (void)setValue:(id)value forKey:(NSString *)key
    {
        [super setValue:value forKey:key];
    }

    - (void)setValue:(id)value forUndefinedKey:(NSString *)key
    {
        NSLog(@"%s中不存在%@键值",__FILE__,key);
    }

    - (void)setNilValueForKey:(NSString *)key
    {
         NSLog(@"%@值为空",key);
    }

    - (NSDictionary *)properties            
    { 

         NSMutableDictionary *dict = [NSMutableDictionary dictionary];                

        unsigned int count;                

        objc_property_t *properties = class_copyPropertyList([self class], &count);                

        for (int index = 0; index < count; index ++) {                

            objc_property_t property = properties[index];                
            const char *char_name = property_getName(property);//获取属性名                
            NSString *propertyName = [NSString stringWithUTF8String:char_name];                

            id propertyValue = [self valueForKey:propertyName];//属性值                
            if (propertyValue) {                
                [dict setObject:propertyValue forKey:propertyName];                
            }                
        }                
        free(properties);                                
    return dict;            
    }            

    - (NSString *)description            
    {            
        return [[self properties] description];            
    }

    @end

