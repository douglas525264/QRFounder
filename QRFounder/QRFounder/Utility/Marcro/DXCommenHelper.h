//
//  DXCommenHelper.h
//  QRFounder
//
//  Created by dongxin on 16/2/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#ifndef DXCommenHelper_h
#define DXCommenHelper_h
#import "RemoteSever.h"
#import "SourcePath.h"
/**
 *  全局通用宏定义
 */

#ifndef DEBUG
#undef NSLog
#define NSLog(args, ...)
#endif

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ADENABLE   YES

#define IS_IOS8 [[UIDevice currentDevice] systemVersion].floatValue >= 8.0
#define IS_IOS9 [[UIDevice currentDevice] systemVersion].floatValue >= 9.0
#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define RGB(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]
//RGB(33,188,225,1)
#define DefaultColor [UIColor colorWithPatternImage:[[DXHelper shareInstance] getBgImage]]
#define QRImage(a) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:a ofType:@"png"]]
/**
 *  二维码种类
 */
typedef NS_ENUM(NSInteger,QRType) {
    /**
     *  普通文本类型
     */
    QRTypeText,
    /**
     *  身份信息
     */
    QRTypeMyCard,
    /**
     *  APP 推广类型
     */
    QRTypeAPP,
    /**
     *  HTTP 连接
     */
    QRTypeHTTP,
    /**
     *  发送消息类型
     */
    QRTypeMsg,
    /**
     *  发邮件类型
     */
    QRTypeMail,
    /**
     *  位置信息类型
     */
    //QRTypePosition,
    /**
     *  wifi 类型
     */
    QRTypeWIFI
    
};
/**
 *  编辑类型
 */
typedef NS_ENUM(NSInteger,QREditType) {
    /**
     *  背景图片
     */
    QREditTypeBg,
    /**
     *  边框
     */
    QREditTypeBoarder,
    /**
     *  logo
     */
    QREditTypeLogo,
    /**
     *  color
     */
    QREditTypeColor,
    /**
     *  DIY
     */
    QREditTypeDIY,
    //moreColor
    QREditTypeMoreColor
};

//MyCard
static NSString *NAME_KEY = @"qrnamekey";
static NSString *COMPANY_KEY = @"qrcompanykey";
static NSString *JOP_KEY = @"qrjopkey";
static NSString *TELEPHONE_KEY = @"qrtelephonekey";
static NSString *FAX_KEY = @"qrfaxkey";
static NSString *MAIL_KEY = @"qrmailkey";
static NSString *ADDRESS_KEY = @"qraddresskey";
static NSString *HOMEPAGE_KEY = @"qrhomepagekey";
static NSString *NOTE_KEY = @"qrnotekey";

//WIFI
static NSString *WIFI_NAME_KEY = @"wifiNameKey";
static NSString *ENTRYPT_WAY_KEY = @"entryptKey";
static NSString *PSW_KEY = @"pswKey";
//msg
static NSString *SEND_TO_KEY = @"sendToKey";
static NSString *SEND_BODY_KEY = @"sendbodyKey";

#endif /* DXCommenHelper_h */
