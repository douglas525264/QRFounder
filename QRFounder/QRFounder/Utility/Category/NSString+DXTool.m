//
//  NSString+DXTool.m
//  QRFounder
//
//  Created by douglas on 16/7/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NSString+DXTool.h"

@implementation NSString (DXTool)

+ (NSString *)getCurrentTime
{
    NSDate *currentDate = [NSDate date];
    //  NSTimeInterval a = [currentDate timeIntervalSince1970]*1000;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_hhmmss"];
    NSString *str = [formatter stringFromDate:currentDate];
    return [[str componentsSeparatedByString:@":"] componentsJoinedByString:@""];
}
+ (long long)getNormalTime {
    long long timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    return  timeInterval;
}
+ (NSString *)getNormalTimeStr {
    long long timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    return  [[NSNumber numberWithLongLong:timeInterval] stringValue];
    
}


@end
