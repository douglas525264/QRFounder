//
//  DIYSubModel.h
//  QRFounder
//
//  Created by douglas on 2016/11/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DIYSubModel : NSObject
//图片
@property(nonatomic, strong) UIImage *image;
//图片路径
@property(nonatomic, strong) NSString *imagePath;
//图片站位大小
@property(nonatomic, assign) CGSize size;
//出现频率
@property(nonatomic, assign) CGFloat probability;
//计算属性 返回size乘积
@property(nonatomic, assign) NSInteger sizeCount;
@end
