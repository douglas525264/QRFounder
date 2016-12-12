//
//  APPStoreManager.m
//  QRFounder
//
//  Created by douglas on 2016/12/12.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "APPStoreManager.h"
#import <StoreKit/StoreKit.h>
static APPStoreManager *apManager;
@interface APPStoreManager()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (nonatomic, copy) NSString *currentProId;
@property (nonatomic, copy) buyStatusCallBackBlock staBlock;
@end
@implementation APPStoreManager
+ (APPStoreManager *)shareInstance {

    if (!apManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
          apManager = [[APPStoreManager alloc] init];  
        });
        
    }
    return apManager;
}
- (void)buyProductByid:(NSString *)pid withStatusBlock:(buyStatusCallBackBlock)status{
    self.staBlock = status;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
   
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:pid];
        if (self.staBlock) {
            self.staBlock(buyStatusBuying);
        }

    }else{
        NSLog(@"不允许程序内付费");
    }

}
//去苹果服务器请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    
   
    self.currentProId = type;
    NSArray *product = [[NSArray alloc] initWithObjects:type,type,nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
       
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_currentProId]){
            p = pro;
        }
    }
    if (p) {
        SKPayment *payment = [SKPayment paymentWithProduct:p];
        
        NSLog(@"发送购买请求");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
  
    } else {
        if (self.staBlock) {
            self.staBlock(buyStatusFauiler);
        }

    }
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
   
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
 
    NSLog(@"------------反馈信息结束-----------------");
}
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");
        
        if (self.staBlock) {
            self.staBlock(buyStatusSuccess);
        }
        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
        if ([productIdentifier isEqualToString:@"123"]) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
        }else{
            [defaults setBool:YES forKey:productIdentifier];
        }
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
    }else{
        NSLog(@"购买失败，未通过验证！");
        if (self.staBlock) {
            self.staBlock(buyStatusFauiler);
        }

    }
}
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"交易完成");
                // 发送到苹果服务器验证凭证
                [self verifyPurchaseWithPaymentTransaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"已经购买过商品");
                if (self.staBlock) {
                    self.staBlock(buyStatusSuccess);
                }
 
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败");
                if (self.staBlock) {
                    self.staBlock(buyStatusFauiler);
                }

                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
               
            }
                break;
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
@end
