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
                                  @"amount":[NSString stringWithFormat:@"%.2f",money],
                                  @"subject":subject,
                                  @"body":body,
                                  @"notify_url":@"http://10.100.140.124:8081/adapter-client/receive/notify.htm", };
    manager.payStatusCallBack = ^(CEPaymentStatus payStatus, NSString *result){
        if (block) {
            block(payStatus);
        }
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
