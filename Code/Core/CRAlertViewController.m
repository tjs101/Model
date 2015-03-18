//
//  CRAlertViewController.m
//  Core
//
//  Created by tian on 15/3/17.
//  Copyright (c) 2015年 tian. All rights reserved.
//

#import "CRAlertViewController.h"

@interface CRAlertViewController ()

@property (nonatomic, strong) NSMutableArray *typeItems;
@property (nonatomic, strong) NSMutableArray *parameterItems;

@property (nonatomic, strong) NSMutableArray *giveUpTypeItems;
@property (nonatomic, strong) NSMutableArray *giveUpParameterItems;

@end

@implementation CRAlertViewController
@synthesize typeItems;
@synthesize parameterItems;

@synthesize giveUpTypeItems;
@synthesize giveUpParameterItems;

@synthesize aTableView;

- (id)initWithTypeItems:(NSArray *)aTypeItems parameterItems:(NSArray *)aParameterItems
{
    if (self = [super init]) {
        self.typeItems = [NSMutableArray arrayWithArray:aTypeItems];
        self.parameterItems = [NSMutableArray arrayWithArray:aParameterItems];
        
        self.giveUpParameterItems = [NSMutableArray array];
        self.giveUpTypeItems = [NSMutableArray array];
        
        self.title = @"修改";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
}

#pragma mark - on click

- (IBAction)dismissController:(id)sender
{
    [super dismissController:sender];

    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeDataFinishedNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.typeItems, @"type",  self.parameterItems, @"parameter", nil]];

}

- (IBAction)onDelClick:(id)sender
{
    NSInteger selectedIndex = [aTableView selectedRow];
    
    if (selectedIndex >= [self.typeItems count]) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"未选择删除参数!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
    
    [self.giveUpTypeItems addObject:[self.typeItems objectAtIndex:selectedIndex]];
    [self.giveUpParameterItems addObject:[self.parameterItems objectAtIndex:selectedIndex]];
    
    [self.typeItems removeObjectAtIndex:selectedIndex];
    [self.parameterItems removeObjectAtIndex:selectedIndex];
    
    [aTableView reloadData];
}

- (IBAction)onGiveUpClick:(id)sender
{
    
    if ([self.giveUpTypeItems count] == 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"未有删除的参数!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
    
    [self.typeItems addObject:[self.giveUpTypeItems lastObject]];
    [self.parameterItems addObject:[self.giveUpParameterItems lastObject]];
    
    [self.giveUpTypeItems removeLastObject];
    [self.giveUpParameterItems removeLastObject];
    
    [aTableView reloadData];
}

#pragma mark - NSTableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.typeItems count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([tableColumn.identifier isEqualToString:@"left"]) {
        tableColumn.editable = NO;
        return [self.typeItems objectAtIndex:row];
    }
    else if ([tableColumn.identifier isEqualToString:@"right"]) {
        return [self.parameterItems objectAtIndex:row];
    }
    return nil;
}


- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSLog(@"colu %@",object);
    if ([tableColumn.identifier isEqualToString:@"right"]) {
        [self.parameterItems replaceObjectAtIndex:row withObject:object];
    }
}


@end
