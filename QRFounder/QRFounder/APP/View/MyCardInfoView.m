
//
//  MyCardInfoView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MyCardInfoView.h"
#import "CardInfoTableViewCell.h"

@interface MyCardInfoView()
@property (nonatomic, strong) NSMutableArray *cells;
@end
@implementation MyCardInfoView
{
    DXInputTextView *nameTextView;
    DXInputTextView *companyTextView;
    DXInputTextView *jobTextView;
    DXInputTextView *telephoneTextView;
    DXInputTextView *phoneTextView;
    DXInputTextView *faxTextView;
    DXInputTextView *mailTextView;
    DXInputTextView *companyAdressTextView;
    DXInputTextView *homePageTextView;
    DXInputTextView *psTextView;
}
- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder: aDecoder];
    if (self) {
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.infoTableView registerNib:[UINib nibWithNibName:@"CardInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CardInfoTableViewCell"];
    self.infoTableView.showsHorizontalScrollIndicator = NO;
    self.infoTableView.backgroundColor = [UIColor clearColor];
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.infoTableView reloadData];
    
}
#pragma  mark - UItableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardInfoTableViewCell *cell;
    if (self.cells.count > indexPath.row) {
        cell = self.cells[indexPath.row];
    } else {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CardInfoTableViewCell" owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        switch (indexPath.row) {
            case 0:{
                cell.nameLable.text = @"姓名";
                nameTextView = cell.inputView;
                cell.inputView.placeHolder = @"姓名";
            }break;
            case 1:{
             cell.nameLable.text = @"公司";
             companyTextView = cell.inputView;
             cell.inputView.placeHolder = @"公司";
            }break;
            case 2:{
             cell.nameLable.text = @"职位";
             jobTextView = cell.inputView;
             cell.inputView.placeHolder = @"职位";
            }break;
            case 3:{
             cell.nameLable.text = @"移动电话";
             telephoneTextView = cell.inputView;
             cell.inputView.placeHolder = @"移动电话";
            }break;
            case 4:{
             cell.nameLable.text = @"传真";
             phoneTextView = cell.inputView;
             cell.inputView.placeHolder = @"传真";
            }break;
            case 5:{
             cell.nameLable.text = @"邮箱";
             mailTextView = cell.inputView;
             cell.inputView.placeHolder = @"邮箱";
            }break;
            case 6:{
             cell.nameLable.text = @"公司地址";
             companyAdressTextView = cell.inputView;
             cell.inputView.placeHolder = @"公司地址";
            }break;
            case 7:{
             cell.nameLable.text = @"主页地址";
             homePageTextView = cell.inputView;
             cell.inputView.placeHolder = @"主页地址";
            }break;
            case 8:{
             cell.nameLable.text = @"备注";
             psTextView = cell.inputView;
             cell.inputView.placeHolder = @"备注";
            }break;
            case 9:{
                
            }break;
                
            default:
                break;
        }
        [self.cells addObject:cell];
    }
//     = [tableView dequeueReusableCellWithIdentifier:@"CardInfoTableViewCell"];
    
    
    
    
    return cell;
}
- (NSString *)getResultInfoStr {
    
    
    return [self getVcardStr];
}
- (NSString *)getVcardStr {
  NSMutableString *resultStr = [[NSMutableString alloc] init];
    [resultStr appendString:@"BEGIN:VCARD\n"];
    [resultStr appendString:@"VERSION:3.0\n"];
    
    if (nameTextView.text.length > 0) {
      [resultStr appendFormat:@"N:%@\n",nameTextView.text];
    }
    if (mailTextView.text.length > 0) {
        [resultStr appendFormat:@"EMAIL:%@\n",mailTextView.text];
    }
    if (telephoneTextView.text.length > 0) {
        [resultStr appendFormat:@"TEL;CELL:%@\n",telephoneTextView.text];
    }
    if (phoneTextView.text.length > 0) {
        [resultStr appendFormat:@"TEL:%@\n",phoneTextView.text];
    }
    if (faxTextView.text.length > 0) {
        [resultStr appendFormat:@"TEL;WORK;FAX:%@\n",faxTextView.text];
    }
    if (companyTextView.text.length > 0) {
        [resultStr appendFormat:@"ORG:%@\n",companyTextView.text];
    }
    
    if (companyAdressTextView.text.length > 0) {
        [resultStr appendFormat:@"ADR;TYPE=WORK:%@\n",companyAdressTextView.text];
    }
    
    if (homePageTextView.text.length > 0) {
        [resultStr appendFormat:@"URL:%@\n",homePageTextView.text];
    }
    if (psTextView.text.length > 0) {
        [resultStr appendFormat:@"NOTE:%@\n",psTextView.text];
    }
    
    [resultStr appendString:@"END:VCARD"];
    
    return resultStr;
}
- (NSMutableArray *)cells {

    if (!_cells) {
        _cells = [[NSMutableArray alloc] init];
    }
    return _cells;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
