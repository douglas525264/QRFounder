//
//  DXError.m
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "DXError.h"

@implementation DXError
- (NSString *)desStr {
    if (!_desStr) {
        _desStr= @"哈哈，出错啦";
    }
    return _desStr;
}
@end
