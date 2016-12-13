//
//  DXScrollMenu.h
//  QRFounder
//
//  Created by dongxin on 16/3/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXmenuItem.h"
#import "DXSubMenuItem.h"
@interface DXScrollMenu : UIView
@property (nonatomic, strong) NSArray *menuItems;

@property (nonatomic,copy) void (^selectFinishedCallBack)(NSIndexPath *path,NSInteger tag);

- (void)unLockAtIndexPaths:(NSArray*)array;
- (void)setMenuItems:(NSArray *)menuItems isReload:(BOOL)isreload;
@end
