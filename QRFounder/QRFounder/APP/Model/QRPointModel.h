//
//  QRPointModel.h
//  QRFounder
//
//  Created by douglas on 2016/11/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "qrencode.h"
#import "DIYModel.h"
@interface QRPointModel : NSObject
@property (nonatomic, assign) BOOL isChangeBlack;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) QRcode *code;
@property (nonatomic, assign) CGFloat qr_margin;
@property (nonatomic, strong) DIYModel *diymodel;
-(id)initWithQRCode:(QRcode *)code diyModel:(DIYModel *)diymodel andSize:(CGFloat)size;
-(id)initWithQRCode:(QRcode *)code diyModel:(DIYModel *)diymodel andSize:(CGFloat)size isChangeBlack:(BOOL)isChange;
- (NSArray *)getResultArr;
@end

@interface QROnePoint : NSObject

@property (nonatomic, assign) BOOL isBlack;
@property (nonatomic, assign) BOOL isInUse;
@property (nonatomic, assign) BOOL willInUse;
@property (nonatomic, strong) NSIndexPath *position;
- (CGFloat)disWithOtherpoint:(QROnePoint *)point;
@end

@interface QRResultPoint : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect frame;

@end
