//
//  DXQRScanView.h
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXQRScanView : UIView
@property (nonatomic, assign) CGRect ScanRect;

- (void)startAnimation;
- (void)stopAnimation;

@end
