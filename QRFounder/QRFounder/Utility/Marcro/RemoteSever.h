//
//  RemoteSever.h
//  WeiWuPro
//
//  Created by dongxin on 16/1/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#ifndef RemoteSever_h
#define RemoteSever_h
/**
 *  服务器宏定义
 */
#define Schema @"http://"
#define weiWuHost @"www.opendreamer.cn"
#define mainURL [NSString stringWithFormat:@"%@%@%@",Schema,weiWuHost,@"index/appJump?device?android&package=%@&appid=@%"]
#define appUrl [NSString stringWithFormat:@"%@%@/%@",Schema,weiWuHost,@"index/appJump?device=?android&package=%@&appleId=%@"]
#define sourceURL @"http://localhost:8888/QRCodeSever/sourceList.php"
#endif /* RemoteSever_h */
