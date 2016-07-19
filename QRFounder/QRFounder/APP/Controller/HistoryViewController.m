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
#import "HistoryViewController.h"
#import "DXBottomActionView.h"
@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *scanArr;
@property (nonatomic, strong) NSMutableArray *createArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, assign) BOOL isScanShow;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) DXBottomActionView *bottomView;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
    
    // Do any additional setup after loading the view.
}
- (void)loadData {
     __weak HistoryViewController *weakSelf = self;
    [[DBManager shareManager] getAllQRModelwithFinishBlock:^(BOOL isOK, NSArray *resultArr) {
        __strong HistoryViewController *strongSelf = weakSelf;
        if (isOK) {
            for (QRModel *model in resultArr) {
                if (model.isScanResult) {
                    [strongSelf.scanArr addObject:model];
                } else {
                    [strongSelf.createArr addObject:model];
                }
            }
            [strongSelf reloadUI];
            [strongSelf cheakEnable];
        }
    }];
    
}
- (void)reloadUI {
    
    [self.tableView reloadData];
}
- (void)cheakEnable {
    if (self.isScanShow) {
        self.rightBtn.enabled = self.scanArr.count > 0;
    } else {
        self.rightBtn.enabled = self.createArr.count > 0;
    }

    
}
- (void)createUI {
    self.view.backgroundColor = DefaultColor;
    self.title = @"历史记录";
    self.isScanShow = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = btn;
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
    if (self.isScanShow) {
        self.bottomView.allcount = self.scanArr.count;
    } else {
    
        self.bottomView.allcount = self.createArr.count;
    }
    if (self.tableView.isEditing) {
        [self editBtnClick:self.rightBtn];
    }
    [self reloadUI];
    
    [self dismisPop];
    [self cheakEnable];
}
- (void)editBtnClick:(UIButton *)sender {

    NSLog(@"edit Btn CLick");
    if (self.tableView.editing) {
      
        [self dismisPop];
      [self.tableView setEditing:NO animated:YES];
      [sender setTitle:@"编辑" forState:UIControlStateNormal];
     // [self.selectArr removeAllObjects];
        
    }else {
        [self showPop];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        view.backgroundColor = [UIColor clearColor];
       // cell.selectedBackgroundView = view;
        cell.multipleSelectionBackgroundView = view;
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        view1.backgroundColor = RGB(255, 255, 255, 0.4);
        //view1.alpha = 0.6;
        cell.selectedBackgroundView = view1;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        UILabel *av = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        av.text = @">";
//        av.textColor = [UIColor whiteColor];
//        
        cell.tintColor = [UIColor whiteColor];
        
        
        //cell.imageView.image = [UIImage imageNamed:@"logo"];
    }
    QRModel *model;
    if (self.isScanShow) {
        model = self.scanArr[indexPath.row];
    } else {
        model = self.createArr[indexPath.row];
    }
    if ([self.selectArr containsObject:model]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = model.QRStr;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [NSString getTimeStrFromTimestamp:model.createTime];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
  //  cell.detailTextLabel.text =
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
// 自定义左滑显示编辑按钮

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {
        NSLog(@"你选择了删除");
        QRModel *model;
        if (self.isScanShow) {
            model = self.scanArr[indexPath.row];
            [self.scanArr removeObject:model];
        } else {
            model = self.createArr[indexPath.row];
            [self.createArr removeObject:model];
        }
        [[DBManager shareManager] asyDeleteModel:model];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self cheakEnable];

        
                                                                             
    }];
    
    
    rowAction.backgroundColor = [UIColor colorWithRed:252/255.0f green:88/255.0f blue:112/255.0f alpha:1];
    
    NSArray *arr = @[rowAction];
    return arr;
}
- (UIView *)memberOfTableView:(UIView *)object {

    return nil;
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
       // [self reloadUI];
    }//
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
        self.bottomView.count = self.selectArr.count;
        
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
        self.bottomView.count = self.selectArr.count;

    }

}
- (void)showPop{

    
    [self.bottomView showInView:self.view];
}
- (void)dismisPop {

    [self.bottomView dismisswithAnimation:YES];
    [self.selectArr removeAllObjects];
    self.bottomView.count = 0;
}
#pragma mark - 懒加载
- (DXBottomActionView *)bottomView {

    if (!_bottomView) {
        __weak HistoryViewController *weakSelf = self;
        _bottomView = [DXBottomActionView popWithCommendArr:@[@(DXBottomActionMenuSelectAll),@(DXBottomActionMenuDelete)] andBlock:^(DXBottomActionView *bpc, DXBottomActionMenu command) {
            __strong HistoryViewController *strongSelf = weakSelf;
            switch (command) {
                case DXBottomActionMenuSelectAll:{
                    [strongSelf.selectArr removeAllObjects];
                    if (strongSelf.isScanShow) {
                        [strongSelf.selectArr addObjectsFromArray:strongSelf.scanArr];
                    } else {
                        [strongSelf.selectArr addObjectsFromArray:strongSelf.createArr];
                    }
                    bpc.count = strongSelf.selectArr.count;
                    [strongSelf reloadUI];
                    
                    
                }break;
                case DXBottomActionMenuNOTSelectAll:{
                    [strongSelf.selectArr removeAllObjects];
                    bpc.count = strongSelf.selectArr.count;
                    [strongSelf reloadUI];
                }break;
                case DXBottomActionMenuDelete:{
                    
                    NSMutableArray *deleteArr = [[NSMutableArray alloc] init];
                    for (QRModel *model in strongSelf.selectArr) {
                        NSIndexPath *p;
                        if (strongSelf.isScanShow) {
                            p = [NSIndexPath indexPathForRow:[strongSelf.scanArr indexOfObject:model] inSection:0];
                        } else {
                            p = [NSIndexPath indexPathForRow:[strongSelf.createArr indexOfObject:model] inSection:0];
                        }
                        [deleteArr addObject:p];
                        
                    }
                    if (strongSelf.isScanShow) {
                        [strongSelf.scanArr removeObjectsInArray:strongSelf.selectArr];
                        bpc.allcount = strongSelf.scanArr.count;
                    } else {
                        [strongSelf.createArr removeObjectsInArray:strongSelf.selectArr];
                        bpc.allcount = strongSelf.createArr.count;
                    }
                    [[DBManager shareManager] deleteModels:[NSArray arrayWithArray:self.selectArr]];
                    
                    [strongSelf.selectArr removeAllObjects];
                    [strongSelf.tableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationFade];
                    [bpc dismisswithAnimation:YES];
                    [strongSelf editBtnClick:strongSelf.rightBtn];
                    [strongSelf cheakEnable];

                }break;
                    
                default:
                    break;
            }
            
        }];
        _bottomView.backgroundColor = [UIColor clearColor];
        if (self.isScanShow) {
         _bottomView.allcount = self.scanArr.count;
        } else {
         _bottomView.allcount = self.createArr.count;
        }
        
        
    }
    return _bottomView;
}
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
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor whiteColor];
        _tableView.tintColor = [UIColor whiteColor];
      //  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        
    }
    return _tableView;
}
- (void)dealloc {

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
