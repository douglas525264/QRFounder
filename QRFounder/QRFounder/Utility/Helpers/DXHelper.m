//
//  DXHelper.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXHelper.h"
#import "DXCommenQRView.h"
#import "NSString+DXCheck.h"
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
- (QRType)getTypeWithStr:(NSString *)QrStr {
    
    if ([QrStr hasPrefix:@"BEGIN:VCARD"] && [QrStr hasSuffix:@"END:VCARD"]) {
        return QRTypeMyCard;
    }
    if ([QrStr hasPrefix:@"itms-apps://"]) {
        return QRTypeAPP;
    }
    if ([QrStr hasPrefix:@"http://"] || [QrStr hasPrefix:@"https://"]) {
        return QRTypeHTTP;
    }
    if ([QrStr hasPrefix:@"smsto:"]) {
        return QRTypeMsg;
    }
    if ([NSString validateEmail:QrStr]) {
        return QRTypeMail;
    }
    if ([QrStr hasPrefix:@"WIFI:"]) {
        return QRTypeWIFI;
    }
    return QRTypeText;
}
- (NSMutableDictionary *)getParamtersWithArr:(NSArray *)arr {
    NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
    for (NSDictionary *info in arr) {
        [res setValuesForKeysWithDictionary:info];
    }
    return res;
}
- (NSMutableArray *)getparamtersWithQrstr:(NSString *)qrStr {
    NSMutableArray *resultDic = [[NSMutableArray alloc] init];
    QRType type = [self getTypeWithStr:qrStr];
    switch (type) {
        case QRTypeMyCard:{
            return [self parseMyCardinfoWithStr:qrStr];
        }break;
        case QRTypeWIFI:{
            
        }break;
        case QRTypeMail:{
            
        }break;
            
        default:
            break;
    }
    
    return resultDic;

}
#pragma mark - private
- (NSMutableArray *)parseMyCardinfoWithStr:(NSString *)qrstr{
    NSMutableArray *resultDic = [[NSMutableArray alloc] init];
    
    NSArray *arr = [qrstr componentsSeparatedByString:@"\n"];
    if (arr.count > 0) {
        for (NSString *paramter  in arr) {
            @autoreleasepool {
                if ([paramter isEqualToString:@"BEGIN:VCARD"] || [paramter isEqualToString:@"END:VCARD"]) {
                    continue;
                }
                NSRange nameRan = [paramter rangeOfString:@"N:"];
                NSRange mailRan = [paramter rangeOfString:@"EMAIL:"];
                NSRange telephoneRan = [paramter rangeOfString:@"TEL;CELL:"];
                NSRange chuanzhenRan = [paramter rangeOfString:@"TEL:"];
                NSRange companyRan = [paramter rangeOfString:@"ORG:"];
                NSRange addressRan = [paramter rangeOfString:@"ADR;TYPE=WORK:"];
                if (nameRan.length > 0 && nameRan.location == 0) {
                    //here need local infonamtion
                   // [resultDic setObject:[paramter substringFromIndex:nameRan.length] forKey:NAME_KEY];
                    [resultDic addObject:@{NAME_KEY : [paramter substringFromIndex:nameRan.length]}];
                }
                if (mailRan.length > 0 && mailRan.location == 0) {
                    //here need local infonamtion
                    //[resultDic setObject:[paramter substringFromIndex:mailRan.length] forKey:MAIL_KEY];
                    [resultDic addObject:@{MAIL_KEY : [paramter substringFromIndex:mailRan.length]}];
                }

                if (telephoneRan.length > 0 && telephoneRan.location == 0) {
                    //here need local infonamtion
                   // [resultDic setObject:[paramter substringFromIndex:telephoneRan.length] forKey:TELEPHONE_KEY];
                    [resultDic addObject:@{TELEPHONE_KEY : [paramter substringFromIndex:telephoneRan.length]}];
                }

                if (chuanzhenRan.length > 0 && chuanzhenRan.location == 0) {
                    //here need local infonamtion
                   // [resultDic setObject:[paramter substringFromIndex:chuanzhenRan.length] forKey:FAX_KEY];
                    [resultDic addObject:@{FAX_KEY : [paramter substringFromIndex:chuanzhenRan.length]}];
                }

                if (companyRan.length > 0 && companyRan.location == 0) {
                    //here need local infonamtion
                 //   [resultDic setObject:[paramter substringFromIndex:companyRan.length] forKey:COMPANY_KEY];
                    [resultDic addObject:@{COMPANY_KEY : [paramter substringFromIndex:companyRan.length]}];
                }

                if (addressRan.length > 0 && addressRan.location == 0) {
                    //here need local infonamtion
                    //[resultDic setObject:[paramter substringFromIndex:addressRan.length] forKey:ADDRESS_KEY];
                    [resultDic addObject:@{ADDRESS_KEY : [paramter substringFromIndex:addressRan.length]}];
                }

                
            }
        }
    }
    
    return resultDic;
}
- (NSString *)getLocalNameWithKey:(NSString *)key {

    if ([key isEqualToString:NAME_KEY]) {
        return @"姓名";
    }
    if ([key isEqualToString:COMPANY_KEY]) {
        return @"公司";
    }

    if ([key isEqualToString:JOP_KEY]) {
        return @"工作";
    }

    if ([key isEqualToString:TELEPHONE_KEY]) {
        return @"电话";
    }

    if ([key isEqualToString:FAX_KEY]) {
        return @"传真";
    }

    if ([key isEqualToString:MAIL_KEY]) {
        return @"邮箱";
    }

    if ([key isEqualToString:ADDRESS_KEY]) {
        return @"地址";
    }

    
    return @"";
}
@end
