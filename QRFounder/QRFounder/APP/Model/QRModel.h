//
//  QRModel.h
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DXCommenHelper.h"
@interface QRModel : NSObject<NSCopying>
//二维码字符串
@property (nonatomic, copy) NSString *QRStr;
//二维码背景
@property (nonatomic, strong) UIImage *bgImage;
//二维码显示显示位置
@property (nonatomic, assign) CGRect QRFrame;
//二维码板框图片
@property (nonatomic, strong) UIImage *boarderImage;
//二维码logo
@property (nonatomic, strong) UIImage *logo;
//二维码类型
@property (nonatomic, assign) QRType type;
//二维码颜色 实用此颜色后 默认背景色为白色 背景图片 失效 
@property (nonatomic, assign) UIColor *codeColor;


- (instancetype)initWithQrStr:(NSString *)qrStr;

@end
