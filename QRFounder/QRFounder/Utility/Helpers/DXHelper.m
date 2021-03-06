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
#import "DXAlertAction.h"
@interface DXHelper()
@property (nonatomic, strong) DXCommenQRView *qrView;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIImageView *bgImageView;
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
- (UIImage *)normalImageFromView:(UIView *)theView {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIImage *image = [self normalImageFromView:theView withScale:scale];
    NSData *da = UIImagePNGRepresentation(image);
    while (da.length > 1024 * 1024) {
        scale /= 1.2;
        image = [self normalImageFromView:theView withScale:scale];
        da = UIImagePNGRepresentation(image);

    }
    return image;

}
- (UIImage *)normalImageFromView:(UIView *)theView withScale:(CGFloat)scale {

    UIGraphicsBeginImageContextWithOptions(theView.frame.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
- (UIImage *)getShareImageWithModel:(QRModel *)model {

    self.qrView.qrModel = model;
    [self normalImageFromView:self.qrView];
    UIImage *image1 = [self normalImageFromView:self.qrView];
    return image1;
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
- (UIImage *)getColorImageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;

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
            return [self parseWifiInfoWithStr:qrStr];
        }break;
        case QRTypeMsg:{
            return  [self parseMsgInfoWithStr:qrStr];
        }break;
            
        default:
            break;
    }
    
    return resultDic;

}
#pragma mark - private
- (NSMutableArray *)parseMsgInfoWithStr:(NSString *)qrStr {
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    NSString *subStr;
    NSRange msgRan = [qrStr rangeOfString:@"smsto:"];
    if (msgRan.length > 0) {
        subStr = [qrStr substringFromIndex:msgRan.length];
    }
    NSRange phonrran = [subStr rangeOfString:@":"];
    NSString *to = [subStr substringToIndex:phonrran.location];
    NSString *msgBody = [subStr substringFromIndex:phonrran.location + 1];
    if (to.length > 0) {
        [resultArr addObject:@{SEND_TO_KEY : to}];
        
    }
    if (msgBody.length > 0) {
        [resultArr addObject:@{SEND_BODY_KEY : msgBody}];
    }
    //NSArray *arr = [subStr componentsSeparatedByString:@":"];


    return resultArr;
}
+ (NSString *)getVersionCode{
    NSDictionary *infoDir =  [[NSBundle mainBundle]infoDictionary];
    return [infoDir objectForKey:@"CFBundleShortVersionString"];
}

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
                NSRange chuanzhenRan = [paramter rangeOfString:@"TEL;WORK;FAX:"];
                NSRange companyRan = [paramter rangeOfString:@"ORG:"];
                NSRange addressRan = [paramter rangeOfString:@"ADR;TYPE=WORK:"];
                NSRange homepageRan = [paramter rangeOfString:@"URL:"];
                NSRange psRan = [paramter rangeOfString:@"NOTE:"];
                NSRange jobRan = [paramter rangeOfString:@"TITLE:"];
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
                if (jobRan.length > 0 && jobRan.location == 0) {
                    //here need local infonamtion
                    //[resultDic setObject:[paramter substringFromIndex:addressRan.length] forKey:ADDRESS_KEY];
                    [resultDic addObject:@{JOP_KEY : [paramter substringFromIndex:jobRan.length]}];
                }

                if (psRan.length > 0 && psRan.location == 0) {
                    //here need local infonamtion
                    //[resultDic setObject:[paramter substringFromIndex:addressRan.length] forKey:ADDRESS_KEY];
                    [resultDic addObject:@{NOTE_KEY : [paramter substringFromIndex:psRan.length]}];
                }

                if (homepageRan.length > 0 && homepageRan.location == 0) {
                    //here need local infonamtion
                    //[resultDic setObject:[paramter substringFromIndex:addressRan.length] forKey:ADDRESS_KEY];
                    [resultDic addObject:@{HOMEPAGE_KEY : [paramter substringFromIndex:homepageRan.length]}];
                }


                
            }
        }
    }
    
    return resultDic;
}
- (NSMutableArray *)parseWifiInfoWithStr:(NSString *)qrStr {
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    NSString *subStr;
    NSRange wifiRan = [qrStr rangeOfString:@"WIFI:"];
    if (wifiRan.length > 0) {
        subStr = [qrStr substringFromIndex:wifiRan.length];
    }
    NSArray *arr = [subStr componentsSeparatedByString:@";"];
    for (NSString *paramter in arr) {
       NSRange wifiNameRan = [[paramter lowercaseString] rangeOfString:@"s:"];
        NSRange entryptTypeRan = [[paramter lowercaseString] rangeOfString:@"t:"];
        NSRange pswRan = [[paramter lowercaseString] rangeOfString:@"p:"];
        if (wifiNameRan.length > 0 && wifiNameRan.location == 0) {
            [resultArr addObject:@{WIFI_NAME_KEY : [paramter substringFromIndex:wifiNameRan.length]}];
        }
        if (entryptTypeRan.length > 0 && entryptTypeRan.location == 0) {
            [resultArr addObject:@{ENTRYPT_WAY_KEY : [paramter substringFromIndex:entryptTypeRan.length]}];
        }

        if (pswRan.length > 0 && pswRan.location == 0) {
            [resultArr addObject:@{PSW_KEY : [paramter substringFromIndex:pswRan.length]}];
        }

    }
    return resultArr;
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
    if ([key isEqualToString:HOMEPAGE_KEY]) {
        return @"主页";
    }

    if ([key isEqualToString:NOTE_KEY]) {
        return @"备注";
    }
    if ([key isEqualToString:WIFI_NAME_KEY]) {
        return @"wifi名称";
    }
    if ([key isEqualToString:ENTRYPT_WAY_KEY]) {
        return @"加密方式";
    }
    if ([key isEqualToString:PSW_KEY]) {
        return @"密码";
    }


    
    return @"";
}
- (UIImage *)getBgImage {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    self.bgImageView = bgImageView;
   // [[UIApplication sharedApplication].keyWindow addSubview:self.bgImageView];
    UIImage *image = [UIImage imageNamed:@"background"];
   
    if (!self.bgImage) {
        
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *orImage = image;
        CIImage *coImage = [CIImage imageWithCGImage:orImage.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:coImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:4.0] forKey:@"inputRadius"];
        // blur image
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[coImage extent]];
        UIImage *rimage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        bgImageView.image = rimage;
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        

        self.bgImage = [self imageFromView:self.bgImageView];;
    }
    return self.bgImage;
}

