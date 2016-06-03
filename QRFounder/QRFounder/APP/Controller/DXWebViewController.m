//
//  DXWebViewController.m
//  QRFounder
//
//  Created by douglas on 16/5/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXWebViewController.h"

@interface DXWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation DXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)createUI {
    
    //self.tabBarController.tabBar.hidden = YES;
    self.webView.backgroundColor = [UIColor redColor];
}
- (void)setLoadUrl:(NSString *)loadUrl {
    _loadUrl = loadUrl;
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    
}
#pragma mark - 懒加载
- (UIWebView *)webView {

    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}
#pragma maek - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start load : %@",webView.request.URL.absoluteString);

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"load finished : %@",webView.request.URL.absoluteString);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
        NSLog(@"load Error : %@",webView.request.URL.absoluteString);

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
