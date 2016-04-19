
//
//  MainViewController.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tabBar.delegate = self;
    // Do any additional setup after loading the view.
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
