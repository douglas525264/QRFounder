
//
//  MyCardInfoView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MyCardInfoView.h"
#import "CardInfoTableViewCell.h"
#import <AddressBookUI/AddressBookUI.h>
#import "MainViewController.h"
@interface MyCardInfoView()<ABPeoplePickerNavigationControllerDelegate>
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
- (IBAction)addBtnClick:(id)sender {
    
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [[MainViewController shareInstance] presentViewController:peoplePicker animated:YES completion:nil];

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
#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    //获取个人名字
//    CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
//    CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef abFullName = ABRecordCopyCompositeName(person);
    NSString *fullName = (__bridge NSString *)abFullName;
    nameTextView.text = fullName;
    ABPropertyID multiProperties[] = {
        kABPersonPhoneProperty,
        kABPersonEmailProperty
    };
    NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
    NSMutableString *telStr = [[NSMutableString alloc] init];
    NSMutableString *mailStr = [[NSMutableString alloc] init];
    for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
        ABPropertyID property = multiProperties[j];
        ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
        NSInteger valuesCount = 0;
        if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
        
        if (valuesCount == 0) {
            if (valuesRef !=nil) {
              CFRelease(valuesRef);
            }
            continue;
        }
        //获取电话号码和email
        
        for (NSInteger k = 0; k < valuesCount; k++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
            if (j == 0) {
                NSString *ph = (__bridge NSString*)value;
                NSLog(@"%@",ph);
                if (ph) {
                    [telStr appendFormat:@"%@%@",ph, k == (valuesCount - 1) ? @"" : @","];
                }
            }
            if (j == 1) {
                NSString *mai = (__bridge NSString*)value;
                NSLog(@"%@",mai);
                if (mai) {
                    [mailStr appendFormat:@"%@%@",mai, k == (valuesCount - 1) ? @"" : @","];
                }

            }
//            switch (j) {
//                case 0: {// Phone number
//                    
//                }break;
//                case 1: {// Email
//                    NSString *mail = (__bridge NSString*)value;
//                    
//                }break;
//            }
            CFRelease(value);
        }
        
        if (valuesRef !=nil) {
            CFRelease(valuesRef);
        }

       // CFRelease(valuesRef);
    }
    telephoneTextView.text = telStr;
    mailTextView.text = mailStr; 
    //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
 //   [addressBookTemp addObject:addressBook];
    
    if (abFullName) CFRelease(abFullName);

//    NSString *nameString = (__bridge NSString *)abName;
//    NSString *lastNameString = (__bridge NSString *)abLastName;
    //电话
//    ABMultiValueRef multiValue = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    if (multiValue) {
//        
//        CFIndex index = ABMultiValueGetIndexForIdentifier(multiValue,kABPersonPhoneProperty);
//        CFStringRef value = ABMultiValueCopyValueAtIndex(multiValue,index);
//        telephoneTextView.text = (__bridge NSString*)value;
//        CFRelease(multiValue);
//    }
//    NSString *firstPhoneticNameStr = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));
//    if (firstPhoneticNameStr) {
//        nameTextView.text = firstPhoneticNameStr;
////        CFIndex index = ABMultiValueGetIndexForIdentifier(multiValue,kABPersonPhoneProperty);
////        CFStringRef value = ABMultiValueCopyValueAtIndex(multiValue,index);
////        telephoneTextView.text = (__bridge NSString*)value;
////        CFRelease(multiValue);
//    }
   [peoplePicker dismissViewControllerAnimated:YES completion:^{
       
   }];
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
