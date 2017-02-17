//
//  SourceItemModel.m
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "SourceItemModel.h"
#import "DownloadTask.h"
@implementation SourceItemModel
- (void)configWithJson:(NSDictionary *)json {
    self.sId = json[@"id"];
    self.name = json[@"name"];
    self.desStr = json[@"des"];
    self.remoteUrl = json[@"sourcepath"];
    self.iconURL = json[@"thumurl"];
    self.progress = 0;
}
- (NSDictionary *)toJson {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.sId forKey:@"id"];
    [dic setValue:self.name forKey:@"name"];
    [dic setValue:self.desStr forKey:@"des"];
    [dic setValue:self.remoteUrl forKey:@"sourcepath"];
    [dic setValue:self.iconURL forKey:@"thumurl"];

  
    return  dic;
}
@end
