//
//  BuyItemViewController.m
//  QRFounder
//
//  Created by douglas on 2016/12/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BuyItemViewController.h"
#import "BuyCollectionViewCell.h"
#import "DXHelper.h"
#import "PayViewController.h"
#import "UILabel+ZYTool.h"
#import "Lockmanager.h"
@interface BuyItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation BuyItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = DefaultColor;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    self.payBtn.layer.borderWidth = 1;
    self.payBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.payBtn.layer.cornerRadius = 5;
    [self.payBtn setTitle:[NSString stringWithFormat:@"解锁全部素材:%.0f元",[self getPrice]] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
- (void)setSourceItem:(DXmenuItem *)sourceItem {

    _sourceItem = sourceItem;
    self.navigationItem.title = _sourceItem.title;
    [self.collectionView reloadData];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UILabel *deslab = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, self.view.frame.size.width - 40 - 10, 90)];
    
    deslab.text = self.sourceItem.des;
    deslab.textColor = [UIColor whiteColor];
    deslab.textAlignment = NSTextAlignmentLeft;
    deslab.font = [UIFont systemFontOfSize:14];
    deslab.lineBreakMode = NSLineBreakByCharWrapping;
    deslab.numberOfLines = 0;
    deslab.backgroundColor = [UIColor clearColor];
    [deslab AdjustCurrentFont];
    
    
    UICollectionReusableView *collResView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"View" forIndexPath:indexPath];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 40, 20)];
    lable.text = @"描述:";
    
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:14];
    [lable AdjustCurrentFont];
    [collResView addSubview:lable];
    [collResView addSubview:deslab];
    return collResView;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BuyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuyCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    DXSubMenuItem *subItem = self.sourceItem.items[indexPath.row];
    cell.bugitemAvatarImageView.image = subItem.normalImage;
    return cell;

}
- (UICollectionView *)collectionView {

    if (!_collectionView) {
        UICollectionViewFlowLayout *grid = [[UICollectionViewFlowLayout alloc] init];
        grid.itemSize = CGSizeMake(93.0, 93.0);
        grid.sectionInset = UIEdgeInsetsMake(0.0, 20.0, 20.0, 20.0);
        
        UILabel *deslab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, self.view.frame.size.width - 40 - 10, 90)];
        
        deslab.text = self.sourceItem.des;
        deslab.font = [UIFont systemFontOfSize:14];
        [deslab AdjustCurrentFont];
        
        grid.headerReferenceSize = CGSizeMake( self.view.frame.size.width, deslab.frame.size.height + 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame.size.width , self.view.frame.size.height - self.bottomView.frame.size.height - 64) collectionViewLayout:grid];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"View"];
        [_collectionView  registerNib:[UINib nibWithNibName:@"BuyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BuyCollectionViewCell"];
    }
    return _collectionView;
}
- (IBAction)paybtnCLick:(id)sender {
    PayViewController *pvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PayViewController"];
    pvc.name = self.sourceItem.title;
    pvc.price = [self getPrice];
    pvc.idStr = self.sourceItem.itemId;
    pvc.desStr = self.sourceItem.title;
    [pvc setStatusBlock:^(NSString *idstr, CEPaymentStatus st) {
        if (st == kCEPayResultSuccess && [self.sourceItem.itemId isEqualToString:idstr]) {
            
            NSMutableArray *unlockArr = [[NSMutableArray alloc] init];
            NSInteger i = 0;
            for (DXSubMenuItem *sub in self.sourceItem.items) {
                if (sub.isLock) {
                    [unlockArr addObject:@(i)];
                   
                }
                i++;
            }
            if (unlockArr.count >0) {
                [[Lockmanager shareInstance]  unlock:idstr atIndexs:unlockArr];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
    }];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (CGFloat)getPrice{

    CGFloat allPrice = 0;
    for (DXSubMenuItem *subItem in self.sourceItem.items) {
        if (subItem.price) {
            allPrice += subItem.price;
        }
    }
    return allPrice;
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