- (BOOL)isFirstTimeStart {
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *localVersion = [de objectForKey:@"localProVersion"];
    
    if (!localVersion || ![currentVersion isEqualToString:localVersion]) {
        [de setValue:currentVersion forKey:@"localProVersion"];
        [de synchronize];
        return YES;
    }
    return NO;
}
- (BOOL)needShowLike {
    BOOL result = YES;
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    if ([self isFirstTimeStart]) {
        result = YES;
        [de setObject:@(NO) forKey:@"hasClikLike"];
        [de setObject:@(NO) forKey:@"hasRefuse"];
        [de setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"askNextTime"];
        [de synchronize];
    } else {
        
        BOOL hasClick = [[de objectForKey:@"hasClikLike"] boolValue];
        if (hasClick) {
            return NO;
        }
        
        
        BOOL hasRefuse = [[de objectForKey:@"hasRefuse"] boolValue];
        if (hasRefuse) {
            return NO;
        }
        int64_t askNextTime = [[de objectForKey:@"askNextTime"] longLongValue];
        if (([[NSDate date] timeIntervalSince1970] - askNextTime) > 60 * 60 *24) {
            result = YES;
        }else {
            result = NO;
        }
        
    }
    return result;
}
- (void)showLikeInVC:(UIViewController *)vc {

   // if ([self needShowLike]) {
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [DXAlertAction showAlertWithTitle:@"提示" msg:@"对我们的二维码样式是否满意" inVC:vc chooseBlock:^(NSInteger buttonIdx) {
            switch (buttonIdx) {
                case 0:{
#if QRFounderPRO
                    NSString *strUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1185233985"];
#else
                    NSString *strUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1152798225"];
#endif
                   // NSString *strUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1152798225"];
                    NSURL *url = [NSURL URLWithString:strUrl];
                    [[UIApplication sharedApplication] openURL:url];
                    [de setObject:@(YES) forKey:@"hasClikLike"];
   
                }break;
                case 1:{
                 [de setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"askNextTime"];
                }break;
                case 2:{
                 [de setObject:@(YES) forKey:@"hasRefuse"];
                }break;

                    
                default:
                    break;
            }
        } buttonsStatement:@"满意，赞一个",@"下次再说",@"残忍拒绝",nil];
    [de synchronize];
  //  }
}
@end
