//
//  DXMenuBtn.m
//  QRFounder
//
//  Created by dongxin on 16/3/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXMenuBtn.h"
#define space 5
@implementation DXMenuBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat minWidth = MIN(contentRect.size.height, contentRect.size.width);
    if (minWidth < 2*space) {
        
    } else {
        minWidth = minWidth - 2*space;
    }
    return CGRectMake(contentRect.origin.x + contentRect.size.width/2 - minWidth/2, contentRect.origin.y + contentRect.size.height/2 -minWidth/2, minWidth, minWidth);
}

@end
