//
//  Lockmanager.h
//  QRFounder
//
//  Created by douglas on 2016/12/13.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
@interface Lockmanager : NSObject
@property (nonatomic, strong)RACSubject *rac_LockStatusChangeSingle;
+ (Lockmanager *)shareInstance;

- (void)unlock:(NSString *)itemId atIndex:(NSInteger)index;
- (void)unlock:(NSString *)itemId atIndexs:(NSArray *)arr;
- (BOOL)hasunlock:(NSString *)itemid atindex:(NSInteger)index;

@end
