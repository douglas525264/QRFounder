//
//  DXBottomActionView.h
//  QRFounder
//
//  Created by douglas on 16/7/19.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DXBottomActionMenu) {
    DXBottomActionMenuSelectAll,
    DXBottomActionMenuDelete,
    DXBottomActionMenuNOTSelectAll
};

@interface DXBottomActionView : UIView
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger allcount;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSMutableArray *commendArr;

@property (nonatomic, copy) void (^callBackWithCommand)(DXBottomActionView *bpc,DXBottomActionMenu command);
+ (DXBottomActionView *)popWithCommendArr:(NSArray *)arr andBlock:(void (^)(DXBottomActionView *bpc,DXBottomActionMenu command)) block;

- (DXBottomActionView *)initWithcommendArr:(NSArray *)commendArr;
- (void)show;
- (void)showInView:(UIView *)view;
- (void)dismisswithAnimation:(BOOL)animation;
@end
