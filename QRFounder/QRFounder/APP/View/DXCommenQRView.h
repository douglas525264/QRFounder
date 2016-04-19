//
//  DXCommenQRView.h
//  QRFounder
//
//  Created by Douglas on 16/3/23.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRModel.h"
@interface DXCommenQRView : UIView

@property (nonatomic, strong) QRModel *qrModel;
//以下三个属性均可通过第一个属性设置 单独设置为单独加动画
//二维码板框图片
@property (nonatomic, strong) UIImage *boarderImage;
//二维码logo
@property (nonatomic, strong) UIImage *logo;
//二维码位置
@property (nonatomic, assign) CGRect QRFrame;

@end
