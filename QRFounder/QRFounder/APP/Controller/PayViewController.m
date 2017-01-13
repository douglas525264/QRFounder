//
//  PayViewController.m
//  QRFounder
//
//  Created by douglas on 2016/12/19.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "PayViewController.h"
#import "DXHelper.h"
#import <RACEXTScope.h>
#import <ReactiveCocoa.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign)  NSInteger status;
@end

@implementation PayViewController
{
    NSInteger currentIndex;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    _status = 0;
    self.navigationItem.title = @"付款方式";
    self.fd_interactivePopDisabled = YES;
    // Do any additional setup after loading the view.
}
- (void)createUI{
    currentIndex = 0;
    self.view.backgroundColor = DefaultColor;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.borderWidth = 1;
    self.payBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.payItemTitleLable.text = self.name;
    self.payNumLable.text = [NSString stringWithFormat:@"￥%.2f",self.price];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    
}
- (void)back{
    if (self.status == 0) {
      [self.navigationController popViewControllerAnimated:YES];
    }
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndex = indexPath.row;
    [tableView reloadData];
}
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
    if (indexPath.row != currentIndex){
        cell.selectImageView.image = [UIImage imageNamed:@"selectNormalImage"];
    } else {
        cell.selectImageView.image = [UIImage imageNamed:@"selectedImage"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (IBAction)payBtnClick:(id)sender {
    _status = 1;
    @weakify(self)
    [[PayManager shareInstance] payFor:self.name body:self.name way:currentIndex==0 ?  kPTWeixinPay : kPTAlipay amount:0.01 callBack:^(CEPaymentStatus status) {
        self.status = 0;
        @strongify(self)
        if (self.statusBlock) {
            self.statusBlock(self.idStr,status);
        }
        switch (status) {
            case kCEPayResultSuccess:{
                NSLog(@"成功了");
                [self.payBtn setTitle:@"支付成功" forState:UIControlStateNormal];
                
            }break;
            case kCEPayResultFail:{
                NSLog(@"失败了");
            }break;
            case kCEPayResultCancel:{
                NSLog(@"取消了");
            }break;

                
            default:
                break;
        }
    }];
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
