//
//  FuqianlaPay+scheme.m
//  CEFastPayAggrDemo
//
//  Created by zzf073 on 17/1/11.
//  Copyright © 2017年 zzf073. All rights reserved.
//

#import "FuqianlaPay+scheme.h"

@implementation FuqianlaPay (scheme)

@dynamic callBackScheme;

-(NSString*)callBackScheme
{
#if QRFounderPRO
    return @"fqianlaqrcodepro";
#else
   return @"fqianlaqrcode"; 
#endif
}

-(void)setCallBackScheme:(NSString *)callBackScheme
{
    
}

@end
