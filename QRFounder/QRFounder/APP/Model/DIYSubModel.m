//
//  DIYSubModel.m
//  QRFounder
//
//  Created by douglas on 2016/11/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DIYSubModel.h"

@implementation DIYSubModel
- (NSInteger)sizeCount {
    
    if (self.size.width > 0) {
        return _size.width * _size.height;
    }
    return 0;
}
@end
