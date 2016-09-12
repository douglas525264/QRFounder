//
//  dxBgView.m
//  QRFounder
//
//  Created by douglas on 16/9/12.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "dxBgView.h"
@interface dxBgView()

@end
@implementation dxBgView
- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
