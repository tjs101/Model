//
//  CRHistoryViewController.h
//  Core
//
//  Created by tian on 15/3/17.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CRHistoryViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, weak)  IBOutlet NSTableView *aTableView;

- (IBAction)onLookClick:(id)sender;//查看
- (IBAction)onDelLineClick:(id)sender;//删除单行
- (IBAction)onAllDelClick:(id)sender;//删除全部

@end
