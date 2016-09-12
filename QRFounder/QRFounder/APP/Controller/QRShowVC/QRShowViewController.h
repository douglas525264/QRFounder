//
//  QRShowViewController.h
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCommenQRView.h"
#import "DXCommenViewController.h"

@interface QRShowViewController : DXCommenViewController

@property (weak, nonatomic) IBOutlet DXCommenQRView *qrView;


@end
