//
//  DownloadTask.m
//  QRFounder
//
//  Created by douglas on 2017/2/15.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "DownloadTask.h"
#import <ZipArchive.h>
@interface DownloadTask()
@property (nonatomic, strong)NSURLSessionDataTask *downLoadSession;

@end

@implementation DownloadTask
{
    NSOutputStream *_FileWriteStream;
    int64_t  _totalSize;
    int64_t _currentBytes;
    uint8_t *buffer;
    int64_t _receivedDataLength;
    NSInteger _precent;
    BOOL isStart;
}
- (id)init {

    self = [super init];
    if (self) {
        _totalSize = 0;
        _progress = 0;
        isStart = NO;
        _currentBytes = 0;
        
    }
    return self;
}
- (void)start {
    if (!self.downLoadURL) {
        NSLog(@"download error with no URLStr");
        return;
    }
    self.status = TaskStatusWaiting;
    _FileWriteStream = [NSOutputStream outputStreamToFileAtPath:self.tempSavePath append:YES];
    
    [_FileWriteStream open];
    NSURL *url = [NSURL URLWithString:self.downLoadURL];
    NSMutableURLRequest * _downLoadRequest = [NSMutableURLRequest requestWithURL:url];
    if (_currentBytes > 0) {
        [_downLoadRequest addValue:[NSString stringWithFormat:@"bytes=%llu-", _currentBytes] forHTTPHeaderField:@"Range"];
    }
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession  *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    _downLoadSession = [session dataTaskWithRequest:_downLoadRequest];
    [self.downLoadSession resume];
    isStart = YES;
}

- (void)stop {
    if (self.downLoadSession) {
        [self.downLoadSession cancel];
    }
    if (_FileWriteStream) {
        [_FileWriteStream close];
    }
    isStart = NO;

}
#pragma mark -
#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"request header %@",httpResponse.allHeaderFields);
    if (httpResponse.allHeaderFields && [httpResponse.allHeaderFields objectForKey:@"Content-Length"]) {
        int64_t fileSize = [[httpResponse.allHeaderFields objectForKey:@"Content-Length"] longLongValue];
        if (_totalSize < fileSize) {
           
            _totalSize = fileSize;
        }
    }
    completionHandler(NSURLSessionResponseAllow);
    [self isFinishe];
    self.status = TaskStatusDownLoading;
    
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{

    [self WriteDataToFile:data];
}
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    self.status = TaskStatusError;
    [self stop];
}
- (void)isFinishe{
    if (_currentBytes == _totalSize) {
        [self performSelector:@selector(requestFinished) withObject:nil afterDelay:0.5];
        return;
    }
    
    
}
- (void)requestFinished{
    //先解压 在完成
    [self stop];
    
    self.status = TaskStatusUnziping;
    ZipArchive *za = [[ZipArchive alloc] init];
    
    if ([za UnzipOpenFile:self.tempSavePath])
    {
        
        NSArray *unzipFileList = [za getZipFileContents];
        
        NSString *unZipPath = self.filePath;
        
        BOOL ret = [za UnzipFileTo:unZipPath overWrite:YES];
        if (ret) {
            NSLog(@"解压成功");
        }
        
        [za UnzipCloseFile];
        NSFileManager *filemanager = [NSFileManager defaultManager];
        if ([filemanager fileExistsAtPath:self.tempSavePath]) {
            [filemanager removeItemAtPath:self.tempSavePath error:nil];
        }
       // [movData writeToFile:[[SourceManager shareManager] getOtherFolderPath] atomically:YES];
        
    }

    
    self.status = TaskStatusFinished;
    
    
}
- (void)WriteDataToFile:(NSData *) data
{
    
    
    if (data == nil || [data length] == 0 || _FileWriteStream == nil) {
        NSLog(@"%@-%s  Write data Fail",self.class,__FUNCTION__);
        return;
    }
    
    const unsigned char *buff = (const unsigned char*)data.bytes;
    
    if (data.length > 0) {
        @synchronized(self){
            [_FileWriteStream write:&buff[0]   maxLength:data.length];
            //        NSLog(@"WriteSuccess");
            _currentBytes += data.length;
           
            NSLog(@"totalSize:%lld  _currentSize:%lld",_totalSize,_currentBytes);
            NSInteger p = _currentBytes*100/_totalSize;
            
            if (p != _precent) {
                _precent = p;
                self.progress = _precent/100.0f;
                if ([_delegate respondsToSelector:@selector(downloadtask:progressCahnge:)]) {
                    [_delegate downloadtask:self progressCahnge:_currentBytes*1.0f/_totalSize];
                    
                }
            }
            if (_currentBytes >= _totalSize) {
                [self requestFinished];
            }
            
            
        }
    }
    
}

#pragma setter() gettter()
- (void)setStatus:(DownloadTaskStatus)status {
    if (_status == status) {
        return;
    }
    _status = status;
    if ([_delegate respondsToSelector:@selector(downloadtask:statusChange:)]) {
        [_delegate downloadtask:self statusChange:_status];
    }
}

@end
