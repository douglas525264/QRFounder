//
//  DXSubMenuItem.h
//  QRFounder
//
//  Created by dongxin on 16/3/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface DXSubMenuItem : NSObject

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, copy) NSString *ImageName;
@property (nonatomic, assign) CGRect QRFrame;
//这里也可扩展命令类型

@end
