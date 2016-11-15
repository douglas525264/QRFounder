//
//  QRScanViewController.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXCommenViewController.h"

@interface QRScanViewController : DXCommenViewController
@property (nonatomic, assign) BOOL isScanning;
@property (nonatomic, assign) BOOL isShowAlbum;
@property (nonatomic, assign) BOOL isShowBack;
@property (nonatomic, copy) void (^scanBlock)(NSString *result);
@end
