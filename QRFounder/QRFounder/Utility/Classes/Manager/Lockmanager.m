//
//  Lockmanager.m
//  QRFounder
//
//  Created by douglas on 2016/12/13.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "Lockmanager.h"

@interface Lockmanager()

@property (nonatomic, strong) NSMutableDictionary *lockInfoDic;
@end
static Lockmanager *lmanager;
@implementation Lockmanager

+ (Lockmanager *)shareInstance {
    
    if (!lmanager) {
        lmanager = [[Lockmanager alloc] init];
    }
    return lmanager;
}
- (void)unlock:(NSString *)itemId atIndex:(NSInteger)index {
    @synchronized (self) {
        NSMutableArray *unlockarr;
        NSArray *temp = [self.lockInfoDic valueForKey:itemId];
        
        if (temp) {
            unlockarr = [[NSMutableArray alloc] initWithArray:temp];
        } else {
            unlockarr = [NSMutableArray array];
        }
        [unlockarr addObject:@(index)];
        [self.lockInfoDic setValue:unlockarr forKey:itemId];
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        [de setValue:self.lockInfoDic forKey:@"lockInfo"];
        [de synchronize];
 
    }
    
}
- (void)unlock:(NSString *)itemId atIndexs:(NSArray *)arr {

    @synchronized (self) {
        NSMutableArray *unlockarr;
        NSArray *temp = [self.lockInfoDic valueForKey:itemId];
        
        if (temp) {
            unlockarr = [[NSMutableArray alloc] initWithArray:temp];
        } else {
            unlockarr = [NSMutableArray array];
        }

        for (NSNumber *ind in arr) {
            NSInteger index = ind.integerValue;
            [unlockarr addObject:@(index)];
 
        }
        [self.lockInfoDic setValue:unlockarr forKey:itemId];
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];

        [de setValue:self.lockInfoDic forKey:@"lockInfo"];
        [de synchronize];

    }

}
- (BOOL)hasunlock:(NSString *)itemid atindex:(NSInteger)index {
    NSArray *temArr = [self.lockInfoDic valueForKey:itemid];
    if (temArr) {
        for (NSNumber *aa in temArr) {
            if (aa.integerValue == index) {
                return YES;
            }
        }
    }
    return NO;
}
- (NSMutableDictionary *)lockInfoDic {

    if (!_lockInfoDic) {
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [de objectForKey:@"lockInfo"];
        if (dic) {
           _lockInfoDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        }else {
            _lockInfoDic = [[NSMutableDictionary alloc] init];
        }
        
    }
    return _lockInfoDic;
}
@end
