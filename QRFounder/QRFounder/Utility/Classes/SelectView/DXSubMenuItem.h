//
//  DXSubMenuItem.h
//  QRFounder
//
//  Created by dongxin on 16/3/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DIYModel.h"
#import <UIKit/UIKit.h>
#import "ColorModel.h"
@interface DXSubMenuItem : NSObject

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, copy) NSString *ImageName;
@property (nonatomic, assign) CGRect QRFrame;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) BOOL isLock;
//这里也可扩展命令类型
@property (nonatomic, strong) DIYModel *diyModel;
@property (nonatomic, strong) ColorModel *colorModel;
@end
