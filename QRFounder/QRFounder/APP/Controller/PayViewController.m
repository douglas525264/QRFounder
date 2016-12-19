//
//  PayViewController.m
//  QRFounder
//
//  Created by douglas on 2016/12/19.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "PayViewController.h"
#import "DXHelper.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PayViewController
{
    NSInteger currentIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    currentIndex = 0;
    self.view.backgroundColor = DefaultColor;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PayWayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PayWayTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.borderWidth = 1;
    self.payBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PayWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayWayTableViewCell"];
    switch (indexPath.row) {
        case 0:{
            cell.iconImageView.image = [UIImage imageNamed:@"绿色logo"];
            cell.titleLable.text = @"微信支付";
            cell.desLable.text = @"亿万用户选择,更快更安全";
            
        }break;
        case 1:{
            cell.iconImageView.image = [UIImage imageNamed:@"paybaoIcon"];
            cell.titleLable.text = @"支付宝支付";
            cell.desLable.text = @"支付宝支付";

        }break;
            
        default:
            break;
    }
    if (indexPath.row == currentIndex){
        cell.selectImageView.image = [UIImage imageNamed:@"selectNormalImage"];
    } else {
        cell.selectImageView.image = [UIImage imageNamed:@"selectedImage"];
    }
    return cell;
}
- (IBAction)payBtnClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
