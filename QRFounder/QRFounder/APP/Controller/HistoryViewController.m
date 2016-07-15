//
//  HistoryViewController.m
//  QRFounder
//
//  Created by douglas on 16/7/15.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "HistoryViewController.h"
#import "DXCommenHelper.h"
#import "DBManager.h"
#import "QRShowViewController.h"
@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *scanArr;
@property (nonatomic, strong) NSMutableArray *createArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, assign) BOOL isScanShow;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)loadData {
    [[DBManager shareManager] getAllQRModelwithFinishBlock:^(BOOL isOK, NSArray *resultArr) {
        if (isOK) {
            for (QRModel *model in resultArr) {
                if (model.isScanResult) {
                    [self.scanArr addObject:model];
                } else {
                    [self.createArr addObject:model];
                }
            }
            [self reloadUI];
        }
    }];
    
}
- (void)reloadUI {

    [self.tableView reloadData];
}
- (void)createUI {
    self.view.backgroundColor = DefaultColor;
    self.title = @"历史记录";
    self.isScanShow = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 30);
   // btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.sourceSegment addTarget:self action:@selector(changeSource:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.tableView];
    
}
- (void)changeSource:(id)sender{
    self.isScanShow = !self.isScanShow;
    [self reloadUI];
}
- (void)editBtnClick:(UIButton *)sender {

    NSLog(@"edit Btn CLick");
    if (self.tableView.editing) {
      [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [self.selectArr removeAllObjects];
    }else {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isScanShow ? self.scanArr.count : self.createArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        view.backgroundColor = [UIColor clearColor];
       // cell.selectedBackgroundView = view;
        cell.multipleSelectionBackgroundView = view;
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        view1.backgroundColor = RGB(255, 255, 255, 0.4);
        //view1.alpha = 0.6;
        cell.selectedBackgroundView = view1;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.imageView.image = [UIImage imageNamed:@"logo"];
    }
    QRModel *model;
    if (self.isScanShow) {
        model = self.scanArr[indexPath.row];
    } else {
        model = self.createArr[indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = model.QRStr;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
  //  cell.detailTextLabel.text =
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
      return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
    } else {
      return UITableViewCellEditingStyleDelete;
    }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"你选择了删除");
        [self reloadUI];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    QRModel *model;
    if (self.isScanShow) {
        model = self.scanArr[indexPath.row];
    } else {
        model = self.createArr[indexPath.row];
    }

    if (self.tableView.isEditing) {
        [self.selectArr addObject:model];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        QRShowViewController *qVC = [story instantiateViewControllerWithIdentifier:@"QRShowViewController"];
        
        qVC.qrModel = model;
        [self.navigationController pushViewController:qVC animated:YES];
    }

}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    QRModel *model;
    if (self.tableView.isEditing) {
        if (self.isScanShow) {
            model = self.scanArr[indexPath.row];
        } else {
            model = self.createArr[indexPath.row];
        }
        [self.selectArr removeObject:model];

    }

}
#pragma mark - 懒加载
- (NSMutableArray *)scanArr {

    if (!_scanArr) {
        _scanArr = [[NSMutableArray alloc] init];
    }
    return _scanArr;
}
- (NSMutableArray *)createArr {

    if (!_createArr) {
        _createArr = [[NSMutableArray alloc] init];
    }
    return _createArr;
}
- (NSMutableArray *)selectArr {

    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc] init];
    }
    return _selectArr;
}
- (UITableView *)tableView {

    if (!_tableView) {
        CGFloat y = self.sourceSegment.frame.origin.y + self.sourceSegment.frame.size.height + 64;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,y, self.view.frame.size.width, self.view.frame.size.height - y) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor whiteColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      //  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        
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
