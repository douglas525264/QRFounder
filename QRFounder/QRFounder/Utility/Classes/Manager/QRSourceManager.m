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
#import "Lockmanager.h"
#import "SourceItemModel.h"
static QRSourceManager *qManager;
@interface QRSourceManager()
@property (nonatomic, strong)NSMutableArray *remoteSourceArr;
@end
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
                menuItem.menuIcon = QRImage([info objectForKey:@"iconName"]);
                NSMutableArray *menulist = [[NSMutableArray alloc] init];
                NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                for (NSDictionary *subInfo in subMenuInfos) {
                    DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                    subItem.normalImage = QRImage([subInfo objectForKey:@"menuIcon"]);//[UIImage imageNamed:[subInfo objectForKey:@"menuIcon"]];
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
                menuItem.menuIcon = QRImage([info objectForKey:@"iconName"]);//[UIImage imageNamed:[info objectForKey:@"iconName"]];
                NSMutableArray *menulist = [[NSMutableArray alloc] init];
                NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                for (NSDictionary *subInfo in subMenuInfos) {
                    DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                    subItem.normalImage = QRImage([subInfo objectForKey:@"menuIcon"]);// [UIImage imageNamed:[subInfo objectForKey:@"menuIcon"]];
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
                menuItem.menuIcon = QRImage([info objectForKey:@"iconName"]);// [UIImage imageNamed:[info objectForKey:@"iconName"]];
                NSMutableArray *menulist = [[NSMutableArray alloc] init];
                NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                for (NSDictionary *subInfo in subMenuInfos) {
                    DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                    subItem.normalImage = QRImage([subInfo objectForKey:@"menuIcon"]);// [UIImage imageNamed:[subInfo objectForKey:@"menuIcon"]];
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
            
            for (NSDictionary *itemInfo in items) {
                NSMutableArray *menulist = [[NSMutableArray alloc] init];
                DXmenuItem *menuItem = [[DXmenuItem alloc] init];
                menuItem.menuIcon = QRImage([itemInfo objectForKey:@"iconName"]);
                NSString *title = itemInfo[@"sourcename"];
                NSString *des = itemInfo[@"des"];
                NSString *sourceID = itemInfo[@"diysourceid"];
                if (title) {
                    menuItem.title = title;
                }
                if (des) {
                    menuItem.des = des;
                }
                if (sourceID) {
                    menuItem.itemId = sourceID;
                }
                //[UIImage imageNamed:[itemInfo objectForKey:@"iconName"]];
                NSInteger inde = 0;
                for (NSDictionary *subInfo in itemInfo[@"menulist"]) {
                    DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                    subItem.normalImage = QRImage([subInfo objectForKey:@"iconName"]);//[UIImage imageNamed:[subInfo objectForKey:@"iconName"]];;
                    NSNumber *price = [subInfo objectForKey:@"price"];
                    subItem.price = price ? price.floatValue : 0;
                    NSNumber *isLock = subInfo [@"islock"];
                    if (isLock) {
                        if (isLock.boolValue) {
                            subItem.isLock = ![[Lockmanager shareInstance] hasunlock:sourceID atindex:inde];
                        } else {
                            subItem.isLock = NO;
                        }
                    } else {
                        subItem.isLock = NO;
                    }
                    
                    
    
                    subItem.color = [UIColor greenColor];
                    //                DIYSubModel *boarderItem = [[DIYSubModel alloc] init];
                    //                boarderItem.image = [UIImage imageNamed:[info objectForKey:@"boardername"]];
                    NSArray *subMenuInfos = [subInfo objectForKey:@"menuList"];
                    NSMutableArray *items = [[NSMutableArray alloc] init];
                    for (NSDictionary *subInfo in subMenuInfos) {
                        DIYSubModel *item = [[DIYSubModel alloc] init];
                        item.image = QRImage([subInfo objectForKey:@"imageSourceName"]);//[UIImage imageNamed:[subInfo objectForKey:@"imageSourceName"]];
                        item.size = CGSizeMake([[subInfo objectForKey:@"sizex"] floatValue], [[subInfo objectForKey:@"sizey"] floatValue]);
                        item.probability = [[subInfo objectForKey:@"probability"] floatValue];
                        [items addObject:item];
                    }
                    DIYModel *diyModel = [[DIYModel alloc] init];
                    diyModel.bgColor = RGB([[subInfo objectForKey:@"bgr"] floatValue], [[subInfo objectForKey:@"bgg"] floatValue], [[subInfo objectForKey:@"bgb"] floatValue], [[subInfo objectForKey:@"bga"] floatValue]);
                    diyModel.isChangeBlack = [[subInfo objectForKey:@"isChangeBlack"] boolValue];
                    NSArray *arr = [subInfo objectForKey:@"borderlist"];
                    NSMutableArray *borderList = [[NSMutableArray alloc] init];
                    for (NSDictionary *info in arr) {
                        DIYSubModel *boarderItem = [[DIYSubModel alloc] init];
                        boarderItem.image = QRImage([info objectForKey:@"boardername"]);//[UIImage imageNamed:[info objectForKey:@"boardername"]];
                        [borderList addObject:boarderItem];
                    }
                    diyModel.boarderItems = borderList;
                    diyModel.itemArrays = items;
                    
                    //bigBorder
                    NSDictionary *bugBorderInfo = subInfo[@"bigBorderInfo"];
                    if (bugBorderInfo) {
                        diyModel.bigBorderImage = [[NSBundle mainBundle] pathForResource:[bugBorderInfo objectForKey:@"imageSourceName"] ofType:@"png"];
                        diyModel.QRframe  = CGRectMake([[bugBorderInfo objectForKey:@"xScale"] floatValue],
                                                       [[bugBorderInfo objectForKey:@"yScale"] floatValue],[[bugBorderInfo objectForKey:@"wScale"] floatValue], [[bugBorderInfo objectForKey:@"hScale"] floatValue]);
                    }

                    //bgImgae
                    NSString * bgName = subInfo[@"bgImageName"];
                    if (bgName) {
                        diyModel.bgImageName = [[NSBundle mainBundle] pathForResource:bgName ofType:@"png"];
                    }
                    
                
                    
                    subItem.diyModel = diyModel;
                    [menulist addObject:subItem];
                     inde ++;

                }
                menuItem.items = menulist;
                
                [resultArr addObject:menuItem];
               
                
            }
            
//            NSMutableArray *menulist = [[NSMutableArray alloc] init];
//            DXmenuItem *menuItem = [[DXmenuItem alloc] init];
//            menuItem.color = [UIColor yellowColor];
//
//            for (NSDictionary *info in items) {
//                
//            }
            
            
        }break;

        default:
            break;
    }
    [resultArr addObjectsFromArray:[self getlocalInfoWithType:type]];
    if (type != QREditTypeColor) {
        DXmenuItem *lastmenuItem = [[DXmenuItem alloc] init];
        lastmenuItem.menuIcon = [UIImage imageNamed:@"itemadd"];
        lastmenuItem.items = [[NSMutableArray alloc] init];
        [resultArr addObject:lastmenuItem];
 
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
- (void)preloadSource {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *arr = [self getSoureceWithEditeType:QREditTypeDIY];
        if (arr.count > 0) {
            NSLog(@"Source is ready");
        }
    });
}
//远程相关
- (void)getItemListwithtype:(QREditType)type withFinishedBlock:(void (^)(BOOL isok,NSArray *arr)) block{
    [DXNetworkTool postWithPath:sourceURL postBody:@{@"type": @(type)} andHttpHeader:nil completed:^(NSDictionary *json, NSString *stringdata, NSInteger code) {
        
        NSArray *sourr = json[@"json"];
        if (sourr && sourr.count > 0) {
            //这里逻辑暂时这样写
            [self.remoteSourceArr removeAllObjects];
            NSMutableArray *resultArr = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDic in sourr) {
                SourceItemModel *model = [[SourceItemModel alloc] init];
                model.type = type;
                [model configWithJson:infoDic];
                [resultArr addObject:model];
            }
            [self.remoteSourceArr addObjectsFromArray:resultArr];
             block(YES,resultArr);
        }
       
         block(YES,@[]);
    } failed:^(DXError *error) {
        block(NO,@[]);
    }];

}
- (void)hasDownload:(NSString *)itemId {
    SourceItemModel *model;
    for (SourceItemModel *mm in self.remoteSourceArr) {
        if ([mm.sId isEqualToString:itemId]) {
            model = mm;
            break;
        }
    }
    if (model) {
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        NSString *key = @"";
        switch (model.type) {
            case QREditTypeDIY:{
               key = @"remoteSourceDIY";
            }break;
            case QREditTypeLogo:{
               key = @"remoteSourceLOGO";
            }break;
            case QREditTypeBoarder:{
               key = @"remoteSourceBorder";
            }break;
            case QREditTypeBg:{
               key = @"remoteSourceBg";
            }break;
                
            default:
                break;
        }
        NSArray *arr = [de objectForKey:key];
        NSMutableArray *resArr = [[NSMutableArray alloc] init];
        if (arr && arr.count > 0) {
            [resArr addObjectsFromArray:arr];
        }
        [resArr addObject:[model toJson]];
        [de setValue:resArr forKey:key];
        [de synchronize];
        [self.rac_qrSourceChangeSingle sendNext:@(model.type)];
    }
}
- (void)deleteDownload:(NSString *)itemId withtype:(QREditType)type {
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSString *key = @"";
    switch (type) {
        case QREditTypeDIY:{
            key = @"remoteSourceDIY";
        }break;
        case QREditTypeLogo:{
            key = @"remoteSourceLOGO";
        }break;
        case QREditTypeBoarder:{
            key = @"remoteSourceBorder";
        }break;
        case QREditTypeBg:{
            key = @"remoteSourceBg";
        }break;
            
        default:
            break;
    }
    NSArray *arr = [de objectForKey:key];
    if (arr && arr.count > 0) {
        NSMutableArray *resArr = [[NSMutableArray alloc] init];
        [resArr addObjectsFromArray:arr];
        for (NSDictionary *info in arr) {
            SourceItemModel *model = [[SourceItemModel alloc] init];
            [model configWithJson:info];
            if ([model.sId isEqualToString:itemId]) {
                [resArr removeObject:info];
                [de setValue:resArr forKey:key];
                [de synchronize];
                NSString *souPath = [self getsourceWithType:type];
                NSString *unzipPath = [souPath stringByAppendingPathComponent:[[model.remoteUrl lastPathComponent] stringByDeletingPathExtension]];
                NSFileManager *filemanager = [NSFileManager defaultManager];
                if ([filemanager fileExistsAtPath:unzipPath]) {
                    [filemanager removeItemAtPath:unzipPath error:nil];
                }
                [self.rac_qrSourceChangeSingle sendNext:@(type)];
                break;
            }
        }
    }

}
- (NSArray *)getHasDownLoadItemsWithtype:(QREditType)type {
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSString *key = @"";
    switch (type) {
        case QREditTypeDIY:{
            key = @"remoteSourceDIY";
        }break;
        case QREditTypeLogo:{
            key = @"remoteSourceLOGO";
        }break;
        case QREditTypeBoarder:{
            key = @"remoteSourceBorder";
        }break;
        case QREditTypeBg:{
            key = @"remoteSourceBg";
        }break;
            
        default:
            break;
    }
    NSArray *arr = [de objectForKey:key];
    if (arr && arr.count > 0) {
        NSMutableArray *resArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *info in arr) {
            SourceItemModel *model = [[SourceItemModel alloc] init];
            [model configWithJson:info];
            model.type = type;
            [resArr addObject:model];
        }
        return  resArr;
    }

    return nil;
}
//local manager
- (void)createDir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *diyPath = [QRSourceManager getDIYPath];
    NSString *logoPath = [QRSourceManager getLogoPath];
    NSString *bgPath = [QRSourceManager getBGPath];
    NSString *borderPath = [QRSourceManager getBorderPath];
    NSString *tempSave = [QRSourceManager getTempSavapath];
    NSArray *dirArr = @[diyPath,logoPath,bgPath,borderPath,tempSave];
    for (NSString *path in dirArr) {
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

}
- (NSArray *)getlocalInfoWithType:(QREditType)type {
    
    NSString *rPath = @"";
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    switch (type) {
        case QREditTypeDIY:{
            rPath = [QRSourceManager getDIYPath];
            NSError *error = nil;
            NSArray *fileList = [fileManager contentsOfDirectoryAtPath:rPath error:&error];
            
            for (NSString *file in fileList) {
                NSString *path = [rPath stringByAppendingPathComponent:file];
                [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
                if (isDir) {
                    NSString *infoPath = [path stringByAppendingString:@"/SourceConfig.plist"];
                    if ([fileManager fileExistsAtPath:infoPath]) {
                        NSDictionary *itemInfo = [NSDictionary dictionaryWithContentsOfFile:infoPath];
                        NSMutableArray *menulist = [[NSMutableArray alloc] init];
                        DXmenuItem *menuItem = [[DXmenuItem alloc] init];
                        menuItem.menuIcon = QRImage1([itemInfo objectForKey:@"iconName"],path);
                        NSString *title = itemInfo[@"sourcename"];
                        NSString *des = itemInfo[@"des"];
                        NSString *sourceID = itemInfo[@"diysourceid"];
                        if (title) {
                            menuItem.title = title;
                        }
                        if (des) {
                            menuItem.des = des;
                        }
                        if (sourceID) {
                            menuItem.itemId = sourceID;
                        }
                        //[UIImage imageNamed:[itemInfo objectForKey:@"iconName"]];
                        NSInteger inde = 0;
                        for (NSDictionary *subInfo in itemInfo[@"menulist"]) {
                            DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                            
                            subItem.normalImage = QRImage1([subInfo objectForKey:@"iconName"],path);//[UIImage imageNamed:[subInfo objectForKey:@"iconName"]];;
                            NSNumber *price = [subInfo objectForKey:@"price"];
                            subItem.price = price ? price.floatValue : 0;
                            NSNumber *isLock = subInfo [@"islock"];
                            if (isLock) {
                                if (isLock.boolValue) {
                                    subItem.isLock = ![[Lockmanager shareInstance] hasunlock:sourceID atindex:inde];
                                } else {
                                    subItem.isLock = NO;
                                }
                            } else {
                                subItem.isLock = NO;
                            }
                            
                            
                            
                            subItem.color = [UIColor greenColor];
                            //                DIYSubModel *boarderItem = [[DIYSubModel alloc] init];
                            //                boarderItem.image = [UIImage imageNamed:[info objectForKey:@"boardername"]];
                            NSArray *subMenuInfos = [subInfo objectForKey:@"menuList"];
                            NSMutableArray *items = [[NSMutableArray alloc] init];
                            for (NSDictionary *subInfo in subMenuInfos) {
                                DIYSubModel *item = [[DIYSubModel alloc] init];
                                item.image = QRImage1([subInfo objectForKey:@"imageSourceName"],path);//[UIImage imageNamed:[subInfo objectForKey:@"imageSourceName"]];
                                item.size = CGSizeMake([[subInfo objectForKey:@"sizex"] floatValue], [[subInfo objectForKey:@"sizey"] floatValue]);
                                item.probability = [[subInfo objectForKey:@"probability"] floatValue];
                                [items addObject:item];
                            }
                            DIYModel *diyModel = [[DIYModel alloc] init];
                            diyModel.bgColor = RGB([[subInfo objectForKey:@"bgr"] floatValue], [[subInfo objectForKey:@"bgg"] floatValue], [[subInfo objectForKey:@"bgb"] floatValue], [[subInfo objectForKey:@"bga"] floatValue]);
                            diyModel.isChangeBlack = [[subInfo objectForKey:@"isChangeBlack"] boolValue];
                            NSArray *arr = [subInfo objectForKey:@"borderlist"];
                            NSMutableArray *borderList = [[NSMutableArray alloc] init];
                            for (NSDictionary *info in arr) {
                                DIYSubModel *boarderItem = [[DIYSubModel alloc] init];
                                boarderItem.image = QRImage1([info objectForKey:@"boardername"],path);//[UIImage imageNamed:[info objectForKey:@"boardername"]];
                                [borderList addObject:boarderItem];
                            }
                            diyModel.boarderItems = borderList;
                            diyModel.itemArrays = items;
                            
                            //bigBorder
                            NSDictionary *bugBorderInfo = subInfo[@"bigBorderInfo"];
                            if (bugBorderInfo) {
                                diyModel.bigBorderImage =[path stringByAppendingFormat:@"/%@.png",[bugBorderInfo objectForKey:@"imageSourceName"] ] ;
                                diyModel.QRframe  = CGRectMake([[bugBorderInfo objectForKey:@"xScale"] floatValue],
                                                               [[bugBorderInfo objectForKey:@"yScale"] floatValue],[[bugBorderInfo objectForKey:@"wScale"] floatValue], [[bugBorderInfo objectForKey:@"hScale"] floatValue]);
                            }
                            
                            //bgImgae
                            NSString * bgName = subInfo[@"bgImageName"];
                            if (bgName) {
                                diyModel.bgImageName = [path stringByAppendingFormat:@"/%@.png",bgName];
                            }
                            
                            
                            
                            subItem.diyModel = diyModel;
                            [menulist addObject:subItem];
                            inde ++;
                            
                        }
                        menuItem.items = menulist;
                        
                        [resultArr addObject:menuItem];
                        
                    }
                }
            }
            
        }break;
        case QREditTypeBg:{
            
            rPath = [QRSourceManager getBGPath];
            NSError *error = nil;
            NSArray *fileList = [fileManager contentsOfDirectoryAtPath:rPath error:&error];
            
            for (NSString *file in fileList) {
                NSString *path = [rPath stringByAppendingPathComponent:file];
                [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
                if (isDir) {
                    NSString *infoPath = [path stringByAppendingString:@"/SourceConfig.plist"];
                    if ([fileManager fileExistsAtPath:infoPath]) {
                        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPath];
                        DXmenuItem *menuItem = [[DXmenuItem alloc] init];
                        NSString *title = info[@"sourcename"];
                        NSString *des = info[@"des"];
                        NSString *sourceID = info[@"diysourceid"];
                        if (title) {
                            menuItem.title = title;
                        }
                        if (des) {
                            menuItem.des = des;
                        }
                        if (sourceID) {
                            menuItem.itemId = sourceID;
                        }
                        menuItem.menuIcon = QRImage1([info objectForKey:@"iconName"],path);
                        NSMutableArray *menulist = [[NSMutableArray alloc] init];
                        NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                            NSInteger inde = 0;
                        for (NSDictionary *subInfo in subMenuInfos) {
                            DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                            subItem.normalImage = QRImage1([subInfo objectForKey:@"menuIcon"],path);//[UIImage imageNamed:[subInfo objectForKey:@"menuIcon"]];
                            subItem.ImageName = [path stringByAppendingFormat:@"/%@.png",[subInfo objectForKey:@"imageSourceName"] ] ;
                            NSNumber *price = [subInfo objectForKey:@"price"];
                            subItem.price = price ? price.floatValue : 0;
                            NSNumber *isLock = subInfo [@"islock"];
                            if (isLock) {
                                if (isLock.boolValue) {
                                    subItem.isLock = ![[Lockmanager shareInstance] hasunlock:sourceID atindex:inde];
                                } else {
                                    subItem.isLock = NO;
                                }
                            } else {
                                subItem.isLock = NO;
                            }
                            

                            [menulist addObject:subItem];
                            inde ++;
                            
                        }
                        menuItem.items = menulist;
                        [resultArr addObject:menuItem];
                    
                    }
                }
            }
            
            
            
            
           

        
        }break;
        case QREditTypeLogo:{
            
            rPath = [QRSourceManager getLogoPath];
            NSError *error = nil;
            NSArray *fileList = [fileManager contentsOfDirectoryAtPath:rPath error:&error];
            
            for (NSString *file in fileList) {
                NSString *path = [rPath stringByAppendingPathComponent:file];
                [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
                if (isDir) {
                    NSString *infoPath = [path stringByAppendingString:@"/SourceConfig.plist"];
                    if ([fileManager fileExistsAtPath:infoPath]) {
                        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPath];
                        DXmenuItem *menuItem = [[DXmenuItem alloc] init];
                        NSString *title = info[@"sourcename"];
                        NSString *des = info[@"des"];
                        NSString *sourceID = info[@"diysourceid"];
                        if (title) {
                            menuItem.title = title;
                        }
                        if (des) {
                            menuItem.des = des;
                        }
                        if (sourceID) {
                            menuItem.itemId = sourceID;
                        }
                        menuItem.menuIcon = QRImage1([info objectForKey:@"iconName"],path);
                        NSMutableArray *menulist = [[NSMutableArray alloc] init];
                        NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                        NSInteger inde = 0;
                        for (NSDictionary *subInfo in subMenuInfos) {
                            DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                            subItem.normalImage = QRImage1([subInfo objectForKey:@"menuIcon"],path);//[UIImage imageNamed:[subInfo objectForKey:@"menuIcon"]];
                            subItem.ImageName = [path stringByAppendingFormat:@"/%@.png",[subInfo objectForKey:@"imageSourceName"] ] ;
                            NSNumber *price = [subInfo objectForKey:@"price"];
                            subItem.price = price ? price.floatValue : 0;
                            NSNumber *isLock = subInfo [@"islock"];
                            if (isLock) {
                                if (isLock.boolValue) {
                                    subItem.isLock = ![[Lockmanager shareInstance] hasunlock:sourceID atindex:inde];
                                } else {
                                    subItem.isLock = NO;
                                }
                            } else {
                                subItem.isLock = NO;
                            }
                            
                            
                            [menulist addObject:subItem];
                            inde ++;
                            
                        }
                        menuItem.items = menulist;
                        [resultArr addObject:menuItem];
                        
                    }
                }
            }
        }break;
        case QREditTypeBoarder:{
            
            rPath = [QRSourceManager getBorderPath];
            NSError *error = nil;
            NSArray *fileList = [fileManager contentsOfDirectoryAtPath:rPath error:&error];
            
            for (NSString *file in fileList) {
                NSString *path = [rPath stringByAppendingPathComponent:file];
                [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
                if (isDir) {
                    NSString *infoPath = [path stringByAppendingString:@"/SourceConfig.plist"];
                    if ([fileManager fileExistsAtPath:infoPath]) {
                        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPath];
                        DXmenuItem *menuItem = [[DXmenuItem alloc] init];
                        NSString *title = info[@"sourcename"];
                        NSString *des = info[@"des"];
                        NSString *sourceID = info[@"diysourceid"];
                        if (title) {
                            menuItem.title = title;
                        }
                        if (des) {
                            menuItem.des = des;
                        }
                        if (sourceID) {
                            menuItem.itemId = sourceID;
                        }

                        menuItem.menuIcon = QRImage1([info objectForKey:@"iconName"],path);//[UIImage imageNamed:[info objectForKey:@"iconName"]];
                        NSMutableArray *menulist = [[NSMutableArray alloc] init];
                        NSArray *subMenuInfos = [info objectForKey:@"menuList"];
                        NSInteger inde = 0;
                        for (NSDictionary *subInfo in subMenuInfos) {
                            DXSubMenuItem *subItem = [[DXSubMenuItem alloc] init];
                            subItem.normalImage = QRImage1([subInfo objectForKey:@"menuIcon"],path);// [UIImage imageNamed:[subInfo objectForKey:@"menuIcon"]];
                            subItem.ImageName = [path stringByAppendingFormat:@"/%@.png",[subInfo objectForKey:@"imageSourceName"] ] ;
                            subItem.QRFrame  = CGRectMake([[subInfo objectForKey:@"xScale"] floatValue],
                                                          [[subInfo objectForKey:@"yScale"] floatValue],[[subInfo objectForKey:@"wScale"] floatValue], [[subInfo objectForKey:@"hScale"] floatValue]);
                            NSNumber *isLock = subInfo [@"islock"];
                            NSNumber *price = [subInfo objectForKey:@"price"];
                            subItem.price = price ? price.floatValue : 0;

                            if (isLock) {
                                if (isLock.boolValue) {
                                    subItem.isLock = ![[Lockmanager shareInstance] hasunlock:sourceID atindex:inde];
                                } else {
                                    subItem.isLock = NO;
                                }
                            } else {
                                subItem.isLock = NO;
                            }
                            [menulist addObject:subItem];
                            inde ++;
                        }
                        menuItem.items = menulist;
                        [resultArr addObject:menuItem];
                        

                    }
                }
            }
        }break;

        default:
            
            break;
    }
    return resultArr;
}

+ (NSString *)getInboxPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
+ (NSString *)getDIYPath {
    static NSString *folder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        folder = [[self getInboxPath] stringByAppendingPathComponent:@"DIY"];
    });
    return folder;

}
+ (NSString *)getBGPath {
    static NSString *folder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        folder = [[self getInboxPath] stringByAppendingPathComponent:@"BG"];
    });
    return folder;
}
+ (NSString *)getLogoPath {
    static NSString *folder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        folder = [[self getInboxPath] stringByAppendingPathComponent:@"LOGO"];
    });
    return folder;

}
+ (NSString *)getBorderPath {
    static NSString *folder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        folder = [[self getInboxPath] stringByAppendingPathComponent:@"Border"];
    });
    return folder;

}
+ (NSString *)getTempSavapath {
    static NSString *folder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        folder = [[self getInboxPath] stringByAppendingPathComponent:@"tmp"];
    });
    return folder;
}
- (NSString *)getsourceWithType:(QREditType)type {

    switch (type) {
        case QREditTypeDIY:
            return [QRSourceManager getDIYPath];
            break;
        case QREditTypeLogo:
            return [QRSourceManager getLogoPath];
            break;
        case QREditTypeBoarder:
            return [QRSourceManager getBorderPath];
            break;
        case QREditTypeBg:
            return [QRSourceManager getBGPath];
            break;
        default:
            return @"";
            break;
    }

}
- (NSMutableArray *)remoteSourceArr {
    if (!_remoteSourceArr) {
        _remoteSourceArr = [[NSMutableArray alloc] init];
    }
    return _remoteSourceArr;
}
- (RACSubject *)rac_qrSourceChangeSingle {
    if (!_rac_qrSourceChangeSingle) {
        // RACSubject *sub = [RACSubject subject];
        _rac_qrSourceChangeSingle =  [RACSubject subject];
    }
    return _rac_qrSourceChangeSingle;
}

@end
