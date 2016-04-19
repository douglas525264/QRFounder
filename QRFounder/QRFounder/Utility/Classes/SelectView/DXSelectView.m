//
//  DXSelectView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXSelectView.h"
#import "DXCommenHelper.h"
@interface DXSelectView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imageArr;
@end
@implementation DXSelectView
- (id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr andIconArr:(NSArray *)iconArr {
    self = [super initWithFrame:frame];
    if (self) {
        _titleArr = titleArr;
        _imageArr = iconArr;
    }
    return self;

}
#pragma mark - UITableViewDatasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.selectedCallBackBlock) {
        self.selectedCallBackBlock(indexPath.row);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.titleArr) {
     return self.titleArr.count;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.frame.size.height/self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectTableViewCell"];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
#pragma mark - 懒加载
- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)show {
    self.tableView.frame = self.bounds;
    [self addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor whiteColor];
    if (!self.tintColor) {
        self.tintColor = DefaultColor;
    }
    
    self.backgroundColor = self.tintColor;
}
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}

@end
