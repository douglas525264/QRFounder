//
//  DXSelectView.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXSelectView : UIView

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, copy) void (^selectedCallBackBlock)(NSInteger index);

- (id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr andIconArr:(NSArray *)iconArr;
- (void)show;
@end
