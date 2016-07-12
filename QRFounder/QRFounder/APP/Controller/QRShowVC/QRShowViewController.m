
//
//  QRShowViewController.m
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QRShowViewController.h"
#import "QREditViewController.h"
#import "DXHelper.h"
@interface QRShowViewController ()

@end

@implementation QRShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    self.qrView.qrModel = _qrModel;
    UILongPressGestureRecognizer *lGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTab:)];
    [self.qrView addGestureRecognizer:lGes];
    // Do any additional setup after loading the view.
}

- (void)longTab:(UIGestureRecognizer *)ges {
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:{

            [[DXHelper shareInstance] saveImageWithModel:self.qrModel withFinishedBlock:^(BOOL isOK) {
                if (isOK) {
                    [[DXHelper shareInstance] makeAlterWithTitle:@"图片保存成功" andIsShake:YES];
 
                }
            }];
            }break;
            
        default:
            break;
    }
    
}
- (void)setQrModel:(QRModel *)qrModel {
    
    _qrModel = qrModel;
    self.qrView.qrModel = qrModel;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidAppear:animated];
    
}
- (IBAction)bgBtnClick:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    QREditViewController *qVC = [story instantiateViewControllerWithIdentifier:@"QREditViewController"];
    qVC.qrModel = [self.qrModel copy];
    qVC.editType = QREditTypeBg;
    [qVC setFinishedBlock:^(QRModel *model) {
        self.qrModel = model;
    }];
    [self presentViewController:qVC animated:YES completion:^{
        
    }];
}
- (IBAction)borderBtnClick:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    QREditViewController *qVC = [story instantiateViewControllerWithIdentifier:@"QREditViewController"];
    qVC.qrModel = [self.qrModel copy];
    qVC.editType = QREditTypeBoarder;
    [qVC setFinishedBlock:^(QRModel *model) {
        self.qrModel = model;
    }];
    [self presentViewController:qVC animated:YES completion:^{
        
    }];

}
- (IBAction)logoBtnClick:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    QREditViewController *qVC = [story instantiateViewControllerWithIdentifier:@"QREditViewController"];
    qVC.qrModel = [self.qrModel copy];
    qVC.editType = QREditTypeLogo;
    [qVC setFinishedBlock:^(QRModel *model) {
        self.qrModel = model;
    }];
  //  qVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:qVC animated:YES completion:^{
        
    }];

}
- (IBAction)colorBtnClick:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    QREditViewController *qVC = [story instantiateViewControllerWithIdentifier:@"QREditViewController"];
    qVC.qrModel = [self.qrModel copy];
    qVC.editType = QREditTypeColor;
    [qVC setFinishedBlock:^(QRModel *model) {
        self.qrModel = model;
    }];
    [self presentViewController:qVC animated:YES completion:^{
        
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