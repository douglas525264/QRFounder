//
//  ColorModel.h
//  QRFounder
//
//  Created by Douglas on 16/11/10.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QRColorBgView.h"
@interface ColorModel : NSObject
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) BgColorType colortype;
//旋转角度
@property (nonatomic, assign) CGFloat angle;
@end
