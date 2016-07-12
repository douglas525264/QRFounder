//
//  AnalyticsManager.m
//  QRFounder
//
//  Created by douglas on 16/7/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "AnalyticsManager.h"
static AnalyticsManager *aManager;
#define UMKEY @"57833c7f67e58e11620000ff"

@implementation AnalyticsManager
+ (AnalyticsManager *)shareInstance {

    if (!aManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            aManager = [[AnalyticsManager alloc] init];
        });
    }
    return aManager;
}
- (void)startUMSDK {
    UMConfigInstance.appKey = @"57833c7f67e58e11620000ff";
    UMConfigInstance.channelId = @"App Store";
   // UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [self loginEvent];
}
/**
 *  统计登录次数
 */
- (void)loginEvent {
    [MobClick event:@"qr_login"];
}

- (void)createQREvent {
    [MobClick event:@"qr_create"];
}
- (void)createQREventWithType:(QRType)type {
    [self createQREvent];
    switch (type) {
        case QRTypeMyCard:{
            [MobClick event:@"qr_create_mycard"];
        }break;
        case QRTypeAPP:{
            [MobClick event:@"qr_create_app"];
        }break;
        case QRTypeHTTP:{
             [MobClick event:@"qr_create_web"];
        }break;
        case QRTypeMsg:{
             [MobClick event:@"qr_create_msg"];
        }break;
        case QRTypeMail:{
             [MobClick event:@"qr_create_mail"];
        }break;
        case QRTypeWIFI:{
             [MobClick event:@"qr_create_wif"];
        }break;
        case QRTypeText:{
             [MobClick event:@"qr_create_text"];
        }break;
            
        default:
            break;
    }
   
}

- (void)scanQRCodeWithAlbumEvent {
    [MobClick event:@"qr_scan_album"];
}
- (void)scanQRCodeWithCameraEvent {
    [MobClick event:@"qr_scan_camera"];
}
- (void)scanQREventWithType:(QRType)type {
    [MobClick event:@"qr_scan"];
}



@end
