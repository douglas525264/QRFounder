//
//  MsgView.h
//  QRFounder
//
//  Created by douglas on 16/6/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXInputTextView.h"
@interface MsgView : UIView
@property (weak, nonatomic) IBOutlet UILabel *sendtoLable;
@property (weak, nonatomic) IBOutlet DXInputTextView *sendToTextView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet DXInputTextView *contentTextView;

@end
