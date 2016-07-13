//
//  DXHelper.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <ATMHud.h>
#import "QRModel.h"
@interface DXHelper : NSObject
@property(nonatomic, strong)ATMHud *atmhud;
+ (id)shareInstance;
- (UIImage *)imageFromView:(UIView *)theView;


- (void)makeAlterWithTitle:(NSString *)title andIsShake:(BOOL)isShake;
- (void)makeAlterWithTitle:(NSString *)title dur:(CGFloat)dur andIsShake:(BOOL)isShake;
- (void)makeAlterWithTitle:(NSString *)title dur:(CGFloat)dur andIsShake:(BOOL)isShake inView:(UIView *)view;

- (void)saveImageWithModel:(QRModel *)model withFinishedBlock:(void (^)(BOOL isOK))finishedBlcok;

- (QRType)getTypeWithStr:(NSString *)QrStr;
- (NSMutableArray *)getparamtersWithQrstr:(NSString *)qrStr;
- (NSMutableDictionary *)getParamtersWithArr:(NSArray *)arr;
- (NSString *)getLocalNameWithKey:(NSString *)key;
- (UIImage *)getColorImageWithColor:(UIColor *)color andSize:(CGSize)size;
@end
