//
//  APPStoreManager.h
//  QRFounder
//
//  Created by douglas on 2016/12/12.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef void (^buyStatusCallBackBloc)()
@interface APPStoreManager : NSObject

+ (APPStoreManager *)shareInstance;

- (void)buyProductByid:(NSString *)pid;
@end
