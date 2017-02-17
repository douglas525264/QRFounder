//
//  DownloadTask.h
//  QRFounder
//
//  Created by douglas on 2017/2/15.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DXCommenHelper.h"

@class DownloadTask;

@protocol DownloadTaskDelegate <NSObject>

@optional

- (void)downloadtask:(DownloadTask *)task statusChange:(DownloadTaskStatus)status;
- (void)downloadtask:(DownloadTask *)task progressCahnge:(CGFloat) progress;

@end
@interface DownloadTask : NSObject<NSURLSessionDataDelegate,NSURLSessionDelegate>
@property (nonatomic, copy)NSString *taskID;
@property (nonatomic, copy)NSString *downLoadURL;
@property (nonatomic, copy)NSString *tempSavePath;
@property (nonatomic, copy)NSString *filePath;
@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, weak) id<DownloadTaskDelegate> delegate;
@property (nonatomic, assign) DownloadTaskStatus status;

- (void)start;
- (void)stop;

@end
