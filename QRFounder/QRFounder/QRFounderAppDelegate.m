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
@interface QRFounderAppDelegate ()<BaiduMobAdSplashDelegate>

{
    
    UIView *_bgView;
    NSInteger backNumber;
}
@property (nonatomic, strong)BaiduMobAdSplash *splash;
@property (nonatomic, retain) UIView *customSplashView;
@property (nonatomic, strong) UIButton *jumpBtn;
@property (nonatomic, strong) NSTimer *backTimer;
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
    
    
//    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
//    splash.delegate = self; //把在mssp.baidu.com上创建后获得的代码位id写到这里 splash.AdUnitTag = @"2058492";
//    splash.AdUnitTag = @"2058492";//@"2873611";
//    splash.canSplashClick = YES;
//    [splash loadAndDisplayUsingKeyWindow:self.window];
//    self.splash = splash;
    //});
//

 // [NSThread sleepForTimeInterval:2.0];
  //  [_window makeKeyAndVisible];

   // [UINavigationBar appearance].translucent = NO;
   // [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    return YES;
}
- (void)addAD {
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LaViewController *lVC = [mainStory instantiateViewControllerWithIdentifier:@"LaViewController"];
    lVC.view.frame = self.window.bounds;
    UIImage *image = [[DXHelper shareInstance] imageFromView:lVC.view];
    UIColor *bgColor = [UIColor colorWithPatternImage:image];
    
    _bgView = [[UIView alloc] initWithFrame:_window.bounds];
    _bgView.backgroundColor = bgColor;
    
    [_window addSubview:_bgView];

    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    splash.AdUnitTag = @"2873611";//@"2058492";
    splash.canSplashClick = YES;
    self.splash = splash;
    backNumber = 5;
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = _bgView;
  
   
    
    CGFloat screenWidth = self.window.frame.size.width;
    CGFloat screenHeight = self.window.frame.size.height;
    
    //在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    UIView * baiduSplashContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 150)];
    
    [self.customSplashView addSubview:baiduSplashContainer];
    
    self.jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jumpBtn.frame = CGRectMake(screenWidth - 100, 40, 80, 30);
    self.jumpBtn.layer.cornerRadius = 10;
    self.jumpBtn.layer.masksToBounds = YES;
    [self.jumpBtn addTarget:self action:@selector(tryDisMissAd) forControlEvents:UIControlEventTouchUpInside];
    self.jumpBtn.backgroundColor = RGB(0, 0, 0, 0.4);
    [self.jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [self.jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.customSplashView addSubview:self.jumpBtn];
    self.jumpBtn.hidden = YES;
    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];
    
    [self performSelector:@selector(tryDisMissAd) withObject:nil afterDelay:10];
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    if (_bgView) {
        [_bgView removeFromSuperview];
    }


}
// Sent when an splash ad request success to loaded an ad
- (void)dismissAd{

    [_bgView removeFromSuperview];
}
@end
