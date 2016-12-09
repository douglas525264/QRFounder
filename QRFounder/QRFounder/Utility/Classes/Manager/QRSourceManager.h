//
//  QRSourceManager.h
//  QRFounder
//
//  Created by Douglas on 16/4/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXCommenHelper.h"
@interface QRSourceManager : NSObject
+ (QRSourceManager *)shareInstance;
- (NSArray *)getSoureceWithEditeType:(QREditType)type;
- (void)preloadSource;
@end
