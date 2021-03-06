//
//  QRScanViewController.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QRScanViewController.h"
#import <ZBarSDK.h>
#import "DXQRScanView.h"
#import "QRModel.h"
#import <AVFoundation/AVFoundation.h>
#import "DXWebViewController.h"
#import "DXScanresultViewController.h"
#import "AnalyticsManager.h"
#import "DXHelper.h"
#import "MainViewController.h"
#import "DBManager.h"
#define ScanWidth 250
@interface QRScanViewController ()<ZBarReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,ZBarReaderDelegate>
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) DXQRScanView *scanView;
@property (nonatomic, strong) UILabel *alertLable;
@end

@implementation QRScanViewController
{
    ZBarReaderView *readView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.isShowAlbum = YES;
    self.isShowBack = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
        // Do any additional setup after loading the view.
}
- (void)createUI{

    self.navigationItem.title = @"扫描";
    self.view.backgroundColor = RGB(0,0,0,0.6);
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"qrscan_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultColor} forState:UIControlStateSelected];
    
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, 0, 22, 22);
    [leftbtn setImage:[UIImage imageNamed:@"lightIcon"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(openLightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 22, 22);
    [rightBtn setImage:[UIImage imageNamed:@"albumIcon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(openAlbumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    if (self.isShowBack) {
        if (self.isShowAlbum) {
            self.navigationItem.leftBarButtonItems = @[leftItem,rightItem];
        }else {
            
            self.navigationItem.leftBarButtonItem = leftItem;
        }
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 44, 22);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //[leftbtn setImage:[UIImage imageNamed:@"lightIcon"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];

      
    } else {
        if (self.isShowAlbum) {
            self.navigationItem.leftBarButtonItem = leftItem;
            self.navigationItem.rightBarButtonItem = rightItem;
        }else {
            self.navigationItem.rightBarButtonItem = leftItem;
        }
    }
    
    

    [self initCapture];
//    readView = [ZBarReaderView new];
//    readView.frame = self.view.bounds;
//    readView.readerDelegate = self;
//    [self.view addSubview:readView];
//    //设置扫描区域
//    readView.scanCrop = [self getScanCrop:[self getScanRect] readerViewBounds:readView.bounds];
//    
//    //二维码/条形码识别设置
//    ZBarImageScanner *scanner = readView.scanner;
//    
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//   
//    [self.view sendSubviewToBack:readView];
    self.scanView.ScanRect = [self getScanRect];
    [self.view addSubview:self.scanView];
    self.alertLable.text = @"将二维码放入框中，即可自动扫描";
    [self.view addSubview:self.alertLable];
    
}
- (void)cancelBtnClick:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //AVCaptureMetadataInput *dateInput = [AVCaptureMetadataInput alloc]
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
   

    [self.captureSession addInput:captureInput];
    
//    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
//    captureOutput.alwaysDiscardsLateVideoFrames = YES;
   

    AVCaptureMetadataOutput*_output=[[AVCaptureMetadataOutput alloc]init];
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.captureSession addOutput:_output];
    
    
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
#pragma mark -
#pragma mark 调整输出位置到方框
        //            不会在二维码刚进入屏幕就直接解析出来
//    [self.captureVideoPreviewLayer metadataOutputRectOfInterestForRect: CGRectMake(100, 200, 60, 60)];
    }
    _output.rectOfInterest = [self getScanCrop:[self getScanRect] readerViewBounds:self.view.bounds];
#pragma mark -
#pragma mark
    //        AVCaptureVideoPreviewLayer * backLayer[AVCaptureVideoPreviewLayer layer];
#pragma mark -
#pragma mark frame
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.captureVideoPreviewLayer];
    
    self.isScanning = YES;
   
    [captureInput.device lockForConfiguration:nil];
    [captureInput.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    [captureInput.device unlockForConfiguration];
    
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    //启动，必须启动后，手机摄影头拍摄的即时图像菜可以显示在readview上
    //[readView start];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     [self.captureSession startRunning];
   //     self.tabBarController.tabBar.hidden = YES;
    
    });
    [self.scanView startAnimation];
  
