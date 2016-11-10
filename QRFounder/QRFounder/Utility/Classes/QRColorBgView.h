//
//  QRColorBgView.h
//  LayerTest
//
//  Created by Douglas on 16/11/10.
//  Copyright © 2016年 Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,BgColorType) {
    //圆形背景
    BgColorTypeRound,
    //渐变
    BgColorTypegradual,
    //直线模式
    BgColorTypeLine
    
};
@interface QRColorBgView : UIView
//旋转角度
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, strong) NSArray<UIColor *> *colors;

@property (nonatomic, assign) BgColorType type;
@end
