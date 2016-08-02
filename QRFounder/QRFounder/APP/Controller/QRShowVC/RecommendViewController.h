//
//  RecommendViewController.h
//  QRFounder
//
//  Created by douglas on 16/8/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXCommenViewController.h"
#import "DXQRView.h"
@interface RecommendViewController : DXCommenViewController
@property (weak, nonatomic) IBOutlet DXQRView *qrView;
@property (weak, nonatomic) IBOutlet UILabel *alertLable;

@end
