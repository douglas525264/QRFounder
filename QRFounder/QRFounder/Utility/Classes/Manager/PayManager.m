//
//  PayManager.m
//  QRFounder
//
//  Created by douglas on 2017/1/6.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "PayManager.h"
#import "WXApi.h"
static PayManager *pManager;
@implementation PayManager
+(PayManager *)shareInstance {

    if (!pManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            pManager = [[PayManager alloc] init];
        });
    }
    return pManager;
}

- (NSString *)getFormatOrderId {
    return [self formatOrderId];
}
- (void)payFor:(NSString *)subject body:(NSString *)body way:(CEPayType)way amount:(CGFloat)money callBack:(void (^)(CEPaymentStatus status))block {
    FuqianlaPay *manager = [FuqianlaPay sharedPayManager];
    [WXApi registerApp:@"wx03565949c4ef222b" withDescription:@"demo 2.0"];
    manager.showPayStatusView = NO;

    manager.transactionParams = @{
                                  @"app_id":@"UOIcpKx4jipj1WM3Wn2Tjw", @"order_no":[self formatOrderId],
                                  @"pmtTp":@(way),//     app
                                  @"amount":@"0.01",
                                  @"subject":subject,
                                  @"body":body,
                                  @"notify_url":@"http://10.100.140.124:8081/adapter-client/receive/notify.htm", };
    manager.payStatusCallBack = ^(CEPaymentStatus payStatus, NSString *result){
        //如果京东支付切支付成功，保存京东支付token，以便下一次快捷支付
        if(manager.payType == kPTJDPay && payStatus == kCEPayResultSuccess)
        {
            id token = [FuqianlaPay sharedPayManager].callCackParams;
            NSLog(@"%@", token);
        }
        if (payStatus == kCEPayResultSuccess) {
            NSLog(@"支付成功");
        }
        NSLog(@"%@", result);
    };
    
    [manager startPayAction];

}
-(NSString*)formatOrderId
{
    int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    
    return resultStr;
}

@end
