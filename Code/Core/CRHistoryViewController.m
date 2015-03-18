//
//  CRHistoryViewController.m
//  Core
//
//  Created by tian on 15/3/17.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#import "CRHistoryViewController.h"
#import "PathManager.h"
#import "NSString+Util.h"
#import "ViewController.h"
#import "FileItem.h"
#import "CRAlertViewController.h"

@interface CRHistoryViewController ()


@property (nonatomic, strong)  NSMutableArray *fileNames;
@property (nonatomic, strong)  FileItem *fileItem;
@end

@implementation CRHistoryViewController
@synthesize aTableView;
@synthesize fileNames;
@synthesize fileItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.title = @"历史";
    
    self.fileItem = [[FileItem alloc] init];
    
    self.fileNames = [NSMutableArray arrayWithArray:[PathManager fileNames]];
}

#pragma mark - on click

- (IBAction)onLookClick:(id)sender
{
    NSInteger selectedIndex = aTableView.selectedRow;
    
    if (selectedIndex >= [self.fileNames count]) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"未选择查看文件!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
    
    [self loadDataWithSelectedIndex:selectedIndex];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeDataFinishedNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.fileItem.typeItems, @"type",  self.fileItem.parameterItems, @"parameter", nil]];
    
    [self dismissController:nil];
}

- (IBAction)onDelLineClick:(id)sender
{
    NSInteger selectedIndex = aTableView.selectedRow;
    
    if (selectedIndex >= [self.fileNames count]) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"未选择删除文件!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"点击删除将会删除选中文件记录!"];
    [alert addButtonWithTitle:@"删除"];
    [alert addButtonWithTitle:@"取消"];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse respones){
        
        if (respones == NSAlertFirstButtonReturn) {
            
            NSString *path = [PathManager pathWithFileName:[self.fileNames objectAtIndex:selectedIndex]];
            [PathManager deleteFile:path];
            
            [self.fileNames removeObjectAtIndex:selectedIndex];
            
            [aTableView reloadData];
        }
        
    }];
}

- (IBAction)onAllDelClick:(id)sender
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"删除"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:@"点击删除将会删除全部文件记录,请谨慎!"];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse respones){
        
        if (respones == NSAlertFirstButtonReturn) {
            [self.fileNames removeAllObjects];
            
            NSString *path = [PathManager fileDirPath];
            [PathManager deleteFile:path];
            
            [aTableView reloadData];
        }
        
    }];

}

#pragma mark - alert

-(void)alertEnded:(NSAlert *)alert code:(int)choice context:(void *)context
{
    NSLog(@"alert %@",alert);
}

#pragma mark - load data

- (void)loadDataWithSelectedIndex:(NSInteger)index
{
    NSString *path = [PathManager pathWithFileName:[self.fileNames objectAtIndex:index]];
    
    id value = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ([value isKindOfClass:[NSDictionary class]]) {
       
        if ([[value objectForKey:kVersionKey] isEqualToString:kVersion]) {
            self.fileItem = [value objectForKey:kItemKey];
        }
    }
    else {
        [PathManager deleteFile:path];
    }
}

#pragma mark - NSTableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.fileNames count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *fileName = [self.fileNames objectAtIndex:row];
    
    tableColumn.editable = NO;
    if ([tableColumn.identifier isEqualToString:@"left"]) {
        return [[fileName fileNames] objectAtIndex:0];
    }
    else if ([tableColumn.identifier isEqualToString:@"right"]) {
        return [[fileName fileNames] objectAtIndex:1];
    }
    
    return nil;
}

@end
