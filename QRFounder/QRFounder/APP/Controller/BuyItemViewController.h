//
//  BuyItemViewController.h
//  QRFounder
//
//  Created by douglas on 2016/12/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXmenuItem.h"
#import "DXSubMenuItem.h"
@interface BuyItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (nonatomic, strong)DXmenuItem *sourceItem;

@end
