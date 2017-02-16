//
//  DownloadManager.m
//  QRFounder
//
//  Created by douglas on 2017/2/15.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "DownloadManager.h"
static DownloadManager *dManager;
@interface DownloadManager()
@property (nonatomic, strong) NSMutableArray *runArr;
@end

@implementation DownloadManager

+ (DownloadManager *)shareInstance {
    if (!dManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dManager = [[DownloadManager alloc] init];
        });
    }
    return dManager;
}

- (void)addATask:(DownloadTask *)task {
    if (![self.runArr containsObject:task]) {
        [self.runArr addObject:task];
        task.delegate = self;
    }
}
- (void)startTaskWithId:(NSString *)taskID {
    for (DownloadTask *task in self.runArr) {
        if ([task.taskID isEqualToString:taskID]) {
            [task start];
        }
    }
}
#pragma mark -  DownloadTaskDelegate
- (void)downloadtask:(DownloadTask *)task statusChange:(DownloadTaskStatus)status {
    if (status == TaskStatusFinished) {
        //存储状态
        [self.runArr removeObject:task];
    }
    if ([_delegate respondsToSelector:@selector(downloadtask:statusChange:)]) {
        [_delegate downloadtask:task statusChange:status];
    }

}
- (void)downloadtask:(DownloadTask *)task progressCahnge:(CGFloat) progress {
    if ([_delegate respondsToSelector:@selector(downloadtask:progressCahnge:)]) {
        [_delegate downloadtask:task progressCahnge:progress];
        
    }

}
#pragma 懒加载
- (NSMutableArray *)runArr{

    if (!_runArr) {
        _runArr = [[NSMutableArray alloc] init];
    }
    return _runArr;
}
@end
