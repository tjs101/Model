//
//  TransJsonViewController.m
//  Core
//
//  Created by Silence on 2017/1/23.
//  Copyright © 2017年 tian. All rights reserved.
//

#import "TransJsonViewController.h"

@interface TransJsonViewController ()

@end

@implementation TransJsonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)onClickConfirm:(id)sender {
    if (_textView.textStorage.length == 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"JSON字符串不能为空!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        return;
    }
    
    NSString *jsonStr = _textView.textStorage.string;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(transJsonStr:)]) {
        [self.delegate transJsonStr:jsonStr];
    }
    
}
@end
