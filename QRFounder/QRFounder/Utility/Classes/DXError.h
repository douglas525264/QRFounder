//
//  DXError.h
//  QRFounder
//
//  Created by douglas on 2017/2/16.
//  Copyright © 2017年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXError : NSObject
@property (nonatomic, assign)NSInteger code;
@property (nonatomic, copy) NSString *desStr;
@end
