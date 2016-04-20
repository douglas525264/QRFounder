//
//  CardInfoTableViewCell.h
//  QRFounder
//
//  Created by douglas on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXInputTextView.h"
@interface CardInfoTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UITextField *editTextFiled;
@property (weak, nonatomic) IBOutlet DXInputTextView *inputView;

@end
