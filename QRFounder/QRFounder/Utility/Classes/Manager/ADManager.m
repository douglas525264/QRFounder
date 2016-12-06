//
//  ADManager.m
//  QRFounder
//
//  Created by douglas on 2016/12/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ADManager.h"
static ADManager *amanager;
@implementation ADManager
+ (ADManager *)shareInstance {
    if (!amanager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            amanager = [[ADManager alloc] init];
        });
    }
    return amanager;

}
- (ADType)getAdType {
    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    if ([de valueForKey:@"showADType"]) {
        NSInteger type = [[de valueForKey:@"showADType"] integerValue];
        switch (type) {
            case ADTypeBaidu:
            case ADTypeTencent:
                return  type;
                break;
            default:
                return ADTypeBaidu;
                break;
        }
    }
    return ADTypeBaidu;
}
@end
