//
//  TransJsonViewController.h
//  Core
//
//  Created by Silence on 2017/1/23.
//  Copyright © 2017年 tian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol TransJsonDelegate <NSObject>

- (void)transJsonStr:(NSString *)jsonStr;

@end

@interface TransJsonViewController : NSViewController
@property (strong) IBOutlet NSTextView *textView;
@property (nonatomic, weak) id<TransJsonDelegate>delegate;

- (IBAction)onClickConfirm:(id)sender;

@end
