//
//  ShareManager.m
//  QRFounder
//
//  Created by douglas on 16/7/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//UI
#import <ShareSDKUI/ShareSDK+SSUI.h>
#define ShareKey @"14ce79e790265"
#import "AnalyticsManager.h"
static ShareManager *sManager;
@implementation ShareManager

+ (ShareManager *)shareInstance {
    if (!sManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sManager = [[ShareManager alloc] init];
        });
    }
    return sManager;
}
- (void)startSDK {
    [ShareSDK registerApp:ShareKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"4242807488"
                                           appSecret:@"247248b5afec05ed57af937e5055f50c"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx03565949c4ef222b"
                                       appSecret:@"00ecaa559e5352f49cfaadcede09a7d4"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105673876"
                                      appKey:@"7jvamBizVpj51q1b"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                            redirectUri:@"http://localhost"];
                 break;
             default:
                 break;
         }
     }];


}
- (void)shareURL:(NSString *)url withTitle:(NSString *)title des:(NSString *)des andView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"appIcon_180"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@""
                                     images:image
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    [shareParams SSDKSetupWeChatParamsByText:des title:title url:[NSURL URLWithString:url] thumbImage:image image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [shareParams SSDKSetupQQParamsByText:des title:title url:[NSURL URLWithString:url] thumbImage:image image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformTypeQQ];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    
    [ShareSDK showShareActionSheet:view //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformTypeSinaWeibo)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
    [[AnalyticsManager shareInstance] shareEvent];



}
- (void)shareQrimage:(UIImage *)image withView:(UIView *)view {

    CGSize  imagesize = image.size;
    NSLog(@"w : %.2f l : %.2f",imagesize.width, imagesize.height);
//    CGFloat scale = 2;
//    BOOL isedit = NO;
//    NSData *imageData = UIImagePNGRepresentation(image);
//    while (imageData.length/1024 > 300) {
//        imageData = UIImageJPEGRepresentation(image, scale);
//        scale /= 2;
//        isedit = YES;
//        
//    }
//    if (isedit) {
//        image = [UIImage imageWithData:imageData scale:scale];
//    }
    
   
    
    CGSize itemSize = CGSizeMake(240,240);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0,240, 240);
    [image drawInRect:imageRect];
    UIImage * thumImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@""
                                     images:@[image]
                                        url:nil
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    [shareParams SSDKSetupWeChatParamsByText:@"二维码" title:@"二维码" url:[NSURL URLWithString:@"http://www.baidu.com"] thumbImage:thumImage image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [shareParams SSDKSetupQQParamsByText:@"" title:@"" url:nil thumbImage:thumImage image:image type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformTypeQQ];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    
    [ShareSDK showShareActionSheet:view //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformTypeSinaWeibo)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
    [[AnalyticsManager shareInstance] shareEvent];
}

@end
