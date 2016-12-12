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
#import "AnalyticsManager.h"
#import "AboutTableViewController.h"
#import "MainViewController.h"
#import "HistoryViewController.h"
#import "DBManager.h"
#import "DXHelper.h"
#import "QRFounderAppDelegate.h"
#import <ZBarSDK.h>
#import "QRScanViewController.h"
#define createBtnWidth 120
@interface QRCreateViewController ()<UIImagePickerControllerDelegate>
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
   
   
    self.view.backgroundColor = DefaultColor;
  //  [self.view insertSubview:bgImageView atIndex:0];
    self.navigationItem.title = @"生成二维码";
    
//    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"qrcreate_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    //[self.navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultColor} forState:UIControlStateSelected];
    
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
    
    //关于
    UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame = CGRectMake(0, 0, 33, 33);
    [profileBtn setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    [profileBtn addTarget:self action:@selector(aboutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:profileBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(historyBtnClick:)];
#if QRFounderPRO
   
#else
    QRFounderAppDelegate *appde = [UIApplication sharedApplication].delegate;
    [appde addAD];
#endif

    
}
- (void)historyBtnClick:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    HistoryViewController *qVC = [story instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    [self.navigationController pushViewController:qVC animated:YES];
   }
- (void)aboutBtnClick:(id)sender {
    //关于
 
    AboutTableViewController *aVC = [[AboutTableViewController alloc] init];
    [self.navigationController pushViewController:aVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MainViewController shareInstance].btn.hidden = NO;
   // self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [MainViewController shareInstance].btn.hidden = YES;
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
    CGFloat width =  self.view.frame.size.width * 0.27;
    width = width > 100 ? 100 : width;
    _currentInfoView.frame =CGRectMake(width, 80, ScreenWidth - width, IS_IPAD ? 500 : 360);
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
//        case QRTypePosition:{
//            result = [[[NSBundle mainBundle] loadNibNamed:@"PositionInfoView" owner:self options:nil] lastObject];
//        }break;
        case QRTypeWIFI:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"WIFIInfoView" owner:self options:nil] lastObject];
        }break;
        case QRTypeText:{
            result = [[[NSBundle mainBundle] loadNibNamed:@"TextinfoView" owner:self options:nil] lastObject];
            TextInfoView *tt = (TextInfoView *)result;
            @weakify(self);
            [tt setCommendCallBlock:^(NSInteger index) {
                @strongify(self);
                switch (index) {
                    case 1:{
                        [self showAlbum];
                    }break;
                    case 2:{
                        [self showCamera];
                        
                    }break;
                        
                    default:
                        break;
                }
            }];
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
- (void)showCamera{
    
    QRScanViewController *sVC = [[QRScanViewController alloc] init];
    sVC.isShowBack = YES;
    sVC.isShowAlbum = NO;
    @weakify(self);
    [sVC setScanBlock:^(NSString *result) {
      @strongify(self);
        [self getResult:result];
    }];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:sVC] animated:YES completion:^{
        
    }];
}
- (void)showAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self loadSourceWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        
    }else{
        NSLog(@"相册不可用");
        // [self showAlterWithMessage:@"相册不可用"];
    }
}
- (void)loadSourceWithType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    //    是否对相册资源进行自动处理
    // picker.allowsEditing = YES;
    //
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)createBtnClick:(UIButton *)sender {

    NSString *qrStr = [self.currentInfoView getResultInfoStr];
    if (!qrStr || qrStr.length == 0) {
        
        return;
    }
    
    QRModel *model = [[QRModel alloc] init];
    model.QRStr = qrStr;
    [[DBManager shareManager] saveModel:model];
//    model.QRFrame = CGRectMake(0.065, 0.2355, 0.7, 0.7);
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"border_test" ofType:@"jpg"];
//    model.boarderImage = [UIImage imageWithContentsOfFile:path];
    //model.bgImage = [UIImage imageNamed:@"testimage"];
   // model.logo = [UIImage imageNamed:@"logo"];
   // model.codeColor = [UIColor yellowColor];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    QRShowViewController *qVC = [story instantiateViewControllerWithIdentifier:@"QRShowViewController"];
    
    qVC.qrModel = model;
   // qVC.hidesBottomBarWhenPushed = YES;
//    qVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:qVC animated:YES];
     [[AnalyticsManager shareInstance] createQREventWithType:model.type];
}
- (DXSelectView *)selectView {
    if (!_selectView) {
        CGFloat width =  self.view.frame.size.width * 0.27;
        width = width > 100 ? 100 : width;
        _selectView = [[DXSelectView alloc] initWithFrame:CGRectMake(0, 80, width,IS_IPAD ? 500 : 360) titleArr:@[@"文本",@"名片",@"app",@"网址",@"短信",@"邮件"/*,@"位置"*/,@"WIFI"] andIconArr:nil];
        
    }
    return _selectView;
}
- (UIButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _createBtn.frame = CGRectMake(self.view.frame.size.width/2 - createBtnWidth/2, self.view.frame.size.height - 49 - 30 - createBtnWidth *1.2/4, createBtnWidth, createBtnWidth*1.2/4);
        [_createBtn setTitle:@"创建" forState:UIControlStateNormal];
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
        for (NSInteger i = 0;i < 7; i++) {
            [_views addObject:[self createViewAtIndex:i]];
        }
    }
    return _views;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    先判断资源是否是图片资源
    
    //NSString *mediaType = info[UIImagePickerControllerMediaType];
    //    系统预置的图片类型常量
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
    //        //        取得图片
    //        UIImage *image = info[UIImagePickerControllerEditedImage];
    //        [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    //    }
    //    ZBarImageScanner *scanner = [[ZBarImageScanner alloc] init];
    //    [scanner setSymbology: ZBAR_I25
    //                   config: ZBAR_CFG_ENABLE
    //                       to: 0];
    //    [scanner scanImage:[[ZBarImage alloc] initWithCGImage:image.CGImage]];
    //
    //
    ZBarReaderController *read = [ZBarReaderController new];
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol* symbol = nil;
    for(symbol in [read scanImage:cgImageRef]){
        break;
    }
    //    ZBarSymbol *zs = nil;
    //    for (zs in info[ZBarReaderControllerResults]) {
    //        break;
    //    }
    
    // ZBarSymbol *resSymbol = resul
    NSLog(@"%@",symbol.data);
    
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    if (symbol.data == nil) {
        [[DXHelper shareInstance] makeAlterWithTitle:@"无法识别图片" andIsShake:NO];
        NSLog(@"无法识别图片");
    }else {
        [[AnalyticsManager shareInstance] scanQRCodeWithAlbumEvent];
        [self getResult:symbol.data];
    }
    
    
}
- (void)getResult:(NSString *)result {
    if ([self.currentInfoView isKindOfClass:[TextInfoView class]]) {
        TextInfoView *textView = (TextInfoView *)self.currentInfoView;
        textView.textInfoTextView.text = result;
    }
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
