//
//  PayManager.h
//  QRFounder
//
//  Created by douglas on 2017/1/6.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FuqianlaPay+scheme.h"
@interface PayManager : NSObject
@property (nonatomic, copy) void (^callBack)(CEPaymentStatus status);

+(PayManager *)shareInstance;


- (NSString *)getFormatOrderId;
- (void)queryOrder;
- (void)payFor:(NSString *)subject body:(NSString *)body way:(CEPayType)way amount:(CGFloat)money callBack:(void (^)(CEPaymentStatus status))block;

@end
