//
//  DIYModel.m
//  QRFounder
//
//  Created by douglas on 2016/11/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DIYModel.h"

@implementation DIYModel
- (UIColor *)bgColor {

    if (!_bgColor) {
        _bgColor = [UIColor whiteColor];
    }
    return _bgColor;
}
@end
