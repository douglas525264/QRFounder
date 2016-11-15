//
//  TextInfoView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "TextInfoView.h"
#import "DXAlertAction.h"
#import "MainViewController.h"
#import "QRScanViewController.h"

@implementation TextInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)addBtnClick:(id)sender {
    
    @weakify(self);
    [DXAlertAction showActionSheetWithTitle:@"操作" msg:nil inVC:[MainViewController shareInstance] sourceView:self.addBtn chooseBlock:^(NSInteger buttonIdx) {
        
        @strongify(self);
        if (self.commendCallBlock) {
            self.commendCallBlock(buttonIdx);
        }
    } buttonsStatement:@"取消",@"从相册读取二维码",@"扫描获取二维码",nil];
}
- (void)showAlbum{

    
}
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
