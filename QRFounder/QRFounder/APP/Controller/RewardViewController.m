//
//  RewardViewController.m
//  QRFounder
//
//  Created by Douglas on 2017/2/21.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "RewardViewController.h"
#import "DXHelper.h"
#import "PayViewController.h"
#import <RACEXTScope.h>
@interface RewardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;
@property (weak, nonatomic) IBOutlet UIButton *payOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *payTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *payThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *payfourBtn;
@property (weak, nonatomic) IBOutlet UIButton *payFiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *paySixBtn;

@end

@implementation RewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    NSArray *arr = @[self.rewardBtn,self.payOneBtn,self.payTwoBtn,self.payThreeBtn,self.payfourBtn,self.payFiveBtn,self.paySixBtn];
    for (UIButton *btn in arr) {
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.numTextFiled becomeFirstResponder];
    }
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 44, 22);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //[leftbtn setImage:[UIImage imageNamed:@"lightIcon"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];

    // Do any additional setup after loading the view.
}
- (void)cancelBtnClick:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.numTextFiled resignFirstResponder];
}
- (IBAction)rwardClick:(id)sender {
    NSString *text = self.numTextFiled.text;
    if (text && text.length > 0) {
        [self rewardWithNum:text.floatValue];
    }
}
- (IBAction)payBtnClick:(UIButton *)sender {
    [self rewardWithNum:sender.tag];
}
- (void)rewardWithNum:(CGFloat)price {
    PayViewController *pvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PayViewController"];
    pvc.name = @"打赏";
    pvc.price = [[NSString stringWithFormat:@"%.2f",price] floatValue];
    pvc.idStr = @"10000";
    pvc.desStr = @"感谢您的大力支持";
    @weakify(self)
    [pvc setStatusBlock:^(NSString *idstr, CEPaymentStatus st) {
        @strongify(self)
        
        [self cancelBtnClick:nil];
        [[DXHelper shareInstance] makeAlterWithTitle:@"打赏成功" andIsShake:NO];
    }];
    [self.navigationController pushViewController:pvc animated:YES];

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
