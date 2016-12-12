//
//  APPStoreManager.h
//  QRFounder
//
//  Created by douglas on 2016/12/12.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, BuyStatus)  {
    //购买成功
    buyStatusSuccess,
    //购买中...
    buyStatusBuying,
    //购买失败
    buyStatusFauiler
};
typedef void (^buyStatusCallBackBlock)(BuyStatus status);
@interface APPStoreManager : NSObject

+ (APPStoreManager *)shareInstance;

- (void)buyProductByid:(NSString *)pid withStatusBlock:(buyStatusCallBackBlock)status;
@end
