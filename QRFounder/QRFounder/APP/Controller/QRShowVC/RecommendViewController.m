//
//  RecommendViewController.m
//  QRFounder
//
//  Created by douglas on 16/8/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RecommendViewController.h"
#import "ShareManager.h"
#import "DXHelper.h"
@interface RecommendViewController ()

@end
@implementation RecommendViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //com.onlybeyond.QRcode
    QRModel *model = [[QRModel alloc] initWithQrStr:[NSString stringWithFormat:appUrl,@"com.onlybeyond.QRcode",@"1152798225"]];
    
    model.logo = [UIImage imageNamed:@"appIcon_180"];
    
    self.qrView.qrModel = model;
    
    self.view.backgroundColor = RGB(0, 0, 0, 0.4);

    // Do any additional setup after loading the view.
}
- (IBAction)shareBtnClick:(id)sender {
    //UIImage *image = [[DXHelper shareInstance] normalImageFromView:self.qrView];
   // [[ShareManager shareInstance] shareQrimage:image withView:IS_IPAD ? self.qrView : nil];
    NSString *appID = @"1152798225";
#if QRFounderPRO
    appID = @"1185233985";
#else
    
#endif
    [[ShareManager shareInstance] shareURL:[NSString stringWithFormat:appUrl,@"com.onlybeyond.QRcode",appID] withTitle:@"个性二维码" des:@"一款为您打造专属二维码的APP" andView:IS_IPAD ? self.qrView : nil];
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