//
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isShowBack) {
    [MainViewController shareInstance].btn.hidden = NO;
    }
    // self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession stopRunning];
    });
    [self.scanView stopAnimation];
    [MainViewController shareInstance].btn.hidden = YES;
   // [self.captureSession stopRunning];
   // [readView stop];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
       // self.ScanResult(metadataObject.stringValue,YES);
        NSLog(@"get Data : %@",metadataObject.stringValue);
        [[AnalyticsManager shareInstance] scanQRCodeWithCameraEvent:NO];
        [self getResult:metadataObject.stringValue];
    }
    
    [self.captureSession stopRunning];
    
  //  [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGSize size = readerViewBounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;
    //使用了1080p的图像输出
    CGRect cropRect = rect;
    CGRect rectOfInterest;
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                    cropRect.origin.x/size.width,
                                    cropRect.size.height/fixHeight,
                                    cropRect.size.width/size.width);
        
        
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                    (cropRect.origin.x + fixPadding)/fixWidth,
                                    cropRect.size.height/size.height,
                                    cropRect.size.width/fixWidth);
    }
    return rectOfInterest;
}

- (CGRect)getScanRect {

    return  CGRectMake(self.view.frame.size.width/2 - ScanWidth/2, 64 + 30 + 50, ScanWidth, ScanWidth);
}
- (IBAction)openLightBtnClick:(id)sender {
   // readView.torchMode = !readView.torchMode;
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchMode==AVCaptureTorchModeOff) {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        
    }else {
        //闪光灯关闭
        
        [device setTorchMode:AVCaptureTorchModeOff];
    }

}
- (IBAction)openAlbumBtnClick:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self loadSourceWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        

    }else{
        NSLog(@"相册不可用");
        // [self showAlterWithMessage:@"相册不可用"];
    }
    
}
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image{
    ZBarSymbol *zs = nil;
    for (zs in symbols) {
        break;
    }
    
    // ZBarSymbol *resSymbol = resul
    NSLog(@"%@",zs.data);
    [readView stop];
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
    ZBarImageScanner *sa = read.scanner;
    [sa setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
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
        [[AnalyticsManager shareInstance] scanQRCodeWithAlbumEvent:NO];
        [self getResult:symbol.data];
        [readView stop];
        
    }
    
    
}


- (void)getResult:(NSString *)result {
    if (self.scanBlock) {
        [[AnalyticsManager shareInstance] scanQRCodeWithCameraEvent:YES];
        self.scanBlock(result);
        [self cancelBtnClick:nil];
        
    }else {
    QRModel *qr = [[QRModel alloc] initWithQrStr:result];
    qr.isScanResult = YES;
    [[DBManager shareManager] saveModel:qr];
    switch (qr.type) {
        case QRTypeHTTP:{
            DXWebViewController  *webVC = [[DXWebViewController alloc] init];
            webVC.loadUrl = qr.QRStr;
            [self.navigationController pushViewController:webVC animated:YES];
        }break;
        case QRTypeAPP:{
            
        }break;

        default:{
            DXScanresultViewController *dVC = [[DXScanresultViewController alloc] init];
            dVC.qrModel = qr;
           
            [self.navigationController pushViewController:dVC animated:YES];

        }break;
        }
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
- (DXQRScanView *)scanView {

    if (!_scanView) {
        _scanView = [[DXQRScanView alloc] initWithFrame:self.view.bounds];
    }
    return _scanView;
}
- (UILabel *)alertLable {

    if (!_alertLable) {
        _alertLable = [[UILabel alloc] init];
        _alertLable.font = [UIFont systemFontOfSize:14];
        _alertLable.textColor = [UIColor whiteColor];
        _alertLable.alpha = 0.6;
        _alertLable.textAlignment = NSTextAlignmentCenter;
        CGRect rect = [self getScanRect];
        _alertLable.frame = CGRectMake(0, rect.origin.y + rect.size.height + 10, self.view.frame.size.width, 20);
    }
    return _alertLable;
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
