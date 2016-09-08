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
}
@property (nonatomic, strong)BaiduMobAdSplash *splash;
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
    
    
    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self; //把在mssp.baidu.com上创建后获得的代码位id写到这里 splash.AdUnitTag = @"2058492";
    splash.AdUnitTag = @"2873611";
    splash.canSplashClick = YES;
    [splash loadAndDisplayUsingKeyWindow:self.window];
    self.splash = splash;
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
    return @"ff5809c5";

}
// Sent when an splash ad request success to loaded an ad
- (void)dismissAd{

    [_bgView removeFromSuperview];
}
@end
