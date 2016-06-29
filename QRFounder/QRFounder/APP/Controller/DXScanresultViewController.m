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
#import "MsgView.h"
@interface DXScanresultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXInputTextView *textFiled;
@property (nonatomic, strong) NSMutableArray *paramters;
@property (nonatomic, strong) NSMutableDictionary *paramtersDic;
@property (nonatomic, strong) UIButton *OKBtn;\
@property (nonatomic, strong) MsgView *msgView;
@end

@implementation DXScanresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paramters = [[NSMutableArray alloc] init];
    [self createUI];
    if (self.qrModel) {
        [self loadData];
    }
    // Do any additional setup after loading the view.
}
- (void)createUI {
    
    [self.view addSubview:self.textFiled];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.msgView];
    [self.view addSubview:self.OKBtn];
    self.view.backgroundColor = DefaultColor;
}
- (void)loadData {
    self.paramters = [[DXHelper shareInstance] getparamtersWithQrstr:self.qrModel.QRStr];
    switch (self.qrModel.type) {
        
        case QRTypeMyCard:{
            self.paramters = [[DXHelper shareInstance] getparamtersWithQrstr:self.qrModel.QRStr];
            self.paramtersDic = [[DXHelper shareInstance] getParamtersWithArr:self.paramters];

            self.textFiled.hidden = YES;
            self.msgView.hidden = YES;
            self.tableView.hidden = NO;
            self.OKBtn.hidden = NO;
            self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 80);
            [self.OKBtn setTitle:@"保存到通讯录" forState:UIControlStateNormal];
            [self.tableView reloadData];
            self.title = @"名片";
        }break;
        case QRTypeMsg:{
            self.msgView.hidden = NO;
            self.OKBtn.hidden = NO;
            self.msgView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 80);
            self.tableView.hidden = YES;
            self.textFiled.hidden = YES;
            self.paramters = [[DXHelper shareInstance] getparamtersWithQrstr:self.qrModel.QRStr];
            self.paramtersDic = [[DXHelper shareInstance] getParamtersWithArr:self.paramters];
            self.msgView.sendToTextView.text = [self.paramtersDic objectForKey:SEND_TO_KEY];
            self.msgView.contentTextView.text = [self.paramtersDic objectForKey:SEND_BODY_KEY];
            self.msgView.sendToTextView.editable = NO;
            self.msgView.contentTextView.editable = NO;
            [self.OKBtn setTitle:@"发送" forState:UIControlStateNormal];

        }break;
        case QRTypeWIFI:{
            self.msgView.hidden = YES;
            self.paramters = [[DXHelper shareInstance] getparamtersWithQrstr:self.qrModel.QRStr];
            self.paramtersDic = [[DXHelper shareInstance] getParamtersWithArr:self.paramters];
            
            self.textFiled.hidden = YES;
            self.tableView.hidden = NO;
            self.OKBtn.hidden = NO;
            self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 80);
            [self.OKBtn setTitle:@"前去设置" forState:UIControlStateNormal];
            [self.tableView reloadData];
            self.title = @"WIFI";

        }break;

        default:{
            self.msgView.hidden = YES;
            self.textFiled.hidden = NO;
            self.tableView.hidden = YES;
            self.OKBtn.hidden = YES;
           // NSString *str = self.qrModel.QRStr;
            self.textFiled.text = self.qrModel.QRStr;
            self.title = @"扫描结果";
        }break;
    }
    
    NSLog(@"%@",self.paramters);
    
}
- (void)setQrModel:(QRModel *)qrModel {

    [super setQrModel:qrModel];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardInfoTableViewCell"];
    NSDictionary *info = self.paramters[indexPath.row];
    
    NSString *key = info.allKeys[0];
    cell.nameLable.text = [[DXHelper shareInstance] getLocalNameWithKey:key];
    cell.inputView.text = info[key];
    cell.inputView.editable = NO;
    UIView *slelectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.width)];
    slelectView.backgroundColor = RGB(255, 255, 255, 0.6);
    cell.selectedBackgroundView = slelectView;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;

}
#pragma mark - BtnClick
- (void)okBtnClick:(UIButton *)sender {
    NSLog(@"Btn Click");
    
}
#pragma mark - paivate 
- (DXInputTextView *)textFiled {

    if (!_textFiled) {
        _textFiled = [[DXInputTextView alloc] init];
        _textFiled.frame = self.view.bounds;
        //_textFiled.backgroundColor = [UIColor redColor];
        //_textFiled.textColor = []
       // [self.view addSubview:_textFiled];
    }
    return _textFiled;

}
- (UIButton *)OKBtn {

    if (!_OKBtn) {
        _OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _OKBtn.frame = CGRectMake(self.view.frame.size.width/2 - 80, self.view.frame.size.height - 80, 160, 60);
        [_OKBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _OKBtn;
}
- (MsgView *)msgView {

    if (!_msgView) {
        _msgView = [[[NSBundle mainBundle] loadNibNamed:@"MsgView" owner:self options:nil] lastObject];
        _msgView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 80);
        _msgView.backgroundColor = [UIColor clearColor];
    }
    return _msgView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        if (!_tableView) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
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
