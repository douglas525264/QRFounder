//
//  DXCommenQRView.m
//  QRFounder
//
//  Created by Douglas on 16/3/23.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXCommenQRView.h"
#import "DXQRView.h"
#import "QRColorBgView.h"
#define logoWidth (60.0f/320 * self.qrView.frame.size.width)
@interface DXCommenQRView ()
@property (nonatomic, strong) UIImageView *boarderImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) DXQRView *qrView;
@property (nonatomic, strong) QRColorBgView *colorBgView;
@end
@implementation DXCommenQRView


- (void)drawRect:(CGRect)rect {
    if (_qrModel.QRFrame.origin.x > 0) {
        self.QRFrame = _qrModel.QRFrame;
    }else {
        self.QRFrame = CGRectMake(0, 0, 1, 1);
        self.qrView.frame = self.bounds;
    }
    if (_colorBgView) {
        [_colorBgView removeFromSuperview];
        _colorBgView = nil;
    }
    if (_qrModel.boarderImage) {
        self.boarderImage = _qrModel.boarderImage;
    }
    
    if (_qrModel.logo) {
        self.logo = _qrModel.logo;
    }
    if (_qrModel.colorModel) {
        self.colorBgView.type = _qrModel.colorModel.colortype;
        self.colorBgView.angle = _qrModel.colorModel.angle;
        self.colorBgView.colors = _qrModel.colorModel.colors;
        [self insertSubview:self.colorBgView belowSubview:self.qrView];
        
    }
    self.qrView.qrModel = _qrModel;

}
- (void)setQrModel:(QRModel *)qrModel {

    _qrModel = qrModel;
//    if (self.qrView.qrModel) {
//        self.qrView.qrModel = qrModel;
//    }
    [self.layer setNeedsDisplay];
}
- (void)setBoarderImage:(UIImage *)boarderImage {

    
    [self sendSubviewToBack:self.boarderImageView];
    //self.boarderImageView.backgroundColor = [UIColor greenColor];
    
    
    CGFloat width = self.frame.size.width;
    self.boarderImageView.image = boarderImage;
    [UIView animateWithDuration:0.3 animations:^{
      self.qrView.frame = CGRectMake(width * self.QRFrame.origin.x , width * self.QRFrame.origin.y, width * self.QRFrame.size.width, width * self.QRFrame.size.height);
      self.logoImageView.frame = CGRectMake(self.qrView.frame.origin.x + self.qrView.frame.size.width/2 - logoWidth/2, self.qrView.frame.origin.y + self.qrView.frame.size.height/2 - logoWidth/2, logoWidth, logoWidth);
    }];
    
    _boarderImage = boarderImage;
    self.backgroundColor = [UIColor blueColor];
}
- (void)setQRFrame:(CGRect)QRFrame {

    _QRFrame = QRFrame;
}
- (void)setLogo:(UIImage *)logo {
    if (!logo) {
        self.logoImageView.hidden = YES;
        return;
    }
    [self bringSubviewToFront:self.logoImageView];
    self.logoImageView.image = logo;
    self.logoImageView.center = self.qrView.center;
    self.logoImageView.frame = CGRectMake(self.qrView.frame.origin.x + self.qrView.frame.size.width/2 - logoWidth/2, self.qrView.frame.origin.y + self.qrView.frame.size.height/2 - logoWidth/2, logoWidth, logoWidth);
    self.logoImageView.hidden = NO;
    _logo = logo;
}

#pragma mark - 懒加载
- (DXQRView *)qrView {
    if (!_qrView) {
        _qrView = [[DXQRView alloc] initWithFrame:self.bounds];
        [self addSubview:_qrView];
    }
    return _qrView;
}
- (QRColorBgView *)colorBgView {

    if (!_colorBgView) {
        _colorBgView = [[QRColorBgView alloc] initWithFrame:self.bounds];
    }
    return _colorBgView;
}
- (UIImageView*)boarderImageView {

    if (!_boarderImageView) {
        _boarderImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _boarderImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_boarderImageView];
    }
    return _boarderImageView;
}
- (UIImageView *)logoImageView {

    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - logoWidth/2, self.frame.size.height/2 - logoWidth/2, logoWidth, logoWidth)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.layer.cornerRadius = 5;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _logoImageView.layer.borderWidth = 1;
        _logoImageView.hidden = YES;
        [self addSubview:_logoImageView];
    }
    return _logoImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
