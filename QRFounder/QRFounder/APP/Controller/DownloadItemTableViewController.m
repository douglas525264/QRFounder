//
//  DownloadItemTableViewController.m
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import "DownloadItemTableViewController.h"
#import "DownloadTableViewCell.h"
#import "DXHelper.h"
#import "SourceItemModel.h"
#import <RACEXTScope.h>
#import "DownloadManager.h"
#import "QRSourceManager.h"
@interface DownloadItemTableViewController ()<DownloadTaskDelegate>
@property (nonatomic, strong) NSMutableArray *sourceArr;
@end

@implementation DownloadItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)createUI {
    if (self.isManager) {
        self.title = @"我的素材";
    } else {
        self.title = @"全部素材";
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(managerClick:)];
        self.navigationItem.rightBarButtonItem = right;

    }
    
    self.view.backgroundColor = DefaultColor;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageV.image = [[DXHelper shareInstance] getBgImage];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = imageV;
    if (!self.isManager) {
        [DownloadManager shareInstance].delegate = self;
    }
}
- (void)managerClick:(id)sender {
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DownloadItemTableViewController *byVC = [mainStory instantiateViewControllerWithIdentifier:@"DownloadItemTableViewController"];
    byVC.isManager = YES;
    byVC.type = self.type;
    @weakify(self);
    [byVC setDeleteCallBack:^(NSString *sid) {
        @strongify(self)
        for (SourceItemModel *model in self.sourceArr) {
            if([model.sId isEqualToString:sid]) {
                model.status = TaskStatusIdle;
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        });
    }];
    [self.navigationController pushViewController:byVC animated:YES];

}
- (void)loadData {
    NSArray *hasd = [[QRSourceManager shareInstance] getHasDownLoadItemsWithtype:self.type];
    
    if (self.isManager) {
        if (hasd && hasd.count > 0) {
            [self.sourceArr addObjectsFromArray:hasd];
        }
    } else {
        @weakify(self);
        [[QRSourceManager shareInstance] getItemListwithtype:self.type withFinishedBlock:^(BOOL isok, NSArray *arr) {
            if (isok) {
                @strongify(self)
                
                [self.sourceArr addObjectsFromArray:arr];
                if (hasd && hasd.count > 0) {
                    for (SourceItemModel *model in self.sourceArr) {
                        for (SourceItemModel *kk in hasd) {
                            if ([model.sId isEqualToString:kk.sId]) {
                                model.status = TaskStatusFinished;
                                break;
                            }
                        }
                    }
                }
                [self.tableView reloadData];
            }
        }];
                
    }
}
- (NSMutableArray *)sourceArr {

    if (!_sourceArr) {
        _sourceArr = [[NSMutableArray alloc] init];
    }
    return _sourceArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.sourceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadTableViewCell" forIndexPath:indexPath];
    SourceItemModel *model = self.sourceArr[indexPath.row];
    [cell configWithModel:model];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (self.isManager) {
        cell.downLoadBtn.enabled = YES;
        [cell.downLoadBtn setTitle:@"移除" forState:UIControlStateNormal];
    }
    @weakify(self);
    [cell setDownLoadCallBack:^{
        @strongify(self);
        if (self.isManager) {
            [self deleteWithModel:model];
        }else {
        [self downLoadWithModel:model];
        }
    }];
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell...
    
    return cell;
}

- (void)downLoadWithModel:(SourceItemModel *)model {
    
    NSLog(@"downLoad %@",model.remoteUrl);
    DownloadTask *task = [[DownloadTask alloc] init];
    task.downLoadURL = model.remoteUrl;
    task.tempSavePath = [NSString stringWithFormat:@"%@/%@",[QRSourceManager getTempSavapath],task.downLoadURL.lastPathComponent];
    task.filePath = [self getPathWithType:self.type];
    task.taskID = model.sId;
    
    [[DownloadManager shareInstance] addATask:task];
    [[DownloadManager shareInstance] startTaskWithId:task.taskID];
}
- (NSString *)getPathWithType:(QREditType)type {
    switch (type) {
        case QREditTypeDIY:
            return [QRSourceManager getDIYPath];
            break;
        case QREditTypeLogo:
            return [QRSourceManager getLogoPath];
            break;
        case QREditTypeBoarder:
            return [QRSourceManager getBorderPath];
            break;
        case QREditTypeBg:
            return [QRSourceManager getBGPath];
            break;
        default:
            return @"";
            break;
    }
}
- (SourceItemModel *)getmodelWithID:(NSString *)sid {

    for (SourceItemModel *model in self.sourceArr) {
        if ([model.sId isEqualToString:sid]) {
            return model;
        }
    }
    return nil;
}
#pragma mark - DownloadTaskDelegate
- (void)downloadtask:(DownloadTask *)task statusChange:(DownloadTaskStatus)status {
    SourceItemModel *model = [self getmodelWithID:task.taskID];
    if (model) {
        model.status = status;
        NSInteger row = [self.sourceArr indexOfObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
        
    }
}
- (void)downloadtask:(DownloadTask *)task progressCahnge:(CGFloat) progress {
    SourceItemModel *model = [self getmodelWithID:task.taskID];
    model.progress = progress;
    if (model) {
        NSInteger row = [self.sourceArr indexOfObject:model];
        DownloadTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if (cell) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [cell setProgress:progress];
            });
        }
  
    }
}
- (void)deleteWithModel:(SourceItemModel *)model {
    [[QRSourceManager shareInstance] deleteDownload:model.sId withtype:model.type];
    [self.sourceArr removeObject:model];
    [self.tableView reloadData];
    if (self.deleteCallBack) {
        self.deleteCallBack(model.sId);
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
