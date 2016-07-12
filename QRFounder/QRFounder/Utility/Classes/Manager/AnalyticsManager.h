//
//  AnalyticsManager.h
//  QRFounder
//
//  Created by douglas on 16/7/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UMMobClick/MobClick.h>
#import "DXCommenHelper.h"

@interface AnalyticsManager : NSObject
@property (nonatomic, assign) BOOL analyticsEnable;
+ (AnalyticsManager *)shareInstance;
- (void)startUMSDK;
/**
 *  统计登录次数
 */
- (void)loginEvent;

- (void)createQREvent;
- (void)createQREventWithType:(QRType)type;

- (void)scanQRCodeWithAlbumEvent;
- (void)scanQRCodeWithCameraEvent;
- (void)scanQREventWithType:(QRType)type;

@end
