//
//  DXScanresultViewController.m
//  QRFounder
//
//  Created by Douglas on 16/6/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXScanresultViewController.h"
#import "CardInfoTableViewCell.h"
#import "DXHelper.h"
@interface DXScanresultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXInputTextView *textFiled;
@property (nonatomic, strong) NSMutableArray *paramters;
@property (nonatomic, strong) NSMutableDictionary *paramtersDic;
@property (nonatomic, strong) UIButton *OKBtn;
@end

@implementation DXScanresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paramters = [[NSMutableArray alloc] init];
    [self createUI];
    if (self.qrmodel) {
        [self loadData];
    }
    // Do any additional setup after loading the view.
}
- (void)createUI {
    
    [self.view addSubview:self.textFiled];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.OKBtn];
    self.view.backgroundColor = DefaultColor;
}
- (void)loadData {
    self.paramters = [[DXHelper shareInstance] getparamtersWithQrstr:self.qrmodel.QRStr];
    self.paramtersDic = [[DXHelper shareInstance] getParamtersWithArr:self.paramters];
    switch (self.qrmodel.type) {
        case QRTypeMyCard:{
            self.textFiled.hidden = YES;
            self.tableView.hidden = NO;
            self.OKBtn.hidden = NO;
            self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 80);
            [self.OKBtn setTitle:@"保存到通讯录" forState:UIControlStateNormal];
        }break;
        case QRTypeMail:{
            
        }break;
        case QRTypeWIFI:{
            
        }break;
            
        case QRTypeText:{
            
        }break;
            
        default:
            break;
    }
    
    NSLog(@"%@",self.paramters);
    [self.tableView reloadData];
}
- (void)setQrmodel:(QRModel *)qrmodel {
    _qrmodel = qrmodel;
    
    [self loadData];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paramters.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardInfoTableViewCell"];
    NSDictionary *info = self.paramters[indexPath.row];
    
    NSString *key = info.allKeys[0];
    cell.nameLable.text = [[DXHelper shareInstance] getLocalNameWithKey:key];
    cell.inputView.text = info[key];
    cell.inputView.editable = NO;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;

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
- (UIButton *)OKBtn {

    if (!_OKBtn) {
        _OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _OKBtn.frame = CGRectMake(self.view.frame.size.width/2 - 80, self.view.frame.size.height - 80, 160, 60);
        
    }
    return _OKBtn;
}
- (UITableView *)tableView {
    if (!_tableView) {
        if (!_tableView) {
            _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
