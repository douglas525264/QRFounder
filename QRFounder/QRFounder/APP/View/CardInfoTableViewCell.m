//
//  CardInfoTableViewCell.m
//  QRFounder
//
//  Created by douglas on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CardInfoTableViewCell.h"

@implementation CardInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputView.delegate = self;
    // Initialization code
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
