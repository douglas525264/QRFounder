
//
//  WIFIInfoView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "WIFIInfoView.h"

@implementation WIFIInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.wifiNameTextView.placeHolder = @"WIFI名称";
    self.pswTextView.placeHolder = @"密码";
    self.wifiNameTextView.delegate = self;
    self.pswTextView.delegate = self;
    [self.WAPBtn setImage:[UIImage imageNamed:@"selectedImage"] forState:UIControlStateSelected];
    [self.WEPBtn setImage:[UIImage imageNamed:@"selectedImage"] forState:UIControlStateSelected];
    [self.NOPSWBTN setImage:[UIImage imageNamed:@"selectedImage"] forState:UIControlStateSelected];
    self.WAPBtn.selected = YES;
}
- (IBAction)btnClick:(UIButton *)sender {
    
    if (sender.tag == 0) {
        self.WAPBtn.selected = YES;
        self.WEPBtn.selected = NO;
        self.NOPSWBTN.selected = NO;
        self.pswBgView.hidden = NO;
    }
    if (sender.tag == 1) {
        self.WAPBtn.selected = NO;
        self.WEPBtn.selected = YES;
        self.NOPSWBTN.selected = NO;
        self.pswBgView.hidden = NO;
    }
    if (sender.tag == 2) {
        self.WAPBtn.selected = NO;
        self.WEPBtn.selected = NO;
        self.NOPSWBTN.selected = YES;
        self.pswBgView.hidden = YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (NSString *)getResultInfoStr {
    //WIFI:S:12334;T:WPA;P:4567664;
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    [resultStr appendString:@"WIFI:S:"];
    [resultStr appendFormat:@"%@;",self.wifiNameTextView.text];
    [resultStr appendString:@"T:"];
    if (self.NOPSWBTN.selected) {
        [resultStr appendString:@"nopass;"];
    }
    if (self.WAPBtn.selected) {
        [resultStr appendString:@"WAP;"];
        [resultStr appendFormat:@"P:%@;",self.pswTextView.text];
    }
    if (self.WEPBtn.selected) {
        [resultStr appendString:@"WEP;"];
        [resultStr appendFormat:@"P:%@;",self.pswTextView.text];
    }
    if (resultStr.length == 0) {
        [[DXHelper shareInstance] makeAlterWithTitle:@"信息不完整请重新输入" andIsShake:NO];
        return nil;
    }
    return resultStr;
}


@end
