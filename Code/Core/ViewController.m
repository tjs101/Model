//
//  ViewController.m
//  Core
//
//  Created by tian on 15/3/13.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#import "ViewController.h"
#import "CRAlertViewController.h"
#import "CRHistoryViewController.h"
#import "FileItem.h"
#import "PathManager.h"

#define kDefaultFileName @"TJSModel"

NSString  *const ChangeDataFinishedNotification = @"ChangeDataFinishedNotification";


@interface ViewController ()

{
    NSString *_parameterHStr;
    NSString *_interfaceHStr;
    
    NSString *_parameterMStr;
    NSString *_interfaceMStr;
    NSString *_decoderHeaderMStr;
    NSString *_decoderStr;
    NSString *_decoderFooterMStr;
    
    NSString *_coderHeaderMStr;
    NSString *_coderStr;
    NSString *_coderFooterMStr;
    
    NSString *_functionNameStr;
    NSString *_functionHeaderStr;
    NSString *_functionStr;
    
    NSString *_hHeaderStr;
    NSString *_mHeaderStr;
    
    BOOL _checkOnState;//选中状态,(是否获取数据方法)
    BOOL _codingState;//是否coding协议
    
    BOOL _baseClass;//是否为基类
    
}

@property (nonatomic, strong) NSMutableArray *typeItems;
@property (nonatomic, strong) NSMutableArray *parameterItems;

@property (nonatomic, strong) NSMutableArray *urlItems;//NSURL参数
@property (nonatomic, strong) NSMutableArray *timeItems;//时间参数

@property (nonatomic, strong) FileItem  *fileItem;

@end

@implementation ViewController
@synthesize typeItems;
@synthesize parameterItems;
@synthesize urlItems;
@synthesize timeItems;

@synthesize fileItem;

@synthesize aComboBox = _aComboBox;
@synthesize fileNameTextField = _fileNameTextField;
@synthesize parameterTextField = _parameterTextField;
@synthesize addButton;
@synthesize generateButton;
@synthesize contentHTextField = _contentHTextField;
@synthesize contentMTextField = _contentMTextField;
@synthesize resetButton;
@synthesize hHeaderLabel = _hHeaderLabel;
@synthesize mHeaderLabel = _mHeaderLabel;
@synthesize editButton;
@synthesize checkButon;
@synthesize codingButton;
@synthesize baseClassButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDataFinishedNotification:) name:ChangeDataFinishedNotification object:nil];
    
    self.typeItems = [NSMutableArray array];
    self.parameterItems = [NSMutableArray array];
    self.urlItems = [NSMutableArray array];
    self.timeItems = [NSMutableArray array];
    
    self.fileItem = [[FileItem alloc] init];
    
    _fileNameTextField.stringValue = kDefaultFileName;
    [self refreshHeaderLabel];
    
    _functionNameStr = @"- (void)updateDataFromDictionary:(NSDictionary *)dict";
    
    //decoder
    _decoderHeaderMStr = @"- (id)initWithCoder:(NSCoder *)aDecoder\n{\n     if (self = [super init]) {";
    _decoderFooterMStr = @"     }\n     return self;\n}";
    
    //coder
    _coderHeaderMStr = @"- (void)encodeWithCoder:(NSCoder *)aCoder\n{";
    _coderFooterMStr = @"}";
    
    //function
    _functionHeaderStr = [NSString stringWithFormat:@"%@\n{",_functionNameStr];
    
    _contentMTextField.editable = NO;
    _contentHTextField.editable = NO;
    
    _checkOnState = checkButon.state;
    _codingState = codingButton.state;
    _baseClass = baseClassButton.state;

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - save

- (void)saveData
{
    self.fileItem.fileName = _fileNameTextField.stringValue;
    self.fileItem.typeItems = self.typeItems;
    self.fileItem.parameterItems = self.parameterItems;
    
    NSString *path = [PathManager filePathWithFileName:_fileNameTextField.stringValue];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.fileItem , kItemKey, kVersion, kVersionKey, nil];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:dict toFile:path];
    if (!success) {
        NSLog(@"save file failed!");
    }
}


#pragma mark - NSNotification

- (void)changeDataFinishedNotification:(NSNotification *)notification
{
    NSLog(@"not %@",notification.userInfo);
    NSArray *aTypeItems = [NSArray arrayWithArray:[notification.userInfo objectForKey:@"type"]];
    NSArray *aParameterItems = [NSArray arrayWithArray:[notification.userInfo objectForKey:@"parameter"]];
    
    [self editContentWithType:aTypeItems parameterItems:aParameterItems];
}

