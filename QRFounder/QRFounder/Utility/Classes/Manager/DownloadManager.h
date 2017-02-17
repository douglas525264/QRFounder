//
//  DownloadManager.h
//  QRFounder
//
//  Created by douglas on 2017/2/15.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"
@interface DownloadManager : NSObject<DownloadTaskDelegate>
@property (nonatomic, weak) id<DownloadTaskDelegate> delegate;

+ (DownloadManager *)shareInstance;

- (void)addATask:(DownloadTask *)task;
- (void)startTaskWithId:(NSString *)taskID;
@end
