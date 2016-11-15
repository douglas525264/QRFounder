//
//  AppDelegate.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QRFounderAppDelegate.h"
#import "AnalyticsManager.h"
#import "DXCommenHelper.h"
#import "ShareManager.h"
#import "LaViewController.h"
#import "DXHelper.h"
#import <BaiduMobAdSDK/BaiduMobAdSplash.h>
#import "GDTSplashAd.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
@interface QRFounderAppDelegate ()<GDTSplashAdDelegate,JPUSHRegisterDelegate>

{
    
    UIView *_bgView;
    NSInteger backNumber;
    BOOL hasHide;
}
@property (nonatomic, strong)BaiduMobAdSplash *splash;
@property (nonatomic, retain) UIView *customSplashView;
@property (nonatomic, strong) UIButton *jumpBtn;
@property (nonatomic, strong) NSTimer *backTimer;
@property (strong, nonatomic) GDTSplashAd *gdtSplash;
@property (retain, nonatomic) UIImageView *bottomView;
@end

@implementation QRFounderAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
   // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"001"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:RGB(87, 82, 127, 1)];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[AnalyticsManager shareInstance] startUMSDK];
    [[ShareManager shareInstance] startSDK];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
         [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:@"60d3cc145c063150ad77c2db"
                          channel:@""
                 apsForProduction:NO
            advertisingIdentifier:nil];

    return YES;
}
- (void)addAD {
    hasHide = NO;
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LaViewController *lVC = [mainStory instantiateViewControllerWithIdentifier:@"LaViewController"];
    lVC.view.frame = self.window.bounds;
    UIImage *image = [[DXHelper shareInstance] imageFromView:lVC.view];
    UIColor *bgColor = [UIColor colorWithPatternImage:image];
    
    _bgView = [[UIView alloc] initWithFrame:_window.bounds];
    _bgView.backgroundColor = bgColor;
    
    [_window addSubview:_bgView];
    
    //    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    //    splash.delegate = self;
    //    splash.AdUnitTag = @"2873611";//@"2058492";
    //    splash.canSplashClick = YES;
    //    self.splash = splash;
    //    backNumber = 5;
    //    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = _bgView;
    
    
    
    CGFloat screenWidth = self.window.frame.size.width;
    // CGFloat screenHeight = self.window.frame.size.height;
    
    //在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    //    UIView * baiduSplashContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 150)];
    //
    //    [self.customSplashView addSubview:baiduSplashContainer];
    //
    //    self.jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.jumpBtn.frame = CGRectMake(screenWidth - 100, 40, 80, 30);
    //    self.jumpBtn.layer.cornerRadius = 10;
    //    self.jumpBtn.layer.masksToBounds = YES;
    //    [self.jumpBtn addTarget:self action:@selector(tryDisMissAd) forControlEvents:UIControlEventTouchUpInside];
    //    self.jumpBtn.backgroundColor = RGB(0, 0, 0, 0.4);
    //    [self.jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
    //    [self.jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.customSplashView addSubview:self.jumpBtn];
    //    self.jumpBtn.hidden = YES;
    //    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];
    _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 150)];
    _bottomView.image = image;
    _bottomView.contentMode = UIViewContentModeBottom;
    _bottomView.clipsToBounds = YES;
    _bottomView.backgroundColor = [UIColor redColor];
    
    _gdtSplash = [[GDTSplashAd alloc] initWithAppkey:@"1105762104" placementId:@"4040019558038143"];
    _gdtSplash.delegate = self;//设置代理
    
    //设置开屏拉取时长限制，若超时则不再展示广告
    _gdtSplash.fetchDelay = 3;
    //拉取并展示
    [_gdtSplash loadAdAndShowInWindow:self.window withBottomView:_bottomView];
    
    
    
    [self performSelector:@selector(dismissAd) withObject:nil afterDelay:3];
    //[self checkAppUpdate];


}
-(void)checkAppUpdate
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", @"1152798225"]];
    NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (file &&  [file rangeOfString:@"\"version\":\""].length > 0) {
        NSRange substr = [file rangeOfString:@"\"version\":\""];
        
        NSRange range1 = NSMakeRange(substr.location+substr.length,10);
        NSRange substr2 =[file rangeOfString:@"\"" options:nil range:range1];
        NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
        NSString *newVersion =[file substringWithRange:range2];
        // NSString * newVersion = @"0.0.0";
        if(![nowVersion isEqualToString:newVersion])
        {
            if (IS_IOS8) {
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"版本有更新" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okac = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", @"1152798225"]];
                    [[UIApplication sharedApplication] openURL:url];
                    
                }];
                UIAlertAction *cancelAc= [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVC addAction:okac];
                [alertVC addAction:cancelAc];
                [self.window.rootViewController presentViewController:alertVC animated:YES completion:^{
                    
                }];
            } else {
                //
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新"delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
                [alert show];
            }
        }
 
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", @"1152798225"]];
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    //NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS 10
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - ADDelegate
- (NSString *)publisherId {
    return @"ff5809c5";//@"ccb60059";

}
- (void)changeJumpLable {
    
    backNumber --;
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"%ld 跳过",backNumber] forState:UIControlStateNormal];
}
/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash {

//    if (_bgView) {
//        [_bgView removeFromSuperview];
//    }
    self.jumpBtn.hidden = NO;
    
    self.backTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeJumpLable) userInfo:nil repeats:YES];
    [self.jumpBtn setTitle:@"5 跳过" forState:UIControlStateNormal];
    
}

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason {

    [self tryDisMissAd];

}

/**
 *  广告被点击
 */
- (void)splashDidClicked:(BaiduMobAdSplash *)splash {

}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
    [self tryDisMissAd];
}

/**
 *  广告详情页消失
 */

- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
    [self tryDisMissAd];
}
- (void)tryDisMissAd {
    
    if (_bgView && !hasHide) {
        hasHide = YES;
        [UIView animateWithDuration:0.5 animations:^{
            _bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [_bgView removeFromSuperview];
        }];
        
    }


}
/**
 *  开屏广告成功展示
 */
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    [_bgView removeFromSuperview];
    hasHide = YES;
    //    self.jumpBtn.hidden = NO;
    //
    //    self.backTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeJumpLable) userInfo:nil repeats:YES];
    //    [self.jumpBtn setTitle:@"5 跳过" forState:UIControlStateNormal];
    
}

/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    [self tryDisMissAd];
}
/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd {
    [self tryDisMissAd];
}

// Sent when an splash ad request success to loaded an ad
- (void)dismissAd{

    if (!self.backTimer) {
        [self tryDisMissAd];
    }
}
@end
