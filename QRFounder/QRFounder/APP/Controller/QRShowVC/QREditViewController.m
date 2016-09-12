//
//  QREditViewController.m
//  QRFounder
//
//  Created by dongxin on 16/3/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QREditViewController.h"
#import "DXScrollMenu.h"
#import "QRSourceManager.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"
#import "DXHelper.h"
@interface QREditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,BaiduMobAdViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (nonatomic, strong) DXScrollMenu *scrollMenu;

@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation QREditViewController
{
    BaiduMobAdView *sharedAdView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.qrView.qrModel = self.qrModel;
   
    self.view.backgroundColor = DefaultColor;
    if (ADENABLE) {

     [self createAD];
    }
    
    // Do any additional setup after loading the view.
}

- (void)createAD {
    sharedAdView = [[BaiduMobAdView alloc] init]; //把在mssp.baidu.com上创建后获得的代码位id写到这里
    sharedAdView.AdUnitTag = @"2873611";
    sharedAdView.AdType = BaiduMobAdViewTypeBanner;
    sharedAdView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 64);
    sharedAdView.backgroundColor = [UIColor clearColor];
    sharedAdView.delegate = self;
    [self.view addSubview:sharedAdView];
    sharedAdView.hidden = YES;
    [sharedAdView start];
    
}

- (void)setBgImage:(UIImage *)image {
    self.qrModel.bgImage = image;
    self.qrModel.codeColor = nil;
    self.qrView.qrModel = self.qrModel;

}
- (void)setLogoImage:(UIImage *)image {
    self.qrModel.logo = image;
    self.qrView.qrModel = self.qrModel;
    
}
- (void)setQRColor:(UIColor *)color {

    self.qrModel.codeColor = color;
     self.qrView.qrModel = self.qrModel;
}
- (void)setBoarderImage:(UIImage *)image withQRFrame:(CGRect)qrFrame {

    self.qrModel.boarderImage = image;
    self.qrModel.QRFrame = qrFrame;
    self.qrView.qrModel = self.qrModel;
}
- (void)setEditType:(QREditType)editType {
    
    _editType = editType;
    NSArray *items = [self loaddata];
    self.sourceArr = [NSMutableArray arrayWithArray:items];
    self.scrollMenu.menuItems = items;
    __weak QREditViewController *weakSelf = self;
    [self.scrollMenu setSelectFinishedCallBack:^(NSIndexPath *path, NSInteger tag) {
        __strong QREditViewController *strongSelf = weakSelf;
        

        if (path) {
            DXmenuItem *item = strongSelf.sourceArr[path.section];
            DXSubMenuItem *subitem = item.items[path.row];

            if (path.section == 0 && (strongSelf.editType == QREditTypeBg || strongSelf.editType == QREditTypeLogo)) {
                switch (path.row) {
                    case 0:{
                        //相册
                        [strongSelf albumBtnClick:nil];
                        return ;
                    }break;
                    case 1:{
                        //相机
                        [strongSelf showcamera];
                        
                        return;
                    }break;
                        
                    default:
                        break;
                }
               // return ;
            } else {
                UIImage *image = [UIImage imageWithContentsOfFile:subitem.ImageName];
                switch (strongSelf.editType) {
                    case QREditTypeBg:{
                        [strongSelf setBgImage:image];
                    }break;
                    case QREditTypeBoarder:{
                        [strongSelf setBoarderImage:image withQRFrame:subitem.QRFrame];
                    }break;
                    case QREditTypeLogo:{
                        [strongSelf setLogoImage:image];
                    }break;
                    case QREditTypeColor:{
                        [strongSelf setQRColor:subitem.color];
                    }break;

                        
                    default:
                        break;
                }
                
            }

        }
    }];

}
- (IBAction)albumBtnClick:(id)sender {
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self loadSourceWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else{
        NSLog(@"相册不可用");
        // [self showAlterWithMessage:@"相册不可用"];
    }
    
}
- (void)showcamera {
    [self loadSourceWithType:UIImagePickerControllerSourceTypeCamera];
}
- (void)loadSourceWithType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    //    是否对相册资源进行自动处理
    picker.allowsEditing = YES;
    //
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    先判断资源是否是图片资源
  //  NSString *mediaType = info[UIImagePickerControllerMediaType];
    //    系统预置的图片类型常量
    UIImage *image = info[UIImagePickerControllerEditedImage];
    switch (_editType) {
        case QREditTypeBg:
            [self setBgImage:image];
            break;
        case QREditTypeLogo:
            [self setLogoImage:image];
            break;
            
        default:
            break;
    }
//    self.qrModel.bgImage = image;
//    self.qrView.qrModel = self.qrModel;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.finishedBlock = nil;
    }];
}
- (IBAction)OKbtnClcik:(id)sender {
    if (self.finishedBlock) {
        self.finishedBlock(self.qrModel);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        self.finishedBlock = nil;
    }];
}
- (NSArray *)loaddata {
    return [[QRSourceManager shareInstance] getSoureceWithEditeType:self.editType];
}
#pragma mark -  懒加载
- (DXScrollMenu *)scrollMenu {
    @synchronized(self) {
        if (!_scrollMenu) {
            if (_editType == QREditTypeColor) {
             _scrollMenu = [[DXScrollMenu alloc] initWithFrame:CGRectMake(0, self.toolView.frame.origin.y - 60 , self.view.frame.size.width, 60)];
                _scrollMenu.backgroundColor = [UIColor greenColor];
            } else {
                _scrollMenu = [[DXScrollMenu alloc] initWithFrame:CGRectMake(0, self.toolView.frame.origin.y - 95 , self.view.frame.size.width, 95)];
            }
            
            //_scrollMenu.backgroundColor = [UIColor greenColor];
            [self.view addSubview:_scrollMenu];
        }
        return _scrollMenu;
   
    }
}
- (void)viewDidLayoutSubviews {
    if (_editType == QREditTypeColor) {
    self.scrollMenu.frame = CGRectMake(0, self.toolView.frame.origin.y - 60 , self.view.frame.size.width, 60);
    } else {
        self.scrollMenu.frame = CGRectMake(0, self.toolView.frame.origin.y - 95, self.view.frame.size.width, 95);
    }
    self.scrollMenu.backgroundColor = self.toolView.backgroundColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - ADDelegate

#pragma mark - mobisageBannerAdDelegate
#pragma mark

//横幅广告被点击时,触发此回调方法,用于统计广告点击数
/**
 *  广告将要被载入
 */
- (void)willDisplayAd:(BaiduMobAdView *)adview {

    NSLog(@"广告将要被载入");
    sharedAdView.hidden = NO;
}

/**
 *  广告载入失败
 */
- (void)failedDisplayAd:(BaiduMobFailReason)reason {

    NSLog(@"fail reason : %ld",reason);
}
- (NSString *)publisherId {

    return @"ff5809c5";
}
- (void)dealloc
{
    sharedAdView.delegate = nil;
    sharedAdView = nil;
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
