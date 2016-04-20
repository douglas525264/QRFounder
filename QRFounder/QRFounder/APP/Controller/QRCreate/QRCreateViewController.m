//
//  QRCreateViewController.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QRCreateViewController.h"
#import "DXSelectView.h"
#import "DXCommenHelper.h"
#import "CommenInfoView.h"
#import "APPInfoView.h"
#import "MyCardInfoView.h"
#import "MsgInfoView.h"
#import "MailInfoView.h"
#import "HttpInfoView.h"
#import "TextInfoView.h"
#import "PositionInfoView.h"
#import "WIFIInfoView.h"
#import "QRModel.h"
#import "QRShowViewController.h"
#define createBtnWidth 120
@interface QRCreateViewController ()
@property (nonatomic, strong)DXSelectView *selectView;
@property (nonatomic, strong)CommenInfoView *currentInfoView;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong)UIButton *createBtn;
@end

@implementation QRCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)createUI{
    self.view.backgroundColor = RGB(33,188,225,1);
    self.navigationItem.title = @"生成二维码";
    
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"qrcreate_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultColor} forState:UIControlStateSelected];
    
    //侧边栏
    [self.view addSubview:self.selectView];
    __weak QRCreateViewController *weakSelf = self;
    [self.selectView setSelectedCallBackBlock:^(NSInteger index) {
        __strong QRCreateViewController *strongSelf = weakSelf;
        [strongSelf showViewAtIndex:index];
        NSLog(@"select at index %ld",index);
    }];
    [self.selectView show];
    [self showViewAtIndex:0];
    [self.view addSubview:self.createBtn];
    
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)showViewAtIndex:(NSInteger)index {
    
    if (_currentInfoView) {
        [_currentInfoView removeFromSuperview];
    }
    if (index > self.views.count) {
        return;
    }
    _currentInfoView = self.views[index];
    _currentInfoView.backgroundColor = [UIColor clearColor];
    _currentInfoView.frame =CGRectMake(100, 80, ScreenWidth - 100, 360);
    if (_currentInfoView) {
        [self.view addSubview:_currentInfoView];
    }
}
- (CommenInfoView *)createViewAtIndex:(NSInteger)index {
    CommenInfoView *result;
    switch (index) {
        case QRTypeMyCard:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"MyCardInfoView" owner:self options:nil] lastObject];
        }break;
        case QRTypeAPP:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"APPInfoView" owner:self options:nil] lastObject];
        }break;
        case QRTypeHTTP:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"HttpInfoView" owner:self options:nil] lastObject];
        }break;
        case QRTypeMsg:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"MsgInfoView" owner:self options:nil] lastObject];
        }break;
        case QRTypeMail:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"MailInfoView" owner:self options:nil] lastObject];
        }break;
        case QRTypePosition:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"PositionInfoView" owner:self options:nil] lastObject];
        }break;
        case QRTypeWIFI:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"WIFIInfoView" owner:self options:nil] lastObject];
        }break;
        case QRTypeText:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"TextinfoView" owner:self options:nil] lastObject];
        }break;
            result = nil;
        default:
            break;
    }
    if (result) {
        result.layer.borderColor = [UIColor whiteColor].CGColor;
        result.layer.borderWidth = 1;
        
    }
    return result;

    
}
- (void)createBtnClick:(UIButton *)sender {

    NSString *qrStr = [self.currentInfoView getResultInfoStr];
    if (!qrStr || qrStr.length < 2) {
        return;
    }
    QRModel *model = [[QRModel alloc] init];
    model.QRStr = qrStr;
//    model.QRFrame = CGRectMake(0.065, 0.2355, 0.7, 0.7);
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"border_test" ofType:@"jpg"];
//    model.boarderImage = [UIImage imageWithContentsOfFile:path];
    //model.bgImage = [UIImage imageNamed:@"testimage"];
   // model.logo = [UIImage imageNamed:@"logo"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    QRShowViewController *qVC = [story instantiateViewControllerWithIdentifier:@"QRShowViewController"];
    
    qVC.qrModel = model;
    
    [self.navigationController pushViewController:qVC animated:YES];
}
- (DXSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[DXSelectView alloc] initWithFrame:CGRectMake(0, 80, 100, 360) titleArr:@[@"名片",@"app",@"网址",@"短信",@"邮件",@"位置",@"WIFI",@"文本"] andIconArr:nil];
        
    }
    return _selectView;
}
- (UIButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _createBtn.frame = CGRectMake(self.view.frame.size.width/2 - createBtnWidth/2, self.view.frame.size.height - 49 - 50 - createBtnWidth *1.2/4, createBtnWidth, createBtnWidth*1.2/4);
        [_createBtn setTitle:@"createQR" forState:UIControlStateNormal];
        [_createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_createBtn addTarget:self action:@selector(createBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _createBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _createBtn.layer.cornerRadius = 5;
        _createBtn.layer.borderWidth = 1;
    }
    return _createBtn;
}
- (NSMutableArray *)views {

    if (!_views) {
        _views = [[NSMutableArray alloc] init];
        for (NSInteger i = 0;i < 8; i++) {
            [_views addObject:[self createViewAtIndex:i]];
        }
    }
    return _views;
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
