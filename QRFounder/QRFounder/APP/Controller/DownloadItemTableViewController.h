//
//  DownloadItemTableViewController.h
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCommenHelper.h"
@interface DownloadItemTableViewController : UITableViewController
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, assign) QREditType type;
@property (nonatomic, copy) void (^deleteCallBack)(NSString *sid);
@end
