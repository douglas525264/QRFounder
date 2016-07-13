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

#import "DMAdView.h"
@interface QREditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DMAdViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (nonatomic, strong) DXScrollMenu *scrollMenu;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@end

@implementation QREditViewController
{

    DMAdView *_dmAdView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.qrView.qrModel = self.qrModel;
    
    self.view.backgroundColor = DefaultColor;
    [self createAD];
    // Do any additional setup after loading the view.
}
- (void)createAD {

    _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJ2XeouNyyVYYzVk" placementId:@"16TLP2vvApalANUU2ciqFnZi"];
    _dmAdView.frame = CGRectMake(0, 20, FLEXIBLE_SIZE.width,FLEXIBLE_SIZE.height);
    _dmAdView.delegate = self; // 设置 Delegate
    _dmAdView.rootViewController = self; // 设置 RootViewController
    [self.view addSubview:_dmAdView]; // 将 告视图添加到 视图中
    [_dmAdView loadAd]; // 开始加载 告}

    
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

            if (path.section == 0 && (_editType == QREditTypeBg || _editType == QREditTypeLogo)) {
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
//    if (self.editType) {
//        NSMutableArray *resultArr = [[NSMutableArray alloc] init];
//        
//        for (NSInteger j = 0 ; j < 8; j ++) {
//            DXmenuItem *firstMenu = [[DXmenuItem alloc] init];
//            firstMenu.menuIcon = [UIImage imageNamed:@"menuTest"];
//            firstMenu.title = @"测试Icon";
//            NSMutableArray *subArr = [[NSMutableArray alloc] init];
//            for (NSInteger i = 0; i < 8; i++) {
//                DXSubMenuItem *subOneMenu = [[DXSubMenuItem alloc] init];
//                subOneMenu.normalImage = [UIImage imageNamed:@"menuTest"];
//                subOneMenu.ImageName = @"menuTest";
//                [subArr addObject:subOneMenu];
//            }
//            firstMenu.items = subArr;
//            [resultArr addObject:firstMenu];
//        }
//        return resultArr;
    
//    }
//    return nil;
}
#pragma mark -  懒加载
- (DXScrollMenu *)scrollMenu {
    @synchronized(self) {
        if (!_scrollMenu) {
            _scrollMenu = [[DXScrollMenu alloc] initWithFrame:CGRectMake(0, self.toolView.frame.origin.y - 120 , self.view.frame.size.width, 120)];
            //_scrollMenu.backgroundColor = [UIColor greenColor];
            [self.view addSubview:_scrollMenu];
        }
        return _scrollMenu;
   
    }
}
- (void)viewDidLayoutSubviews {

    self.scrollMenu.frame = CGRectMake(0, self.toolView.frame.origin.y - 120 , self.view.frame.size.width, 120);
    self.scrollMenu.backgroundColor = self.toolView.backgroundColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ADDelegate
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView {
    NSLog(@"Show Ad Success");
}
// Sent when an ad request fail to loaded an ad
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error {
    NSLog(@"Show AD Fail");
}
- (void)dealloc {

    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
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
