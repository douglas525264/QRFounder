//
//  DownloadTableViewCell.m
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import <UIImageView+AFNetworking.h>
@implementation DownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.downLoadBtn.layer.cornerRadius = 5;
    self.downLoadBtn.layer.borderWidth = 1;
    self.downLoadBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    // Initialization code
}
- (void)configWithModel:(SourceItemModel *)model {

    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.iconURL]];
    self.titleLable.text = model.name;
    self.desLable.text = model.desStr;
    if (model.status != TaskStatusDownLoading) {
        self.progressLable.hidden = YES;
        self.downLoadBtn.hidden = NO;
    }else {
        self.progressLable.hidden = NO;
        self.downLoadBtn.hidden = YES;
    }
}
- (IBAction)dowladBtnClick:(id)sender {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
