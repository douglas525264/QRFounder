
//
//  MsgInfoView.m
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MsgInfoView.h"
#import "CardInfoTableViewCell.h"
#import <AddressBookUI/AddressBookUI.h>
#import "MainViewController.h"
@interface MsgInfoView()<ABPeoplePickerNavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *cells;

@end
@implementation MsgInfoView
- (IBAction)addBtnClick:(id)sender {
    
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [[MainViewController shareInstance] presentViewController:peoplePicker animated:YES completion:nil];
    
}
- (void)drawRect:(CGRect)rect {
    self.sendToTextView.placeHolder = @"请输入电话";
    self.sendToTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.contentTextView.placeHolder = @"要发送的内容";
    self.sendToTextView.delegate = self;
    self.contentTextView.delegate = self;
    
}
- (NSString *)getResultInfoStr {
    if (!self.sendToTextView.text || ![NSString validateMobile:self.sendToTextView.text]) {
        [[DXHelper shareInstance] makeAlterWithTitle:@"手机号不合法" andIsShake:NO];
        return nil;
    }
    if (!self.contentTextView.text || self.contentTextView.text.length == 0) {
        [[DXHelper shareInstance] makeAlterWithTitle:@"请输入要发送的信息" andIsShake:NO];
        return nil;
    }
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    [resultStr appendString:@"smsto:"];
    [resultStr appendString:self.sendToTextView.text];
    [resultStr appendFormat:@":%@;",self.contentTextView.text];
    return resultStr;
}
#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    //获取个人名字
    //    CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //    CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    //CFStringRef abFullName = ABRecordCopyCompositeName(person);
   // NSString *fullName = (__bridge NSString *)abFullName;
   // self.sendToTextView.text = fullName;
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
    self.sendToTextView.text = telStr;
    //mailTextView.text = mailStr;
    //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
    //   [addressBookTemp addObject:addressBook];
    
   // if (abFullName) CFRelease(abFullName);
    

    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (NSMutableArray *)cells {
    
    if (!_cells) {
        _cells = [[NSMutableArray alloc] init];
    }
    return _cells;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
