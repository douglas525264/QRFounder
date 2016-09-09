//
//  RecommendViewController.m
//  QRFounder
//
//  Created by douglas on 16/8/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()

@end
@implementation RecommendViewController
- (void)awakeFromNib {

    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    QRModel *model = [[QRModel alloc] initWithQrStr: [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@",@"1152798225"]];
    self.qrView.qrModel = model;
    self.view.backgroundColor = RGB(0, 0, 0, 0.4);

    // Do any additional setup after loading the view.
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
