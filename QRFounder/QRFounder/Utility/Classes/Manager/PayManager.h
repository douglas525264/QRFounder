//
//  PayManager.h
//  QRFounder
//
//  Created by douglas on 2017/1/6.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FuqianlaPay.h"
@interface PayManager : NSObject


+(PayManager *)shareInstance;


- (NSString *)getFormatOrderId;

- (void)payFor:(NSString *)subject body:(NSString *)body way:(CEPayType)way amount:(CGFloat)money;

@end
