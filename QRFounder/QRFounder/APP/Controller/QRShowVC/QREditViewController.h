//
//  QREditViewController.h
//  QRFounder
//
//  Created by dongxin on 16/3/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCommenHelper.h"
#import "QRModel.h"
#import "DXCommenQRView.h"
@interface QREditViewController : UIViewController
@property (weak, nonatomic) IBOutlet DXCommenQRView *qrView;

@property (nonatomic, strong) QRModel *qrModel;

@property (nonatomic, assign) QREditType editType;


@property (nonatomic, copy) void (^finishedBlock)(QRModel *model);


@end
