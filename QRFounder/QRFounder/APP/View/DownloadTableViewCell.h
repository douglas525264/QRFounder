//
//  DownloadTableViewCell.h
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceItemModel.h"
@interface DownloadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UILabel *progressLable;
@property (nonatomic, copy) void (^downLoadCallBack)();
- (void)configWithModel:(SourceItemModel *)model;
- (void)setProgress:(CGFloat)progress;
@end
