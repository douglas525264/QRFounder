
//
//  APPInfoView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "APPInfoView.h"

@implementation APPInfoView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.otherOSTextView.placeHolder = @"请输入其他APP应用平台链接";
    [self.sControl addTarget:self action:@selector(selectChange:) forControlEvents:UIControlEventValueChanged];
    self.sControl.selectedSegmentIndex = 0;
    [self selectChange:self.sControl];
}
- (void)selectChange:(id)sender {
    switch (self.sControl.selectedSegmentIndex) {
        case 0:{
            self.otherOSTextView.hidden = YES;
            self.titleLable.hidden = NO;
            self.iOSInputTextFiled.hidden = NO;
            
        }break;
        case 1:{
           self.otherOSTextView.hidden = NO;
            self.titleLable.hidden = YES;
            self.iOSInputTextFiled.hidden = YES;
        }break;
        default:
            break;
    }

}
- (NSString *)getResultInfoStr {

    if (self.sControl.selectedSegmentIndex == 1) {
        return self.otherOSTextView.text;
    } else {
        return [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@",self.iOSInputTextFiled.text];
    }
}
@end