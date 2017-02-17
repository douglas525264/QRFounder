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
    switch (model.status) {
        case TaskStatusIdle:{
            [self.downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
        }break;

        case TaskStatusWaiting:{
            [self setProgress:0];
        }break;
        case TaskStatusDownLoading:{
            [self setProgress:model.progress];

        }break;
        case TaskStatusError:{
          
            [self.downLoadBtn setTitle:@"下载失败" forState:UIControlStateNormal];
        }break;
        case TaskStatusUnziping:{
            [self.downLoadBtn setTitle:@"解压中" forState:UIControlStateNormal];
        }break;
        case TaskStatusFinished:{
            [self.downLoadBtn setTitle:@"已下载" forState:UIControlStateNormal];
        }break;
            
        default:
            break;
    }
    if( model.status == TaskStatusError ||  model.status == TaskStatusIdle){
        self.downLoadBtn.enabled = YES;
    
    } else {
        self.downLoadBtn.enabled = NO;
    }
    if (model.status == TaskStatusDownLoading || model.status == TaskStatusWaiting) {
        self.progressLable.hidden = NO;
        self.downLoadBtn.hidden = YES;
    }else {
        self.progressLable.hidden = YES;
        self.downLoadBtn.hidden = NO;
    }
}
- (IBAction)dowladBtnClick:(id)sender {
    if (self.downLoadCallBack) {
        self.downLoadCallBack();
    }
}
- (void)setProgress:(CGFloat)progress {
    self.progressLable.text = [NSString stringWithFormat:@"%.0f%@",progress*100,@"%"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
