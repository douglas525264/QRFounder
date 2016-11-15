//
//  TextInfoView.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommenInfoView.h"
#import "DXInputTextView.h"
#import <ReactiveCocoa.h>
@interface TextInfoView : CommenInfoView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet DXInputTextView *textInfoTextView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, copy) void(^commendCallBlock)(NSInteger index);
@end
