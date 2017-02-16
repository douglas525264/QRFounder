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
@interface DownloadItemTableViewController ()
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

}
- (void)managerClick:(id)sender {
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DownloadItemTableViewController *byVC = [mainStory instantiateViewControllerWithIdentifier:@"DownloadItemTableViewController"];
    byVC.isManager = YES;
    [self.navigationController pushViewController:byVC animated:YES];

}
- (void)loadData {
    if (self.isManager) {
        
    } else {
        @weakify(self);
        [DXNetworkTool postWithPath:sourceURL postBody:@{@"type": @"4"} andHttpHeader:@{@"type": @"4"} completed:^(NSDictionary *json, NSString *stringdata, NSInteger code) {
            @strongify(self)
            NSArray *sourr = json[@"json"];
            if (sourr && sourr.count > 0) {
                for (NSDictionary *infoDic in sourr) {
                    SourceItemModel *model = [[SourceItemModel alloc] init];
                    [model configWithJson:infoDic];
                    [self.sourceArr addObject:model];
                }
                [self.tableView reloadData];
            }
            
        } failed:^(DXError *error) {
            
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
    
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell...
    
    return cell;
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
