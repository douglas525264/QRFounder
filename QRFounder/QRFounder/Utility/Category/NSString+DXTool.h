//
//  NSString+DXTool.h
//  QRFounder
//
//  Created by douglas on 16/7/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DXTool)
/**
 *  获取当前时间戳
 */
+ (NSString *)getCurrentTime;
+ (long long)getNormalTime;
+ (NSString *)getNormalTimeStr;
@end
