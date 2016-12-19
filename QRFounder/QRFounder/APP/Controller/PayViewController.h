//
//  PayViewController.h
//  QRFounder
//
//  Created by douglas on 2016/12/19.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayWayTableViewCell.h"
@interface PayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *payHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *payItemTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *payNumLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
