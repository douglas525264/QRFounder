//
//  QRSourceManager.m
//  QRFounder
//
//  Created by Douglas on 16/4/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "QRSourceManager.h"
#import "DXmenuItem.h"
#import "DXSubMenuItem.h"
static QRSourceManager *qManager;
@implementation QRSourceManager

+ (QRSourceManager *)shareInstance {

    if (!qManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            qManager = [[QRSourceManager alloc] init];
        });
    }
    return qManager;
}

- (NSArray *)getSoureceWithEditeType:(QREditType)type {

    NSString *sourcepath = @"";
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    //以下是本地加载资源代码 需要网络加载请重新封装方法
    switch (type) {
        case QREditTypeBg:{
            
            [resultArr addObject:[self getAlbumItem]];
            sourcepath = [[NSBundle mainBundle] pathForResource:@"QRBgSource" ofType:@"plist"];
            NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:sourcepath];
            NSArray *items = [infoDic objectForKey:@"items"];
            for (NSDictionary *info in items) {
                DXmenuItem *menuItem = [[DXmenuItem alloc] init];
                menuItem.menuIcon = [UIImage imageNamed:[info objectForKey:@"iconName"]];
                NSMutableArray *menulist = [[NSMutableArray alloc] init];
                NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                for (NSDictionary *subInfo in subMenuInfos) {
                    DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                    subItem.normalImage = [UIImage imageNamed:[subInfo objectForKey:@"menuIcon"]];
                    subItem.ImageName = [[NSBundle mainBundle] pathForResource:[subInfo objectForKey:@"imageSourceName"] ofType:@"png"];
                    [menulist addObject:subItem];
                    
                }
                menuItem.items = menulist;
                [resultArr addObject:menuItem];
            }
            
            
        }break;
        case QREditTypeBoarder:{
            
            sourcepath = [[NSBundle mainBundle] pathForResource:@"BorderImageSource" ofType:@"plist"];
            NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:sourcepath];
            NSArray *items = [infoDic objectForKey:@"items"];
            for (NSDictionary *info in items) {
                DXmenuItem *menuItem = [[DXmenuItem alloc] init];
                menuItem.menuIcon = [UIImage imageNamed:[info objectForKey:@"iconName"]];
                NSMutableArray *menulist = [[NSMutableArray alloc] init];
                NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                for (NSDictionary *subInfo in subMenuInfos) {
                    DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                    subItem.normalImage = [UIImage imageNamed:[subInfo objectForKey:@"menuIcon"]];
                    subItem.ImageName = [[NSBundle mainBundle] pathForResource:[subInfo objectForKey:@"imageSourceName"] ofType:@"png"];
                    subItem.QRFrame  = CGRectMake([[subInfo objectForKey:@"xScale"] floatValue],
                                                  [[subInfo objectForKey:@"yScale"] floatValue],[[subInfo objectForKey:@"wScale"] floatValue], [[subInfo objectForKey:@"hScale"] floatValue]);
                    [menulist addObject:subItem];
                    
                }
                menuItem.items = menulist;
                [resultArr addObject:menuItem];
            }

            
        }break;
        case QREditTypeLogo:{
            
        }break;

            
        default:
            break;
    }
    
    
    
    return resultArr;
}
- (DXmenuItem *)getAlbumItem{

  //  NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    DXmenuItem *menuItem = [[DXmenuItem alloc] init];
    menuItem.menuIcon = [UIImage imageNamed:@"album"];
    DXSubMenuItem *sub1 = [[DXSubMenuItem alloc] init];
    sub1.normalImage = [UIImage imageNamed:@"albumIcon"];
    DXSubMenuItem *sub2 = [[DXSubMenuItem alloc] init];
    sub2.normalImage = [UIImage imageNamed:@"albumIcon"];
    menuItem.items = [NSMutableArray arrayWithArray:@[sub1,sub2]];
    return menuItem;
}

@end
