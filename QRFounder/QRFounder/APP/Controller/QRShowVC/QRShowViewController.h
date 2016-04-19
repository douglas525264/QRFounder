//
//  QRShowViewController.h
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCommenQRView.h"
#import "QRModel.h"
@interface QRShowViewController : UIViewController

@property (weak, nonatomic) IBOutlet DXCommenQRView *qrView;
@property (nonatomic, strong) QRModel *qrModel;

@end
