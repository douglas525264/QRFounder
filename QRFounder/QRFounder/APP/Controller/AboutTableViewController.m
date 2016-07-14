//
//  AboutTableViewController.m
//  QRFounder
//
//  Created by douglas on 16/7/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "AboutTableViewController.h"
#import "DXCommenHelper.h"
#import "DXHelper.h"
#import <UMFeedback.h>
@interface AboutTableViewController ()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *versionLable;
@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    self.title = @"关于";
    [self createUI];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)createUI {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    self.imageView.frame = CGRectMake(self.view.frame.size.width/2 - 30, 30, 60, 60);
    self.imageView.layer.cornerRadius = 5;
    self.imageView.image = [UIImage imageNamed:@"logo"];
    [headerView addSubview:self.imageView];
    self.versionLable.frame = CGRectMake(0, self.imageView.frame.origin.y + self.imageView.frame.size.height + 10, self.view.frame.size.width, 20);
    self.versionLable.textColor = [UIColor whiteColor];
    self.versionLable.text = [NSString stringWithFormat:@"v%@",[DXHelper getVersionCode]];
    self.versionLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.versionLable];
    self.tableView.tableHeaderView = headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            NSString *strUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id576309271"];
            NSURL *url = [NSURL URLWithString:strUrl];
            [[UIApplication sharedApplication] openURL:url];
 
        }break;
        case 1:{
         [UMFeedback showFeedback:self withAppkey:@"57833c7f67e58e11620000ff"];
        }break;
        case 2:{
            
        }break;
            
        default:
            break;
    }
    
   // [[RootMainViewController shareInstand].navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];

}
#pragma maek - 懒加载
- (UIImageView *)imageView {

    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        
    }
    return _imageView;
}
- (UILabel *)versionLable {
    if (!_versionLable) {
        _versionLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 24)];
    }
    return _versionLable;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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