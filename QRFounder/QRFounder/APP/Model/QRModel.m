//
//  QRModel.m
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QRModel.h"

@implementation QRModel
- (id)copyWithZone:(nullable NSZone *)zone {

    QRModel *qr = [QRModel allocWithZone:zone];
    qr.QRStr = self.QRStr;
    qr.bgImage = self.bgImage;
    qr.QRFrame = self.QRFrame;
    qr.boarderImage = self.boarderImage;
    qr.logo = self.logo;
    qr.type = self.type;
    return qr;
}
@end
