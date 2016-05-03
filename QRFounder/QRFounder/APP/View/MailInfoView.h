//
//  MailInfoView.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommenInfoView.h"
#import "DXInputTextView.h"
@interface MailInfoView : CommenInfoView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabke;
@property (weak, nonatomic) IBOutlet DXInputTextView *mailTextView;
@property (weak, nonatomic) IBOutlet UITextField *mailTextFiled;

@end
