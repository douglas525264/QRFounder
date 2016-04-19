//
//  DXmenuItem.h
//  QRFounder
//
//  Created by dongxin on 16/3/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DXmenuItem : NSObject


@property (nonatomic, strong) UIImage *menuIcon;

@property (nonatomic, copy)   NSString *title;
//这里放的是 subMenuItems
@property (nonatomic, strong) NSMutableArray *items;

@end
