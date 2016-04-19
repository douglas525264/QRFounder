//
//  WWProNode.h
//  WeiWuPro
//
//  Created by dongxin on 16/1/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#ifndef WWProNode_h
#define WWProNode_h
/**
 
 需注意，所有文件请根据下方列出的目录结构进行管理
 进行文件添加时请尽量完善下方目录，以便他人参考
 
 */

#pragma mark -
#pragma mark total 各目录职能
/**
 @Author dongxin, 01-27 13:10
 
 项目目录修改
 各目录职能
 |- WorkLog     这个目录存放每个人的工作日志，当在项目中增加、删除、修改类或文件夹时需要在日志中进行记录，以便其他人快速了解项目改动。
 
 |- Utility     这个目录下面放一些通用类以遍其他人在项目中使用
 
 |- ZayaAppDelegate 这个目录下放的是ZayaAppDelegate.h(.m)文件
 
 |- App         这个目录下存放整个项目Ui层实现部分
 
 |- Resources   这个目录下放了整个项目锁用到的资源文件
 
 |- Supporting Files     这个目录放一些项目配置文件。
 */

#pragma mark -
#pragma mark WeiWuAppDelegate 这个目录下放的是ZayaAppDelegate.h(.m)文件
//  这就不用介绍了
#pragma mark -
#pragma mark WorkLog 这个目录存放每个人的工作日志，当在项目中增加、删除、修改类或文件夹时需要在日志中进行记录，以便其他人快速了解项目改动。
/**
 *  具体格式参照项目中已有日志
 */
#pragma mark -
#pragma mark Utility     这个目录下面放一些通用类以遍其他人在项目中使用
/**
 @Author dongxin, 05-15 13:10
 
 各目录职能
 |- Category    这个目录用于存储对系统类型进行扩展属性及方法的类
 
 |- Classes     这个目录下面放一些个人封装通用类(例如:视频、音频播放器,下拉加载控件等通用控件),以遍其他人在项目中使用
 
 |- Helpers     这个目录用于存储项目中用到的工具类
 
 |- Macro       这个目录下存放整个项目用到的宏定义(资源名称，服务器接口，一些通用的宏定义等)。
 
 |- Libs        这个目录下放了整个项目用到得手动添加的第三方类库
 
 */
#pragma mark -
#pragma mark - App   这个目录下存放整个项目Ui层实现部分
/**
 @Author dongxin, 05-15 13:10
 
 各目录职能
 |- Controller  这个目录用于存储项目用到的视图控制器
 |- General  通用视图控制器
 |- Sections 按功能划分的视图控制器
 |- StoryBoards 所用到的故事版
 
 |- View        这个目录用于存储项目的视图层
 |- General  通用视图
 |- Sections 按功能划分的视
 
 |- Model       这个目录用于存项目的数据模型
 
 
 */
#pragma mark -
#pragma Resources   这个目录下放了整个项目锁用到的资源文件
/**
 @Author dongxin, 05-15 13:10
 
 各目录职能
 |- CommonImages   这个目录用于存储项目中通用的一些图片
  
 |- Sounds         这个目录用于存储项目中用到的音频资源
 
 |- Videos         这个目录用于存储项目中用到的视频资源
 
 |- OtherStoreRes  这个目录下放了整个项目用到的其他资源
 
 */

#pragma mark -
#pragma Supporting Files     这个目录放一些项目配置文件。
/**
 @Author dongxin, 05-15 13:10
 
 各目录职能
 |- Local       这个目录用于存储项目有关本地化以及国际化的文件
 
 |- ConfigFiles     这个目录下面项目支持的配置文件
 */



#endif /* WWProNode_h */
