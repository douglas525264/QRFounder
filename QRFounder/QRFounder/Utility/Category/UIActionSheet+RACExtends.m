//
//  UIActionSheet+RACExtends.m
//  zapyaNewPro
//
//  Created by dongxin on 15/6/26.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import "UIActionSheet+RACExtends.h"
#import <ReactiveCocoa.h>
@implementation UIActionSheet (RACExtends)
+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancel destructiveButtonTitle:(NSString *)des callBackBlock:(void (^)(NSNumber *indexNumber))callbackblock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    UIActionSheet *actionSheet;
   
   
    va_list _arguments;
    NSMutableArray *tagsArr = [[NSMutableArray alloc] init];
    
    va_start(_arguments, otherButtonTitles);
    for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
       // [actionSheet addButtonWithTitle:key];
        [tagsArr addObject:key];
    }

    va_end(_arguments);
    switch (tagsArr.count) {
    
        case 0:{
        actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancel destructiveButtonTitle:des otherButtonTitles:nil];
        }break;
        case 1:{
          actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancel destructiveButtonTitle:des otherButtonTitles:tagsArr[0],nil];
        }break;
        case 2:{
          actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancel destructiveButtonTitle:des otherButtonTitles:tagsArr[0],tagsArr[1],nil];
        }break;
        case 3:{
           actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancel destructiveButtonTitle:des otherButtonTitles:tagsArr[0],tagsArr[1],tagsArr[2],nil];
        }break;
        case 4:{
           actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancel destructiveButtonTitle:des otherButtonTitles:tagsArr[0],tagsArr[1],tagsArr[2],tagsArr[3],nil];
        }break;
        case 5:{
           actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancel destructiveButtonTitle:des otherButtonTitles:tagsArr[0],tagsArr[1],tagsArr[2],tagsArr[3],tagsArr[4],nil];
        }break;
        case 6:{
            actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancel destructiveButtonTitle:des otherButtonTitles:tagsArr[0],tagsArr[1],tagsArr[2],tagsArr[3],tagsArr[4],tagsArr[5],nil];
        }break;
        default:{
           actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancel destructiveButtonTitle:des otherButtonTitles:tagsArr[0],tagsArr[1],tagsArr[2],tagsArr[3],tagsArr[4],tagsArr[5],nil]; 
        }break;
    }
    
    [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *selectIndex) {
        callbackblock(selectIndex);
    }];
    UIWindow *lastWindow = [[UIApplication sharedApplication].windows lastObject];
    [actionSheet showInView:lastWindow];
    [lastWindow bringSubviewToFront:actionSheet];
    return actionSheet;
}


@end
