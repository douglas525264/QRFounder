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
#import "DMSplashAdController.h"
#import "DMRTSplashAdController.h"
#import "LaViewController.h"
#import "DXHelper.h"
@interface QRFounderAppDelegate ()<DMSplashAdControllerDelegate>
{
    DMSplashAdController *_splashAd;
    UIView *_bgView;
}

@end

@implementation QRFounderAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
   // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"001"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:RGB(33, 188, 255, 1)];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[AnalyticsManager shareInstance] startUMSDK];
    [[ShareManager shareInstance] startSDK];
    
    //});
    
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
    
    [_window.rootViewController.view addSubview:_bgView];
    // 设置适合的背景图片
    // Set background image
    NSString *defaultImgName = @"Default";
    CGFloat offset = 0.0f;
    CGSize adSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        adSize = DOMOB_AD_SIZE_768x576;
        defaultImgName = @"Default-Portrait";
        offset = 374.0f;
    } else {
        adSize = DOMOB_AD_SIZE_320x400;
        if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
            defaultImgName = @"Default-568h";
            offset = 233.0f;
        } else {
            offset = 168.0f;
        }
    }
    //  [UIView setAnimationDuration:2.0];
    BOOL isCacheSplash = NO;
    // 选择测试缓存开屏还是实时开屏，NO为实时开屏。
    // Choose NO or YES for RealTimeSplashView or SplashView
    // 初始化开屏广告控制器，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
    // Get your ID from Domob website
    
    NSString* testPubID = @"56OJ2XeouNyyVYYzVk";
    NSString* testSplashPlacementID = @"16TLP2vvApalANUU2pMjZgbs";
  
    
    if (isCacheSplash) {
        _splashAd = [[DMSplashAdController alloc] initWithPublisherId:testPubID
                                                          placementId:testSplashPlacementID
                                                               window:self.window
                                                           background:bgColor
                                                            animation:YES];
        _splashAd.delegate = self;
        if (_splashAd.isReady)
        {
            [_splashAd present];
            
        }
        
    } else {
        DMRTSplashAdController* rtsplashAd = nil;
        rtsplashAd = [[DMRTSplashAdController alloc] initWithPublisherId:testPubID
                                                             placementId:testSplashPlacementID
                                                                    size:adSize
                                                                  offset:0
                                                                  window:self.window
                                                              background:bgColor
                                                               animation:NO];
        
        
        rtsplashAd.delegate = self;
        [rtsplashAd present];
        
    }
  
    [self performSelector:@selector(dismissAd) withObject:nil afterDelay:2];

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
// Sent when an splash ad request success to loaded an ad
- (void)dmSplashAdSuccessToLoadAd:(DMSplashAdController *)dmSplashAd {

    [_bgView removeFromSuperview];
}
// Sent when an ad request fail to loaded an ad
- (void)dmSplashAdFailToLoadAd:(DMSplashAdController *)dmSplashAd withError:(NSError *)err {
    [_bgView removeFromSuperview];
}
- (void)dismissAd{

    [_bgView removeFromSuperview];
}
@end
