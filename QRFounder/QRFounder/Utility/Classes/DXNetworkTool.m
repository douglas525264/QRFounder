//
//  DXNetworkTool.m
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "DXNetworkTool.h"
#import <AFNetworking.h>
@implementation DXNetworkTool
+ (DXNetworkTool *)shareInstance{
    static DXNetworkTool *httpRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpRequest = [[DXNetworkTool alloc]init];
    });
    return httpRequest;
}
+ (void)getWithPath:(NSString *)path completed:(HttpCompletedBlock)completeBlock failed:(HttpFailedBlock)failed{
    [self getWithPath:path params:nil andHttpHeaders:nil completed:completeBlock failed:failed];
}
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)paramsDic andHttpHeaders:(NSDictionary *)headerDir completed:(HttpCompletedBlock )completeBlock failed:(HttpFailedBlock )failed{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:1];
    
    manager.requestSerializer              = [AFJSONRequestSerializer serializer];
    manager.responseSerializer             = [AFHTTPResponseSerializer serializer];
    //设置后台头部
    
    [headerDir enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    [manager GET:path parameters:paramsDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (resp ) {
            NSInteger code = 0;
            if (resp[@"code"]) {
                NSNumber *cc = resp[@"code"];
                code = cc.integerValue;
            }
            NSString *msg =  resp[@"msg"];
            if (code == 200) {
                NSDictionary *info = resp[@"json"];
                completeBlock(info,msg,code);
            } else {
                DXError *error = [[DXError alloc] init];
                error.code = code;
                failed(error);
            }
        } else {
            DXError *error1 = [[DXError alloc] init];
            error1.code = 404;
            
            failed(error1);

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DXError *error1 = [[DXError alloc] init];
        error1.code = 404;
        error1.desStr = error.debugDescription;
        failed(error1);

    }];
}
+ (void)postWithPath:(NSString *)path postBody:(NSDictionary *)bodyData andHttpHeader:(NSDictionary *)headDic completed:(HttpCompletedBlock )completeBlock failed:(HttpFailedBlock )failed{
    
    
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:1];
    
    manager.requestSerializer              = [AFJSONRequestSerializer serializer];
    manager.responseSerializer             = [AFHTTPResponseSerializer serializer];
    //设置后台头部
    
    [headDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [manager POST:path parameters:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (resp ) {
            NSInteger code = 0;
            if (resp[@"code"]) {
                NSNumber *cc = resp[@"code"];
                code = cc.integerValue;
            }
            NSString *msg =  resp[@"msg"];
            if (code == 200) {
                
                completeBlock(resp,msg,code);
            } else {
                DXError *error = [[DXError alloc] init];
                error.code = code;
                failed(error);
            }
        } else {
            DXError *error1 = [[DXError alloc] init];
            error1.code = 404;
            
            failed(error1);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DXError *error1 = [[DXError alloc] init];
        error1.code = 404;
        error1.desStr = error.debugDescription;
        failed(error1);
    }];
}
@end
