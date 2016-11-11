//
//  DXAlertAction.h
//  QRFounder
//
//  Created by douglas on 2016/11/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DXAlertAction : NSObject


+ (void)showAlertWithTitle:(NSString*)title msg:(NSString*)msg inVC:(UIViewController *)vc  chooseBlock:(void (^)(NSInteger buttonIdx))block  buttonsStatement:(NSString*)cancelString, ...;

@end
