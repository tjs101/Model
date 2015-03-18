//
//  CRAlertViewController.h
//  Core
//
//  Created by tian on 15/3/17.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Config.h"

@interface CRAlertViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

- (id)initWithTypeItems:(NSArray *)typeItems parameterItems:(NSArray *)parameterItems;

@property (nonatomic, weak)  IBOutlet NSTableView *aTableView;

- (IBAction)onDelClick:(id)sender;//删除
- (IBAction)onGiveUpClick:(id)sender;//放弃修改

@end
