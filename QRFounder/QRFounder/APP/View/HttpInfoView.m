
//
//  HttpInfoView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "HttpInfoView.h"

@implementation HttpInfoView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.infoTextView.delegate = self;
    self.infoTextView.placeHolder = @"http://";
}

- (NSString *)getResultInfoStr {
    if (self.infoTextView.text.length == 0) {
        [[DXHelper shareInstance] makeAlterWithTitle:@"请输入网址" andIsShake:YES];
        return nil;
    }
    if (!([self.infoTextView.text hasPrefix:@"http://"] || [self.infoTextView.text hasPrefix:@"https://"])) {
        [[DXHelper shareInstance] makeAlterWithTitle:@"网址格式不正确" andIsShake:YES];
        return nil;
    }
    
    
    
    return self.infoTextView.text;
}

@end
