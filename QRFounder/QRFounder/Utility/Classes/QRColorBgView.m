//
//  QRColorBgView.m
//  LayerTest
//
//  Created by Douglas on 16/11/10.
//  Copyright © 2016年 Douglas. All rights reserved.
//

#import "QRColorBgView.h"
@interface QRColorBgView()

@end
@implementation QRColorBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setColors:(NSArray *)colors {

    _colors = colors;
    [self.layer setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.colors.count == 0) {
       
    }else {
    NSInteger count = self.colors.count;
        
    switch (self.type) {
        case BgColorTypeRound:{
            CGContextRef context = UIGraphicsGetCurrentContext();
            NSInteger drawCount = 0;
            CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
            double ra = sqrt(pow((center.y - 0), 2) + pow((center.x - 0), 2));
            double oneAngle = M_PI*2/count;
            double startAngle = -M_PI/2;
            for (UIColor *color in self.colors) {
                CGContextMoveToPoint(context, center.x, center.y);
                CGContextSetFillColorWithColor(context, color.CGColor);
                
                CGContextAddArc(context, center.x, center.y, ra,startAngle + oneAngle * drawCount, startAngle + oneAngle * (drawCount + 1), 0);
                CGContextClosePath(context);
                CGContextFillPath(context);
                drawCount ++;
            }
           
            
        }break;
        case BgColorTypegradual:{
            CAGradientLayer *gradient1 = [CAGradientLayer layer];
            gradient1.frame = rect;
            gradient1.startPoint = CGPointMake(0, 0);
            if (self.angle) {
              gradient1.endPoint = CGPointMake(1, atan(self.angle));
            }else {
              gradient1.endPoint = CGPointMake(1, 0);
            }
            
            
            NSMutableArray *colorArr = [[NSMutableArray alloc] init];
            for (UIColor *color in self.colors) {
                [colorArr addObject:(id)color.CGColor];
            }
            gradient1.colors = colorArr;
            [self.layer insertSublayer:gradient1 atIndex:0];
        }break;
        case BgColorTypeLine:{
            
            CGFloat width = sqrt(pow(rect.size.width, 2)+pow(rect.size.width, 2));
            double an = fabs(self.angle);
            while (an >= M_PI_2) {
                an -= M_PI_2;
            }
            width = width * cos(M_PI_2/2 - an);
            CAShapeLayer *bgLayer = [CAShapeLayer layer];
            CAShapeLayer *frameLayer = [CAShapeLayer layer];
            frameLayer.frame = rect;
            frameLayer.backgroundColor = [UIColor clearColor].CGColor;
            bgLayer.frame = CGRectMake(rect.size.width/2 -width/2, rect.size.width/2 - width/2, width, width);
            bgLayer.backgroundColor = [UIColor yellowColor].CGColor;
            NSInteger i = 0;
            CGFloat oneWidth = width/self.colors.count;
            for (UIColor *color in self.colors) {
                CAShapeLayer *sLayer = [CAShapeLayer layer];
                sLayer.frame = CGRectMake(oneWidth * i, 0, oneWidth, width);
                sLayer.backgroundColor = color.CGColor;
                [bgLayer addSublayer:sLayer];
                i ++;
            }
            
            self.layer.masksToBounds = YES;
            bgLayer.transform = CATransform3DMakeRotation(self.angle, 0, 0, 1);
            [self.layer insertSublayer:bgLayer atIndex:0];
            
         //   bgLayer.fillColor = [UIColor clearColor].CGColor;
            
        }break;
            
        default:
            break;
    }
    }
}

@end
