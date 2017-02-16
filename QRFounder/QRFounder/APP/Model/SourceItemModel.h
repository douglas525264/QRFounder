//
//  SourceItemModel.h
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"
@interface SourceItemModel : NSObject
@property (nonatomic, copy)NSString *sId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *desStr;
@property (nonatomic, copy)NSString *remoteUrl;
@property (nonatomic, copy)NSString *iconURL;
@property (nonatomic, assign) DownloadTaskStatus status;
- (void)configWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
@end
