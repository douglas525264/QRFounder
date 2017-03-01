//
//  DmEncryptionMath.h
//  zapya
//
//  Created by LiuFei on 4/20/15.
//  Copyright (c) 2015 dewmobile.net. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DmEncryptionMath : NSObject
+ (NSString *)MD5HexDigest:(NSString*)inPutStr;
+ (NSString *)shaEncryption:(NSString *)str;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)dateString;
@end
