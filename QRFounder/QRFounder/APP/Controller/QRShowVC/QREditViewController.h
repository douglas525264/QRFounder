//
//  QREditViewController.h
//  QRFounder
//
//  Created by dongxin on 16/3/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCommenHelper.h"

#import "DXCommenQRView.h"
#import "DXCommenViewController.h"
@interface QREditViewController : DXCommenViewController
@property (weak, nonatomic) IBOutlet DXCommenQRView *qrView;

@property (nonatomic, assign) QREditType editType;


@property (nonatomic, copy) void (^finishedBlock)(QRModel *model);


@end
