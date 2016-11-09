//
//  DIYModel.h
//  QRFounder
//
//  Created by douglas on 2016/11/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DIYSubModel.h"
@interface DIYModel : NSObject

@property(nonatomic, strong) DIYSubModel *boarderModel;
@property(nonatomic, strong) NSArray *itemArrays;
@property(nonatomic, strong) UIColor *bgColor;
@property(nonatomic, assign) BOOL isChangeBlack;
@end
