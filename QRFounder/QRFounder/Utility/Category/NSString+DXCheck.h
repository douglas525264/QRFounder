//
//  NSString+DXCheck.h
//  QRFounder
//
//  Created by douglas on 16/5/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DXCheck)
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validateMobile:(NSString *)mobile;
@end
