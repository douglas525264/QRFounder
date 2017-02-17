//
//  QRSourceManager.h
//  QRFounder
//
//  Created by Douglas on 16/4/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXCommenHelper.h"
#import <ReactiveCocoa.h>
@interface QRSourceManager : NSObject
@property (nonatomic, strong)RACSubject *rac_qrSourceChangeSingle;
+ (QRSourceManager *)shareInstance;
- (NSArray *)getSoureceWithEditeType:(QREditType)type;
- (void)preloadSource;
//远程相关
- (void)getItemListwithtype:(QREditType)type withFinishedBlock:(void (^)(BOOL isok,NSArray *arr)) block;
- (void)hasDownload:(NSString *)itemId;
- (void)deleteDownload:(NSString *)itemId withtype:(QREditType)type;
- (NSArray *)getHasDownLoadItemsWithtype:(QREditType)type;
//local manager
- (void)createDir;
+ (NSString *)getInboxPath;
+ (NSString *)getDIYPath;
+ (NSString *)getBGPath;
+ (NSString *)getLogoPath;
+ (NSString *)getBorderPath;
+ (NSString *)getTempSavapath;
@end