#pragma mark - 重置数据

- (void)resetData
{
    _decoderStr = nil;
    _coderStr = nil;
    _functionStr = nil;
    _parameterHStr = nil;
    _parameterMStr = nil;
    _interfaceHStr = nil;
    _interfaceMStr = nil;
    
    _contentHTextField.string = @"";
    _contentMTextField.string = @"";
    
    [self.typeItems removeAllObjects];
    [self.parameterItems removeAllObjects];
    [self.urlItems removeAllObjects];
    [self.timeItems removeAllObjects];
}

#pragma mark - on click
//重置
- (IBAction)onResetClick:(id)sender
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"重置内容,将把其中添加的内容都删除?点击确定按钮则继续进行,否则点击取消返回!"];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse response) {
        
        if (response == NSAlertFirstButtonReturn) {
            [self resetData];
        }
        
    }];
    
}

- (IBAction)onCheckClick:(id)sender
{
    _checkOnState = checkButon.state;
    _codingState = codingButton.state;
    _baseClass = baseClassButton.state;
    
    NSArray *aTypeItems = [NSArray arrayWithArray:self.typeItems];
    NSArray *aParameterItems = [NSArray arrayWithArray:self.parameterItems];
    
    [self editContentWithType:aTypeItems parameterItems:aParameterItems];
}

