//
//  ShareManager.h
//  QRFounder
//
//  Created by douglas on 16/7/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShareManager : NSObject
+ (ShareManager *)shareInstance;
- (void)startSDK;
- (void)shareQrimage:(UIImage *)image withView:(UIView *)view;
- (void)shareURL:(NSString *)url withTitle:(NSString *)title des:(NSString *)des andView:(UIView *)view;
@end
