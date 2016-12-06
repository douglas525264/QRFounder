//
//  ADManager.h
//  QRFounder
//
//  Created by douglas on 2016/12/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ADType) {
    ADTypeBaidu,
    ADTypeTencent
};
@interface ADManager : NSObject
+ (ADManager *)shareInstance;
- (ADType)getAdType;
@end
