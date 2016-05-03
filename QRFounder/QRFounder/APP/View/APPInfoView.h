//
//  APPInfoView.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommenInfoView.h"
#import "DXInputTextView.h"
@interface APPInfoView : CommenInfoView
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UITextField *iOSInputTextFiled;
@property (weak, nonatomic) IBOutlet DXInputTextView *otherOSTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sControl;

@end