- (IBAction)onSaveClick:(id)sender
{
    
    if ([_fileNameTextField.stringValue stringByReplacingOccurrencesOfString:@""  withString:@""].length == 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"文件名不能为空!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];

        return;
    }
    
    if ([_contentHTextField.string stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"文件内容不能为空!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
    
    [self saveData];
}

- (IBAction)onAddClick:(id)sender
{
    
    if ([_parameterTextField.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
            
        _parameterTextField.stringValue = @"";
        [_parameterTextField resignFirstResponder];
            
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"参数不能为空!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
            
        return;
    }

    
    if ([self.parameterItems containsObject:[NSString stringWithFormat:@"%@",_parameterTextField.stringValue]]) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"参数不能相同!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        return;
    }

    [self.typeItems addObject:_aComboBox.stringValue];
    [self.parameterItems addObject:_parameterTextField.stringValue];
    
    
    NSArray *aTypeItems = [NSArray arrayWithArray:self.typeItems];
    NSArray *aParameterItems = [NSArray arrayWithArray:self.parameterItems];
    
    [self editContentWithType:aTypeItems parameterItems:aParameterItems];
}

- (IBAction)onEditClick:(id)sender
{
    CRAlertViewController *viewCtrl = [[CRAlertViewController alloc] initWithTypeItems:self.typeItems parameterItems:self.parameterItems];
    [self presentViewControllerAsModalWindow:viewCtrl];
}

- (IBAction)onGenerateClick:(id)sender
{
    if ([_fileNameTextField.stringValue stringByReplacingOccurrencesOfString:@""  withString:@""].length == 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"文件名不能为空!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
    
    if ([_contentHTextField.string stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"文件不能为空!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
    
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setMessage:@"选择保存路径"];
    [panel setCanChooseDirectories:YES];
    
    if ([panel runModal] == NSModalResponseOK) {

        NSString *path = [panel.URL.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",_fileNameTextField.stringValue]];
        BOOL success = [_contentHTextField.string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        
        if (success) {
            path = [panel.URL.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",_fileNameTextField.stringValue]];
            success = [_contentMTextField.string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        }

        if (success) {
            
            [self saveData];
            
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"保存文件成功!"];
            [alert addButtonWithTitle:@"OK"];
            [alert runModal];
        }
    }
}

- (IBAction)onHistoryClick:(id)sender
{
    CRHistoryViewController *viewCtrl = [[CRHistoryViewController alloc] init];
    [self presentViewControllerAsModalWindow:viewCtrl];
}

#pragma mark - 时间

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *formatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    return formatter;
}

//时间
- (NSString *)time
{
    NSDateFormatter *dateFormatter = [ViewController dateFormatter];
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

//年
- (NSString *)year
{
    NSDateFormatter *dateFormatter = [ViewController dateFormatter];
    [dateFormatter setDateFormat:@"yyyy"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

//文件头部(type:h或者m文件)
- (NSString *)headerWithType:(NSString *)type
{
   NSString * headerStr = [NSString stringWithFormat:@"//\n//    %@.%@\n//    Quentin\n//\n//    Created by quentin on %@\n//    Copyright (c) %@年 tianjiashun. All rights reserved.\n//",_fileNameTextField.stringValue,type,[self time],[self year]];
    return headerStr;
    
}

#pragma mark - 刷新
//刷新文件名
- (void)refreshHeaderLabel
{
    _hHeaderLabel.stringValue = [NSString stringWithFormat:@"%@.h",_fileNameTextField.stringValue];
    _mHeaderLabel.stringValue = [NSString stringWithFormat:@"%@.m",_fileNameTextField.stringValue];
}

//更改名称后 更改文件头部
- (void)refreshFileHeader
{
    _hHeaderStr = [self headerWithType:@"h"];
    _mHeaderStr = [self headerWithType:@"m"];
    
    
    //m文件
    
    NSString *functionStr = [NSString stringWithFormat:@"%@\n%@",_functionHeaderStr,_functionStr];
    NSString *decoderStr = [NSString stringWithFormat:@"%@\n%@\n%@",_decoderHeaderMStr,_decoderStr,_decoderFooterMStr];
    NSString *coderStr = [NSString stringWithFormat:@"%@\n%@\n%@",_coderHeaderMStr,_coderStr,_coderFooterMStr];
    
    _interfaceMStr = [NSString stringWithFormat:@"#import \"%@.h\"\n\n@implementation %@",_fileNameTextField.stringValue,_fileNameTextField.stringValue];
    
    //h文件
    if (_codingState) {
        _interfaceHStr = [NSString stringWithFormat:@"#import <Foundation/Foundation.h>\n\n@interface %@ : NSObject <NSCoding>\n",_fileNameTextField.stringValue];
    }
    else {
        _interfaceHStr = [NSString stringWithFormat:@"#import <Foundation/Foundation.h>\n\n@interface %@ : NSObject\n",_fileNameTextField.stringValue];
    }
    
    
    if (_checkOnState && _baseClass) {
        _contentHTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n%@;\n\n@end",_hHeaderStr,_interfaceHStr,_parameterHStr,_functionNameStr];
    }
    else  if (_checkOnState) {
        _contentHTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n%@;\n\n@end",_hHeaderStr,_interfaceHStr,_parameterHStr,_functionNameStr];
    }
    else if (_baseClass) {
        _contentHTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n%@;\n\n@end",_hHeaderStr,_interfaceHStr,_parameterHStr];
    }
    else {
        _contentHTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n@end",_hHeaderStr,_interfaceHStr,_parameterHStr];
    }
    
    //m文件
    if (_codingState) {
        
        if (_checkOnState) {//获取
            _contentMTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@%@",_mHeaderStr,_interfaceMStr,_parameterMStr,decoderStr,coderStr,functionStr,@"@end"];
        }
        else if (_baseClass) {//基类
            _contentMTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@%@",_mHeaderStr,_interfaceMStr,_parameterMStr,decoderStr,coderStr,_functionStr,@"@end"];
        }
        else {
            _contentMTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@",_mHeaderStr,_interfaceMStr,_parameterMStr,decoderStr,coderStr,@"@end"];
        }
    }
    else {
        
        if (_checkOnState) {
            _contentMTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@%@",_mHeaderStr,_interfaceMStr,_parameterMStr,functionStr,@"@end"];
        }
        else if (_baseClass) {
            _contentMTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@%@",_mHeaderStr,_interfaceMStr,_parameterMStr,_functionStr,@"@end"];
        }
        else {
            _contentMTextField.string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@",_mHeaderStr,_interfaceMStr,_parameterMStr,@"@end"];
        }
    }

}

//修改内容
- (void)editContentWithType:(NSArray *)aTypeItems parameterItems:(NSArray *)aParameterItems
{
    
    [self resetData];
    
    for (NSUInteger index = 0; index < [aTypeItems count]; index ++) {
        
        NSString *parameter = [aParameterItems objectAtIndex:index];
        NSString *attribute = [aTypeItems objectAtIndex:index];
        NSString *contentH;//h文件
        NSString *contentM;//m文件
        NSString *decorder;//decorder
        NSString *coder;//coder
        NSString *function;//function
        
        if ([attribute isEqualToString:@"NSURL"]) {
            [self.urlItems addObject:parameter];
        }
        
        if ([attribute isEqualToString:@"NSURL"] || [attribute isEqualToString:@"NSString"] || [attribute isEqualToString:@"NSArray"] || [attribute isEqualToString:@"NSDictionary"] || [attribute isEqualToString:@"NSNumber"] || [attribute isEqualToString:@"NSObject"]) {
            contentH = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",attribute,parameter];
            
        }
        
        if ([attribute isEqualToString:@"id"]) {
            contentH = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ %@;",attribute,parameter];
        }
        
        if ([attribute isEqualToString:@"NSTimeInterval"]) {
            [self.timeItems addObject:parameter];
        }
        
        if ([attribute isEqualToString:@"BOOL"] || [attribute isEqualToString:@"NSInteger"] || [attribute isEqualToString:@"double"] || [attribute isEqualToString:@"float"] || [attribute isEqualToString:@"NSUInteger"] || [attribute isEqualToString:@"NSTimeInterval"]) {
            contentH = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@;",attribute,parameter];
        }
        
        contentM = [NSString stringWithFormat:@"@synthesize %@;",parameter];
        
        
        if ([attribute isEqualToString:@"BOOL"]) {
            decorder = [NSString stringWithFormat:@"        self.%@ = [aDecoder decodeBoolForKey:@\"%@\"];",parameter,parameter];
            coder = [NSString stringWithFormat:@"       [aCoder encodeBool:self.%@ forKey:@\"%@\"];",parameter,parameter];
        }
        else if ([attribute isEqualToString:@"NSInteger"] || [attribute isEqualToString:@"NSUInteger"]) {
            decorder = [NSString stringWithFormat:@"        self.%@ = [aDecoder decodeIntegerForKey:@\"%@\"];",parameter,parameter];
            coder = [NSString stringWithFormat:@"       [aCoder encodeInteger:self.%@ forKey:@\"%@\"];",parameter,parameter];
        }
        else if ([attribute isEqualToString:@"NSString"] || [attribute isEqualToString:@"NSNumber"] || [attribute isEqualToString:@"NSArray"] || [attribute isEqualToString:@"NSDictionary"] || [attribute isEqualToString:@"NSObject"] || [attribute isEqualToString:@"id"]) {
            decorder = [NSString stringWithFormat:@"        self.%@ = [aDecoder decodeObjectForKey:@\"%@\"];",parameter,parameter];
            coder = [NSString stringWithFormat:@"       [aCoder encodeObject:self.%@ forKey:@\"%@\"];",parameter,parameter];
        }
        else if ([attribute isEqualToString:@"NSURL"]) {
            decorder = [NSString stringWithFormat:@"        self.%@ = [NSURL URLWithString:[aDecoder decodeObjectForKey:@\"%@\"]];",parameter,parameter];
            coder = [NSString stringWithFormat:@"       [aCoder encodeObject:self.%@.absoluteString forKey:@\"%@\"];",parameter,parameter];
        }
        else if ([attribute isEqualToString:@"double"] || [attribute isEqualToString:@"NSTimeInterval"]) {
            decorder = [NSString stringWithFormat:@"        self.%@ = [aDecoder decodeDoubleForKey:@\"%@\"];",parameter,parameter];
            coder = [NSString stringWithFormat:@"       [aCoder encodeDouble:self.%@ forKey:@\"%@\"];",parameter,parameter];
        }
        else if ([attribute isEqualToString:@"float"]) {
            decorder = [NSString stringWithFormat:@"        self.%@ = [aDecoder decodeFloatForKey:@\"%@\"];",parameter,parameter];
            coder = [NSString stringWithFormat:@"       [aCoder encodeFloat:self.%@ forKey:@\"%@\"];",parameter,parameter];
        }
        
        function = @"       [self setValuesForKeysWithDictionary:dict];\n}";
    
        //h文件
        if (_parameterHStr.length == 0) {
            _parameterHStr = contentH;
        }
        else {
            _parameterHStr = [NSString stringWithFormat:@"%@\n%@",_parameterHStr,contentH];
        }
        
        //m文件
        if (_parameterMStr.length == 0) {
            _parameterMStr = contentM;
        }
        else {
            _parameterMStr = [NSString stringWithFormat:@"%@\n%@",_parameterMStr,contentM];
        }

        //decoder
        if (_decoderStr.length == 0) {
            _decoderStr = decorder;
        }
        else {
            _decoderStr = [NSString stringWithFormat:@"%@\n%@",_decoderStr,decorder];
        }
        
        //coder
        if (_coderStr.length == 0) {
            _coderStr = coder;
        }
        else {
            _coderStr = [NSString stringWithFormat:@"%@\n%@",_coderStr,coder];
        }
        
        //keyFunction
        NSString *keyFunction = nil;
        
        //undefinedKeyFunction
        NSString *undefinedKeyFunction = nil;
        
        //nilValue
        NSString *nilValueKey = nil;
        
        if (_checkOnState) {

            if ([self.urlItems count] == 0 && [self.timeItems count] == 0) {//不存在NSURL和NSTimeInterval类型参数
                
                keyFunction = @"- (void)setValue:(id)value forKey:(NSString *)key\n{\n       [super setValue:value forKey:key];\n}";
                
            } else {
                
                NSMutableString *urlParStr = [NSMutableString string];
                
                for (NSString *urlPar in self.urlItems) {
                    
                    if (urlParStr.length == 0) {
                        NSString *par = [NSString stringWithFormat:@"\n     if ([key isEqualToString:@\"%@\"]) {\n          self.%@ = [NSURL URLWithString:value];\n    }",urlPar,urlPar];
                        [urlParStr appendString:par];
                    }
                    else {
                        NSString *par = [NSString stringWithFormat:@"\n    else if ([key isEqualToString:@\"%@\"]) {\n          self.%@ = [NSURL URLWithString:value];\n    }",urlPar,urlPar];
                        [urlParStr appendString:par];
                    }
                }
                
                for (NSString *urlPar in self.timeItems) {
                    
                    if (urlParStr.length == 0) {
                        NSString *par = [NSString stringWithFormat:@"\n     if ([key isEqualToString:@\"%@\"]) {\n          self.%@ = [value doubleValue]/1000;\n    }",urlPar,urlPar];
                        [urlParStr appendString:par];
                    }
                    else {
                        NSString *par = [NSString stringWithFormat:@"\n    else if ([key isEqualToString:@\"%@\"]) {\n          self.%@ = [value doubleValue]/1000;\n    }",urlPar,urlPar];
                        [urlParStr appendString:par];
                    }
                }
                
                keyFunction = [NSString stringWithFormat:@"- (void)setValue:(id)value forKey:(NSString *)key\n{%@ else {\n          [super setValue:value forKey:key];\n    }\n}",urlParStr];
                
            }
            
            //undefinedKeyFunction
            undefinedKeyFunction = @"- (void)setValue:(id)value forUndefinedKey:(NSString *)key\n\{\n         NSLog(@\"%s中不存在%@键值\",__FILE__,key);\n}";
            
            //nilValue
            nilValueKey = @"- (void)setNilValueForKey:(NSString *)key\n{\n      NSLog(@\"%@值为空\",key);\n}\n\n";
        }

        //文件描述
        NSString *descriptionStr = nil;
        
        if (_baseClass) {//是否基类
            
            descriptionStr = @"- (NSDictionary *)properties\
            \n{\
                \n      NSMutableDictionary *dict = [NSMutableDictionary dictionary];\
                \n\
                \n      unsigned int count;\
                \n\
                \n      objc_property_t *properties = class_copyPropertyList([self class], &count);\
                \n\
                \n      for (int index = 0; index < count; index ++) {\
                \n\
                \n          objc_property_t property = properties[index];\
                \n          const char *char_name = property_getName(property);//获取属性名\
                \n          NSString *propertyName = [NSString stringWithUTF8String:char_name];\
                \n\
                \n          id propertyValue = [self valueForKey:propertyName];//属性值\
                \n          if (propertyValue) {\
                \n              [dict setObject:propertyValue forKey:propertyName];\
                \n          }\
                \n      }\
                \n      free(properties);\
                \
                \n      return dict;\
            \n}\
            \n\
            \n- (NSString *)description\
            \n{\
            \n      return [[self properties] description];\
            \n}\n\n";
            

        }

        if (_checkOnState && _baseClass) {
            //function
            _functionStr = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\%@",function,keyFunction,undefinedKeyFunction,nilValueKey,descriptionStr];
        }
        else if (_checkOnState) {
            //function
            _functionStr = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@",function,keyFunction,undefinedKeyFunction,nilValueKey];
        }
        else if (_baseClass) {
            //function
            _functionStr = [NSString stringWithFormat:@"%@",descriptionStr];
        }
        
        [self refreshFileHeader];

        [self.typeItems addObject:attribute];
        [self.parameterItems addObject:parameter];

    }
}

#pragma mark - controlTextDidChange

- (void)controlTextDidChange:(NSNotification *)obj {
    
    if ([obj.object isKindOfClass:[NSTextField class]]) {
        
        if (obj.object == _fileNameTextField) {
            
            if (_fileNameTextField.stringValue.length == 0) {
                _fileNameTextField.stringValue = kDefaultFileName;
            }
            
            [self refreshHeaderLabel];
            
            if (_contentHTextField.string.length != 0) {
                
                [self refreshFileHeader];
            }
        }
        
    }
}

@end
