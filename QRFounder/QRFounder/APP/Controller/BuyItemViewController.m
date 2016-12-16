//
//  BuyItemViewController.m
//  QRFounder
//
//  Created by douglas on 2016/12/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BuyItemViewController.h"
#import "BuyCollectionViewCell.h"
@interface BuyItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation BuyItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.sourceItem) {
        return self.sourceItem.items.count;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BuyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuyCollectionViewCell" forIndexPath:indexPath];
    DXSubMenuItem *subItem = self.sourceItem.items[indexPath.row];
    cell.bugitemAvatarImageView.image = subItem.normalImage;
    return cell;

}
- (UICollectionView *)collectionView {

    if (!_collectionView) {
        UICollectionViewFlowLayout *grid = [[UICollectionViewFlowLayout alloc] init];
        grid.itemSize = CGSizeMake(93.0, 93.0);
        grid.sectionInset = UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , self.view.frame.size.height - self.bottomView.frame.size.height) collectionViewLayout:grid];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[BuyCollectionViewCell class] forCellWithReuseIdentifier:@"BuyCollectionViewCell"];
    }
    return _collectionView;
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
