//
//  TextInfoView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "TextInfoView.h"

@implementation TextInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    self.textInfoTextView.delegate = self;
     self.textInfoTextView.placeHolder = @"请输入文本信息";
}

- (NSString *)getResultInfoStr {
    if (self.textInfoTextView.text.length == 0) {
        [[DXHelper shareInstance] makeAlterWithTitle:@"请输入文本信息" andIsShake:NO];
        return nil;
    }
    return self.textInfoTextView.text;
}
@end
