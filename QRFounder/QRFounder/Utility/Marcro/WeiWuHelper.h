//
//  WeiWuHelper.h
//  WeiWuPro
//
//  Created by dongxin on 16/1/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#ifndef WeiWuHelper_h
#define WeiWuHelper_h
/**
 *  全局通用宏定义文件
 */
#import "RemoteSever.h"
#ifndef DEBUG
#undef NSLog
#define NSLog(args, ...)
#endif

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


#define IS_IOS8 [[UIDevice currentDevice] systemVersion].floatValue >= 8.0

#endif /* WeiWuHelper_h */
