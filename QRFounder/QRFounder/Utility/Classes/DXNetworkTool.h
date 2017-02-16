//
//  DXNetworkTool.h
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXError.h"
typedef void (^HttpCompletedBlock)(NSDictionary *json,NSString *stringdata,NSInteger code);
typedef void (^HttpFailedBlock)(DXError *error);
@interface DXNetworkTool : NSObject
+ (DXNetworkTool *)shareInstance;
+ (void)getWithPath:(NSString *)path completed:(HttpCompletedBlock)completeBlock failed:(HttpFailedBlock)failed;

/**
 *  一般的GET请求，有参数；
 *
 *  @param path          接口路径，不能为空；
 *  @param paramsDic     请求的参数的字典，参数可为nil, 例如：NSDictionary *params = @{@"key":@"value"}
 *  @param completeBlock 请求完成块，返回 id JSON, NSString *stringData;
 *  @param failed        请求失败块，返回 NSError *error;
 *
 *  @return 返回ASIHTTPRequest的指针，可用于 NSOperationQueue操作
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)paramsDic andHttpHeaders:(NSDictionary *)headerDir completed:(HttpCompletedBlock )completeBlock failed:(HttpFailedBlock )failed;

/**
 *  一般的POST请求，有参数；
 *
 *  @param path          接口路径，不能为空；
 *  @param paramsDic     请求的参数的字典，参数可为nil, 例如：NSDictionary *params = @{@"key":@"value"}
 *  @param completeBlock 请求完成块，返回 id JSON, NSString *stringData;
 *  @param failed        请求失败块，返回 NSError *error;
 *
 *  @return 返回ASIHTTPRequest的指针，可用于 NSOperationQueue操作
 
 */


+ (void)postWithPath:(NSString *)path postBody:(NSDictionary *)bodyData andHttpHeader:(NSDictionary *)headDic completed:(HttpCompletedBlock )completeBlock failed:(HttpFailedBlock )failed;
@end
