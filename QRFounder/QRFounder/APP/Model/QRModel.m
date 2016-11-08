//
//  QRModel.m
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QRModel.h"
#import "DXHelper.h"
@implementation QRModel
- (id)copyWithZone:(nullable NSZone *)zone {

    QRModel *qr = [QRModel allocWithZone:zone];
    qr.QRStr = self.QRStr;
    qr.bgImage = self.bgImage;
    qr.QRFrame = self.QRFrame;
    qr.boarderImage = self.boarderImage;
    qr.logo = self.logo;
    qr.type = self.type;
    qr.codeColor = self.codeColor;
    qr.createTime = self.createTime;
    qr.isScanResult = self.isScanResult;
    qr.diyModel = self.diyModel;
    return qr;
}
- (instancetype)initWithQrStr:(NSString *)qrStr {
    self = [super init];
    if (self) {
        
        self.QRStr = qrStr;
        _createTime = [NSString getNormalTime];
        _isScanResult = NO;
        self.type =  [[DXHelper shareInstance] getTypeWithStr:qrStr];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        _createTime = [NSString getNormalTime];
        _isScanResult = NO;
    }
    return  self;
}
@end
