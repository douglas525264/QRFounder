//
//  DXHelper.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXHelper.h"
#import "DXCommenQRView.h"
@interface DXHelper()
@property (nonatomic, strong) DXCommenQRView *qrView;
@end;
static DXHelper *helper;

@implementation DXHelper
+ (id)shareInstance {
    if (!helper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            helper = [[DXHelper alloc] init];
        });
    }
    return helper;

}
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)makeAlterWithTitle:(NSString *)title andIsShake:(BOOL)isShake
{
    if(![NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(showAlertWithTitle:) withObject:title waitUntilDone:NO];
        return;
    }
    [self showAlertWithTitle:title];
//    if (isShake) {
//        [ZapyaTools makeShake];
//    }
    
}
- (void)showAlertWithTitle:(NSString *)title
{
    [self makeAlterWithTitle:title dur:1 andIsShake:NO];
}
- (void)makeAlterWithTitle:(NSString *)title dur:(CGFloat)dur andIsShake:(BOOL)isShake inView:(UIView *)view{
    
    [self.atmhud setCaption:title];
    
    self.atmhud.minShowTime = dur;
    [self.atmhud showInView:view];
    [self.atmhud hide];
//    if (isShake) {
//        [ZapyaTools makeShake];
//    }
    
}
- (ATMHud *)atmhud
{
    if (!_atmhud) {
        _atmhud = [[ATMHud alloc] init];
        
    }
    return _atmhud;
}
- (void)makeAlterWithTitle:(NSString *)title dur:(CGFloat)dur andIsShake:(BOOL)isShake
{
    [self makeAlterWithTitle:title dur:dur andIsShake:isShake inView:[UIApplication sharedApplication].keyWindow];
}
- (void)saveImageWithModel:(QRModel *)model withFinishedBlock:(void (^)(BOOL isOK))finishedBlcok{
    self.qrView.qrModel = model;
    [self imageFromView:self.qrView];
    UIImage *image1 = [self imageFromView:self.qrView];
    UIImageWriteToSavedPhotosAlbum(image1, nil, nil, nil);
    self.qrView = nil;

    //qrView.qrModel = model;
   // [self performSelector:@selector(test) withObject:nil afterDelay:1];
    finishedBlcok(YES);
    
}
- (void)test {
    
    
}
- (DXCommenQRView *)qrView {

    if (!_qrView) {
        _qrView = [[DXCommenQRView alloc] init];
        _qrView.frame = CGRectMake(0, 0, 1024, 1024);
    }
    return _qrView;
}

@end
