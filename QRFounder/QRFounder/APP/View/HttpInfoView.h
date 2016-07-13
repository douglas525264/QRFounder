//
//  HttpInfoView.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommenInfoView.h"
#import "DXInputTextView.h"
@interface HttpInfoView : CommenInfoView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet DXInputTextView *infoTextView;

@end
