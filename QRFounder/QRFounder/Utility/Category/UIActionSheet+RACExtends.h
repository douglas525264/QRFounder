//
//  UIActionSheet+RACExtends.h
//  zapyaNewPro
//
//  Created by dongxin on 15/6/26.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (RACExtends)

+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancel destructiveButtonTitle:(NSString *)des callBackBlock:(void (^)(NSNumber *indexNumber))callbackblock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


@end
