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
//远程相关
- (void)getItemListWithFinishedBlock:(void (^)(BOOL isok,NSArray *arr)) block;
- (void)hasDownload:(NSString *)itemId;
- (void)deleteDownload:(NSString *)itemId;
- (NSArray *)getHasDownLoadItems;
@end
