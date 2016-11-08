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
#import "DXHelper.h"
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
            [resultArr addObject:[self getAlbumItem]];
            sourcepath = [[NSBundle mainBundle] pathForResource:@"QRlogoSource" ofType:@"plist"];
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
        case QREditTypeColor:{
            NSArray *colors = @[[UIColor redColor],[UIColor greenColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor darkGrayColor],[UIColor purpleColor],[UIColor magentaColor],[UIColor blueColor],[UIColor brownColor],[UIColor darkGrayColor]];
            DXmenuItem *menuItem = [[DXmenuItem alloc] init];
            menuItem.color = [UIColor yellowColor];
             NSMutableArray *menulist = [[NSMutableArray alloc] init];
            for (UIColor *c in colors) {
               DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                subItem.normalImage = [[DXHelper shareInstance] getColorImageWithColor:c andSize:CGSizeMake(40, 40)];
                subItem.color = c;
                [menulist addObject:subItem];
            }
            menuItem.items = menulist;
            [resultArr addObject:menuItem];
        }break;
        case QREditTypeDIY:{
            NSArray *colors = @[[UIColor yellowColor]];
            DXmenuItem *menuItem = [[DXmenuItem alloc] init];
            menuItem.color = [UIColor yellowColor];
            NSMutableArray *menulist = [[NSMutableArray alloc] init];
            for (UIColor *c in colors) {
                DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                subItem.normalImage = [[DXHelper shareInstance] getColorImageWithColor:c andSize:CGSizeMake(40, 40)];
                subItem.color = c;
                DIYSubModel *boarderItem = [[DIYSubModel alloc] init];
                boarderItem.image = [UIImage imageNamed:@"boarder"];
                
                DIYSubModel *item1 = [[DIYSubModel alloc] init];
                item1.image = [UIImage imageNamed:@"item01"];
                item1.size = CGSizeMake(2, 1);
                item1.probability = 0.2;
                DIYSubModel *item2 = [[DIYSubModel alloc] init];
                item2.image = [UIImage imageNamed:@"item02"];
                item2.size = CGSizeMake(1, 1);
                item2.probability = 1.0;
                DIYSubModel *item3 = [[DIYSubModel alloc] init];
                item3.image = [UIImage imageNamed:@"item03"];
                item3.size = CGSizeMake(2, 2);
                item3.probability = 0.06;
                
                DIYSubModel *item4 = [[DIYSubModel alloc] init];
                item4.image = [UIImage imageNamed:@"item04"];
                item4.size = CGSizeMake(2, 2);
                item4.probability = 0.06;
                DIYSubModel *item5 = [[DIYSubModel alloc] init];
                item5.image = [UIImage imageNamed:@"item05"];
                item5.size = CGSizeMake(1, 2);
                item5.probability = 0.2;
                DIYModel *diyModel = [[DIYModel alloc] init];
                diyModel.boarderModel = boarderItem;
                diyModel.itemArrays = @[item1,item2,item3,item4,item5];
                subItem.diyModel = diyModel;
                [menulist addObject:subItem];
            }
            menuItem.items = menulist;
            [resultArr addObject:menuItem];
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
    sub1.normalImage = [UIImage imageNamed:@"photo"];
    DXSubMenuItem *sub2 = [[DXSubMenuItem alloc] init];
    sub2.normalImage = [UIImage imageNamed:@"cameraone"];
    menuItem.items = [NSMutableArray arrayWithArray:@[sub1,sub2]];
    return menuItem;
}

@end
