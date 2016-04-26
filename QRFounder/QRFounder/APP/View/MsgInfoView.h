//
//  MsgInfoView.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommenInfoView.h"
#import "DXInputTextView.h"
@interface MsgInfoView : CommenInfoView

@property (weak, nonatomic) IBOutlet DXInputTextView *sendToTextView;
@property (weak, nonatomic) IBOutlet DXInputTextView *contentTextView;

@end
