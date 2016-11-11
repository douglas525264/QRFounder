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
#import "ColorModel.h"
#import "QRColorBgView.h"
#import "DXQRView.h"
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
            NSArray *colors = @[[UIColor orangeColor],[UIColor greenColor],[UIColor yellowColor],[UIColor redColor],[UIColor darkGrayColor],[UIColor purpleColor],[UIColor magentaColor],[UIColor blueColor],[UIColor brownColor],[UIColor darkGrayColor]];
            DXmenuItem *menuItem = [[DXmenuItem alloc] init];
            menuItem.menuIcon = [[DXHelper shareInstance] getColorImageWithColor:[UIColor greenColor] andSize:CGSizeMake(40, 40)];
            //menuItem.color = [UIColor yellowColor];
             NSMutableArray *menulist = [[NSMutableArray alloc] init];
            for (UIColor *c in colors) {
               DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                subItem.normalImage = [[DXHelper shareInstance] getColorImageWithColor:c andSize:CGSizeMake(40, 40)];
                subItem.color = c;
                [menulist addObject:subItem];
            }
            menuItem.items = menulist;
            [resultArr addObject:menuItem];
            
            
            
            
            
            
            menulist = [[NSMutableArray alloc] init];
            DXmenuItem *menuItem1 = [[DXmenuItem alloc] init];
            menuItem1.menuIcon = [UIImage imageNamed:@"moreColor_icon"];
            NSArray *colorArr3 = @[[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor]];
            NSArray *colorArr2 = @[[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor]];
            NSArray *colorArr = @[[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor magentaColor]];
            
            NSArray *allColors = @[colorArr3,colorArr2,colorArr];
            for (NSArray *colors in allColors) {
                [menulist addObject:[self getSubItemWIthColors:colors angle:M_PI_2/2 type:BgColorTypeRound]];
                [menulist addObject:[self getSubItemWIthColors:colors angle:M_PI*3/8 type:BgColorTypeLine]];
                 [menulist addObject:[self getSubItemWIthColors:colors angle:0 type:BgColorTypegradual]];
                 [menulist addObject:[self getSubItemWIthColors:colors angle:M_PI_2/2 type:BgColorTypegradual]];
            }
            
            menuItem1.items = menulist;
            
            [resultArr addObject:menuItem1];

            
        }break;
        case QREditTypeDIY:{
            
            
            
            sourcepath = [[NSBundle mainBundle] pathForResource:@"DIYImageSource" ofType:@"plist"];
            NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:sourcepath];
            NSArray *items = [infoDic objectForKey:@"items"];
            NSMutableArray *menulist = [[NSMutableArray alloc] init];
            DXmenuItem *menuItem = [[DXmenuItem alloc] init];
            menuItem.color = [UIColor yellowColor];

            for (NSDictionary *info in items) {
                DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                subItem.normalImage = [UIImage imageNamed:[info objectForKey:@"iconName"]];;
                subItem.color = [UIColor greenColor];
//                DIYSubModel *boarderItem = [[DIYSubModel alloc] init];
//                boarderItem.image = [UIImage imageNamed:[info objectForKey:@"boardername"]];
                NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                NSMutableArray *items = [[NSMutableArray alloc] init];
                for (NSDictionary *subInfo in subMenuInfos) {
                    DIYSubModel *item = [[DIYSubModel alloc] init];
                    item.image = [UIImage imageNamed:[subInfo objectForKey:@"imageSourceName"]];
                    item.size = CGSizeMake([[subInfo objectForKey:@"sizex"] floatValue], [[subInfo objectForKey:@"sizey"] floatValue]);
                    item.probability = [[subInfo objectForKey:@"probability"] floatValue];
                    [items addObject:item];
                }
                DIYModel *diyModel = [[DIYModel alloc] init];
                diyModel.bgColor = RGB([[info objectForKey:@"bgr"] floatValue], [[info objectForKey:@"bgg"] floatValue], [[info objectForKey:@"bgb"] floatValue], [[info objectForKey:@"bga"] floatValue]);
                diyModel.isChangeBlack = [[info objectForKey:@"isChangeBlack"] boolValue];
                NSArray *arr = [info objectForKey:@"borderlist"];
                NSMutableArray *borderList = [[NSMutableArray alloc] init];
                for (NSDictionary *info in arr) {
                    DIYSubModel *boarderItem = [[DIYSubModel alloc] init];
                    boarderItem.image = [UIImage imageNamed:[info objectForKey:@"boardername"]];
                    [borderList addObject:boarderItem];
                }
                diyModel.boarderItems = borderList;
                diyModel.itemArrays = items;
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
- (DXSubMenuItem *)getSubItemWIthColors:(NSArray *)colors angle:(CGFloat)ang type:(BgColorType)type {
    DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
    
    ColorModel *cModel = [[ColorModel alloc] init];
    cModel.colortype = type;
    cModel.angle = ang;
    cModel.colors =  colors;
    subItem.normalImage = [self getImageWithModel:cModel withSize:CGSizeMake(40, 40)];
    subItem.colorModel = cModel;

    return subItem;
}
- (UIImage *)getImageWithModel:(ColorModel *)model withSize:(CGSize)size{
    @synchronized (self) {
        
    
    DXQRView *view = [[DXQRView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    QRModel *qrm = [[QRModel alloc] init];
    qrm.colorModel = model;
    qrm.QRStr = @"*1";
    view.qrModel = qrm;
    
    [[DXHelper shareInstance] imageFromView:view];
    return [[DXHelper shareInstance] imageFromView:view];;
    }
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
