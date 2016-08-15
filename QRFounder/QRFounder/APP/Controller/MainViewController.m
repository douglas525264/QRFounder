
//
//  MainViewController.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MainViewController.h"
#import "QRFounderAppDelegate.h"
static MainViewController *mainVc;
@interface MainViewController ()
@end

@implementation MainViewController
+ (MainViewController *) shareInstance {

    return mainVc;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    mainVc = self;
    
    self.tabBar.hidden = YES;
    QRFounderAppDelegate *qde = (QRFounderAppDelegate *)[UIApplication sharedApplication].delegate;
    [qde addAD];
   // _btn.titleLabel.textColor = []
    
    //self.tabBar.delegate = self;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
   
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(self.view.frame.size.width - 75, self.view.frame.size.height - 75, 50, 50);
        //_btn.backgroundColor = [UIColor redColor];
        _btn.layer.cornerRadius = 25;
        _btn.layer.masksToBounds = YES;
        _btn.layer.borderColor = [UIColor whiteColor].CGColor;
        _btn.layer.borderWidth = 1;
        _btn.layer.shadowColor = [UIColor whiteColor].CGColor;
        _btn.layer.shadowOffset = CGSizeMake(-4, 1);
        _btn.layer.shadowRadius = 4;
        _btn.layer.shadowOpacity = 0.6;
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitle:@"扫" forState:UIControlStateNormal];
        
        [self.view.superview addSubview:_btn];
        
    }


}
- (void)btnClick {
    if (self.selectedIndex == 0) {
        self.selectedIndex = 1;
        [_btn setTitle:@"建" forState:UIControlStateNormal];
    }else {
        self.selectedIndex = 0;
        [_btn setTitle:@"扫" forState:UIControlStateNormal];
    }
    //1.创建核心动画
    CATransition *ca=[CATransition animation];

    ca.type=@"oglFlip";
         //1.3设置动画的过度方向（向右）
    if (self.selectedIndex == 1) {
        ca.subtype=kCATransitionFromRight;
    } else {
        ca.subtype=kCATransitionFromLeft;
    }
    ca.timingFunction=UIViewAnimationCurveEaseInOut;
//    animation.type=kCATransitionMoveIn;
//    animation.subtype=kCATransitionFromTop;

         //1.4设置动画的时间
         ca.duration= 0.5;
         //1.5设置动画的起点
         ca.startProgress= 0;
    [self.view.layer addAnimation:ca forKey:nil];
    
    CATransition *ca1=[CATransition animation];
    
    ca1.type=@"rippleEffect";
    //1.3设置动画的过度方向（向右）
//    if (self.selectedIndex == 1) {
//        ca1.subtype=kCATransitionFromRight;
//    } else {
//        ca1.subtype=kCATransitionFromLeft;
//    }
//    ca1.timingFunction=UIViewAnimationCurveEaseInOut;
    //    animation.type=kCATransitionMoveIn;
    //    animation.subtype=kCATransitionFromTop;
    
    //1.4设置动画的时间
    ca1.duration= 1;
    //1.5设置动画的起点
    ca1.startProgress= 0.5;

    [self.btn.layer addAnimation:ca1 forKey:nil];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

   // NSLog(@"did click %d",[tabBar.items indexOfObject:item]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
