//
//  DXScanresultViewController.m
//  QRFounder
//
//  Created by Douglas on 16/6/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXScanresultViewController.h"
#import "CardInfoTableViewCell.h"
@interface DXScanresultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXInputTextView *textFiled;
@property (nonatomic, strong) NSMutableDictionary *paramters;
@end

@implementation DXScanresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paramters.allValues.count;
    
}
#pragma mark - paivate 
- (DXInputTextView *)textFiled {

    if (!_textFiled) {
        _textFiled = [[DXInputTextView alloc] init];
        _textFiled.frame = self.view.bounds;
        [self.view addSubview:_textFiled];
    }
    return _textFiled;

}
- (UITableView *)tableView {
    if (!_tableView) {
        if (!_tableView) {
            _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.backgroundColor = [UIColor clearColor];
            [_tableView registerNib:[UINib nibWithNibName:@"CardInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CardInfoTableViewCell"];
            
        }
    }
    return _tableView;
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
