//
//  WIFIInfoView.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommenInfoView.h"
#import "DXInputTextView.h"
//用于输入
@interface WIFIInfoView : CommenInfoView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *wifiNameLable;

@property (weak, nonatomic) IBOutlet UILabel *pswLable;
@property (weak, nonatomic) IBOutlet DXInputTextView *wifiNameTextView;
@property (weak, nonatomic) IBOutlet DXInputTextView *pswTextView;
@property (weak, nonatomic) IBOutlet UIView *pswBgView;

@property (weak, nonatomic) IBOutlet UIButton *WAPBtn;
@property (weak, nonatomic) IBOutlet UIButton *WEPBtn;
@property (weak, nonatomic) IBOutlet UIButton *NOPSWBTN;

@end
