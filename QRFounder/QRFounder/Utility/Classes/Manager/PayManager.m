//
//  PayManager.m
//  QRFounder
//
//  Created by douglas on 2017/1/6.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "PayManager.h"
#import "WXApi.h"
#import "DXNetworkTool.h"
#import <CommonCrypto/CommonDigest.h>
static PayManager *pManager;
@interface PayManager()
@property (nonatomic, copy) NSString *currentPayOrder;
@property (nonatomic, assign) BOOL needScan;
@property (nonatomic, assign) NSInteger count;

@end
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
- (id) init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}
- (void)back{
    [self queryOrder];
}
- (NSString *)getFormatOrderId {
    return [self formatOrderId];
}
- (void)payFor:(NSString *)subject body:(NSString *)body way:(CEPayType)way amount:(CGFloat)money callBack:(void (^)(CEPaymentStatus status))block {
    _needScan = YES;
    self.callBack = block;
    _count = 3;
    [self performSelector:@selector(queryOrder) withObject:nil afterDelay:20];
    
    FuqianlaPay *manager = [FuqianlaPay sharedPayManager];
    [WXApi registerApp:@"wx03565949c4ef222b" withDescription:@"demo 2.0"];
    manager.showPayStatusView = NO;
    manager = [FuqianlaPay sharedPayManager];
    self.currentPayOrder = [self formatOrderId];
    manager.transactionParams = @{
                                  @"app_id":@"UOIcpKx4jipj1WM3Wn2Tjw", @"order_no":self.currentPayOrder,
                                  @"pmtTp":@(way),//     app
                                  @"amount":[NSString stringWithFormat:@"%.2f",money],
                                  @"subject":subject,
                                  @"body":body,
                                  @"notify_url":@"http://10.100.140.124:8081/adapter-client/receive/notify.htm", };
    

    manager.payStatusCallBack = ^(CEPaymentStatus payStatus, NSString *result){
        if (block) {
            if (payStatus  != kCEPayResultProcessing) {
                self.needScan = NO;
            }
            
            block(payStatus);
        }
    };


    [manager startPayAction];

}
- (NSString *)merchAppSign:(NSString *)sourceString {
    FuqianlaPay *manager = [FuqianlaPay sharedPayManager];
    
    NSString *signStr = nil;
    
    if([manager.signType isEqualToString:@"md5"])
    {
        NSMutableString *mstr = [sourceString mutableCopy];
        [mstr appendFormat:@"&key=%@",@"8BB418FCA8A480BC3E00365AE14148A2"];
        
        const char* str = [mstr UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(str,  (CC_LONG)strlen(str), result);
        NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
        
        for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
            [ret appendFormat:@"%02x",result[i]];
        }
       // manager.merchMd5Key = ret;
        signStr = ret;
    }
    return signStr;
    
}
- (void)queryOrder{
    
    if (self.needScan) {
        _count --;
        if (_count == 0) {
            return;
        }
        NSString *payStr = @"https://api.fuqian.la/services/order/singleQuery";
        NSDictionary *dir = @{@"app_id":@"UOIcpKx4jipj1WM3Wn2Tjw",@"charset":@"UTF-8",@"order_no":self.currentPayOrder,@"version":@"v2.1.1"};
        NSMutableString *muStr = [[NSMutableString alloc] init] ;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:dir.allKeys];
        [arr sortUsingComparator:^NSComparisonResult(NSString   *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        NSInteger i = 0;
        for (NSString *key in arr) {
            if (i == (arr.count - 1)) {
                [muStr appendFormat:@"%@=%@",key,dir[key]];
            } else {
                [muStr appendFormat:@"%@=%@&",key,dir[key]];
            }
            i ++;
        }
        NSString * sig = [self merchAppSign:muStr];
        NSMutableDictionary *dic  = [[NSMutableDictionary alloc] initWithDictionary:dir];
        [dic setValue:@"MD5" forKey:@"sign_type"];
        [dic setValue:sig forKey:@"sign_info"];
        [DXNetworkTool postWithPath:payStr postBody:dic andHttpHeader:nil completed:^(NSDictionary *json, NSString *stringdata, NSInteger code) {
            NSDictionary *retInfo = json[@"ret_data"];
            if (retInfo) {
                NSInteger st = [retInfo[@"status"] integerValue];
                if (st == 2) {
                    if (self.callBack) {
                        self.callBack(kCEPayResultSuccess);
                        self.needScan = NO;
                    }
                }
                if (st == 3) {
                    if (self.callBack) {
                        self.callBack(kCEPayResultFail);
                        self.needScan = NO;
                    }

                }
            }
        } failed:^(DXError *error) {
            
        }];
        
    }
    
}
-(NSString*)formatOrderId
{
    int kNumber = 13;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    
    return [NSString stringWithFormat:@"01%@",resultStr];
}

@end
