//
//  DXQRScanView.m
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXQRScanView.h"
#import "DXCommenHelper.h"
@interface DXQRScanView()

@property (nonatomic, strong) UIImageView *imageV;

@end
@implementation DXQRScanView
{

    BOOL isAnimationing;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx,  RGB(0, 0, 0, 0.8).CGColor);
    
    if (self.ScanRect.size.width > 0) {
        CGContextAddRect(ctx, CGRectMake(0, 0, rect.size.width, self.ScanRect.origin.y));
        CGContextAddRect(ctx, CGRectMake(0, self.ScanRect.origin.y, self.ScanRect.origin.x, self.ScanRect.size.height));
        CGContextAddRect(ctx, CGRectMake(self.ScanRect.origin.x + self.ScanRect.size.width, self.ScanRect.origin.y, rect.size.width - self.ScanRect.origin.x - self.ScanRect.size.width, self.ScanRect.size.height));
        CGContextAddRect(ctx, CGRectMake(0, self.ScanRect.origin.y + self.ScanRect.size.height, rect.size.width, rect.size.height - self.ScanRect.origin.y - self.ScanRect.size.height));
        
                               
    }else {
    
        CGContextAddRect(ctx, rect);
    }
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    
    //画矩形框4格外围相框角
    
    //相框角的宽度和高度
    int wAngle = 15;
    int hAngle = 15;
    
    //4个角的 线的宽度
    CGFloat linewidthAngle = 4;// 经验参数：6和4
    
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = linewidthAngle/3;
    //diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
    //diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //diffAngle = 0;//与矩形框重合
    CGContextSetStrokeColorWithColor(ctx,DefaultColor.CGColor);
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(ctx, linewidthAngle);
    
    
    //
    CGFloat XRetangleLeft  = self.ScanRect.origin.x;
    CGFloat YMinRetangle = self.ScanRect.origin.y;
    
    CGFloat YMaxRetangle = YMinRetangle + self.ScanRect.size.height;
    CGFloat XRetangleRight = self.frame.size.width - XRetangleLeft;
    
    
    CGFloat leftX = XRetangleLeft - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    
    //左上角水平线
    CGContextMoveToPoint(ctx, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(ctx, leftX + wAngle, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(ctx, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(ctx, leftX, topY+hAngle);
    
    
    //左下角水平线
    CGContextMoveToPoint(ctx, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(ctx, leftX + wAngle, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(ctx, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(ctx, leftX, bottomY - hAngle);
    
    
    //右上角水平线
    CGContextMoveToPoint(ctx, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(ctx, rightX - wAngle, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(ctx, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(ctx, rightX, topY + hAngle);
    
    
    //右下角水平线
    CGContextMoveToPoint(ctx, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(ctx, rightX - wAngle, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(ctx, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(ctx, rightX, bottomY - hAngle);
    
    CGContextStrokePath(ctx);
    
}
- (void)setScanRect:(CGRect)ScanRect {

    _ScanRect = ScanRect;
    self.backgroundColor = [UIColor clearColor];
    [self.layer needsDisplay];
}
- (void)startAnimation {
    isAnimationing = YES;
    [self addSubview:self.imageV];
    CGRect Orframe = self.ScanRect;
    
    Orframe.size.height = 2;
    CGRect toFrame = Orframe;
    //toFrame.size.height = self.ScanRect.size.height;
    toFrame.origin.y = self.ScanRect.origin.y + self.ScanRect.size.height - Orframe.size.height;
    [UIView animateWithDuration:2 animations:^{
        self.imageV.frame = toFrame;
    } completion:^(BOOL finished) {
        self.imageV.frame = Orframe;
        if (isAnimationing) {
            [self startAnimation];
        }
    }];
    
}
- (void)stopAnimation {
    isAnimationing = NO;
    [self.imageV removeFromSuperview];
}
- (UIImageView *)imageV {

    if (!_imageV) {
        CGRect frame = self.ScanRect;
        frame.size.height = 2;
        _imageV = [[UIImageView alloc] initWithFrame:frame];
        _imageV.image = [UIImage imageNamed:@"qrcode_scan_light_green"];
        [self addSubview:_imageV];
    }
    return _imageV;
}



@end
