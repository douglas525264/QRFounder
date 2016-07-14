//
//  NSDictionary+DXHelper.m
//  QRFounder
//
//  Created by douglas on 16/7/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NSDictionary+DXHelper.h"

@implementation NSDictionary (DXHelper)
- (BOOL)hasKey:(id)key{
    if ([self objectForKey:key] != nil) {
        return YES;
    }
    return NO;
}

@end
