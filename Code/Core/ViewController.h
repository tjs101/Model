//
//  ViewController.h
//  Core
//
//  Created by tian on 15/3/13.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Config.h"

@interface ViewController : NSViewController 

@property (nonatomic, weak)  IBOutlet NSComboBox *aComboBox;//类型
@property (nonatomic, weak)  IBOutlet NSTextField *fileNameTextField;//文件名
@property (nonatomic, weak)  IBOutlet NSTextField *parameterTextField;//参数
@property (nonatomic, weak)  IBOutlet NSButton *addButton;//增加
@property (nonatomic, weak)  IBOutlet NSButton *generateButton;//生成
@property (nonatomic, weak)  IBOutlet NSButton *resetButton;//重置
@property (nonatomic, strong)  IBOutlet NSTextView *contentHTextField;//h文件
@property (nonatomic, strong)  IBOutlet NSTextView *contentMTextField;//m文件
@property (nonatomic, weak)  IBOutlet NSTextField *hHeaderLabel;
@property (nonatomic, weak)  IBOutlet NSTextField *mHeaderLabel;
@property (nonatomic, weak)  IBOutlet NSButton *editButton;

@property (nonatomic, weak)  IBOutlet NSButton *checkButon;//是否添加获取数据方法
@property (nonatomic, weak)  IBOutlet NSButton *codingButton;//是否coding
@property (nonatomic, weak)  IBOutlet NSButton *baseClassButton;//是否为基类

- (IBAction)onAddClick:(id)sender;//增加
- (IBAction)onGenerateClick:(id)sender;//生成
- (IBAction)onResetClick:(id)sender;//重置
- (IBAction)onEditClick:(id)sender;//编辑

- (IBAction)onSaveClick:(id)sender;//保存

- (IBAction)onHistoryClick:(id)sender;//历史

- (IBAction)onCheckClick:(id)sender;//选择

@end

