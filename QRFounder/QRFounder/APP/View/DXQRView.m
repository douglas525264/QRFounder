//
//  DXQRView.m
//  QRFounder
//
//  Created by dongxin on 16/3/17.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "DXQRView.h"
#import "qrencode.h"
#define BGAPLAH 0.7 //四周黑框颜色 以及白边透明度
#define SMALLBGPLAH 0.2 //小背景透明度
#define SMALLPLAH 0.5 //小块透明度
enum {
    qr_margin = 1
};

@interface DXQRView()

@property (nonatomic, strong) UIColor *QRColor;

@end
@implementation DXQRView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)setQrModel:(QRModel *)qrModel {

    _qrModel = qrModel;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!_qrModel) {
        return;
    }
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(cxt);
    //CGRect rectDraw = CGRectMake(0, 0, zoom, zoom);
    
    CGContextSetFillColorWithColor(cxt, [UIColor whiteColor].CGColor);
    CGContextAddRect(cxt,rect);
    CGContextFillPath(cxt);
    QRecLevel lef = QR_ECLEVEL_Q;
    if (_qrModel.QRStr.length > 64) {
        lef = QR_ECLEVEL_M;
    }
    if (_qrModel.QRStr.length > 128) {
        lef = QR_ECLEVEL_L;
    }
    
    QRcode *code = QRcode_encodeString([_qrModel.QRStr UTF8String], 0, lef, QR_MODE_8, 1);
    [self drawQRCode:code context:cxt size:rect.size.width];
}

- (void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size {
    
    
    if (_qrModel.bgImage && !_qrModel.codeColor) {
        [self drawBgQRCode:code context:ctx size:size];
    } else {
        unsigned char *data = 0;
        int width;
        
        data = code->data;
        width = code->width;
        float zoom = (double)size / (code->width + 2.0 * qr_margin);
        UIGraphicsPushContext(ctx);
        CGRect rectDraw = CGRectMake(0, 0, zoom, zoom);

        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextAddRect(ctx, CGRectMake(0, 0, size, size));
        CGContextFillPath(ctx);
        
        
        if (_qrModel.codeColor) {
            CGContextSetFillColorWithColor(ctx,_qrModel.codeColor.CGColor);
        } else {
            CGContextSetFillColorWithColor(ctx,RGB(0, 0, 0, 1).CGColor);
        }
        for(int i = 0; i < width; ++i) {
            for(int j = 0; j < width; ++j) {
                if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                    CGContextAddRect(ctx, rectDraw);
                    
                }else {
                
                    
                }
                ++data;
            }
        }
        
         CGContextFillPath(ctx);
    }
}



- (void)drawBgQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size {
    unsigned char *data = 0;
    int width;
    
    data = code->data;
    width = code->width;
    NSInteger blackW = 0;
    
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; j = 0) {
            if(*data & 1) {
                blackW ++;
            }else {
                break;
            }
            ++data;
        }
    }
    
    
    
    float zoom = (double)size / (code->width + 2.0 * qr_margin);
    CGRect rectDraw = CGRectMake(0, 0, zoom, zoom);

    // draw
    if (_qrModel.boarderImage) {
        
    }else {
        //边框填充白颜色
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextAddRect(ctx, CGRectMake(0, 0, size, size));
        CGContextFillPath(ctx);
        UIGraphicsPushContext(ctx);

    }
    //背景图片
    UIImage *image = _qrModel.bgImage;
    
    [image drawInRect:CGRectMake(zoom, zoom, size - 2 * zoom, size - 2* zoom)];
    
    
    data = code->data;
    CGContextSetFillColorWithColor(ctx,RGB(0, 0, 0, BGAPLAH).CGColor);
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    [self drawBlackRectInRect:rectDraw alph:BGAPLAH andContext:ctx];
                    
                }else {
                    
                    // [self drawSmallBlackRectInRect:rectDraw andContext:ctx];
                }
                //CGContextAddRect(ctx, rectDraw);
            }else {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    // [self drawWhiteRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    //CGContextAddRect(ctx, rectDraw);
                    // [self drawSmallWhitRectInRect:rectDraw andContext:ctx];
                }
                
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
    data = code->data;
    CGContextSetFillColorWithColor(ctx,RGB(255, 255, 255, BGAPLAH).CGColor);
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    // [self drawBlackRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    
                    // [self drawSmallBlackRectInRect:rectDraw andContext:ctx];
                }
                //CGContextAddRect(ctx, rectDraw);
            }else {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    [self drawWhiteRectInRect:rectDraw alph:BGAPLAH andContext:ctx];
                    
                }else {
                    //CGContextAddRect(ctx, rectDraw);
                    // [self drawSmallWhitRectInRect:rectDraw andContext:ctx];
                }
                
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
    CGContextSetFillColorWithColor(ctx,RGB(0, 0, 0, SMALLBGPLAH).CGColor);
    data = code->data;
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    // [self drawBlackRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    
                    [self drawBlackRectInRect:rectDraw alph:SMALLBGPLAH andContext:ctx];
                }
                //CGContextAddRect(ctx, rectDraw);
            }else {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    //  [self drawWhiteRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    //CGContextAddRect(ctx, rectDraw);
                    // [self drawWhiteRectInRect:rectDraw alph:0.2 andContext:ctx];
                }
                
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
    data = code->data;
    CGContextSetFillColorWithColor(ctx,RGB(255, 255, 255, SMALLBGPLAH).CGColor);
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    // [self drawBlackRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    
                    // [self drawBlackRectInRect:rectDraw alph:0.2 andContext:ctx];
                }
                //CGContextAddRect(ctx, rectDraw);
            }else {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    //  [self drawWhiteRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    //CGContextAddRect(ctx, rectDraw);
                    [self drawWhiteRectInRect:rectDraw alph:SMALLBGPLAH andContext:ctx];
                }
                
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
    
    data = code->data;
    CGContextSetFillColorWithColor(ctx,RGB(0, 0, 0, SMALLPLAH).CGColor);
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    //  [self drawBlackRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    
                    [self drawSmallBlackRectInRect:rectDraw andContext:ctx];
                }
                //CGContextAddRect(ctx, rectDraw);
            }else {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    //  [self drawWhiteRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    //CGContextAddRect(ctx, rectDraw);
                    //  [self drawSmallWhitRectInRect:rectDraw andContext:ctx];
                }
                
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
    data = code->data;
    CGContextSetFillColorWithColor(ctx,RGB(255, 255, 255, SMALLPLAH).CGColor);
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    
                    
                }else {
                    
                    
                }
            }else {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if ((i < blackW && j < blackW)
                    || (i < blackW && (j >= (width - blackW)))
                    || (i >= (width - blackW) && (j < blackW))) {
                    //[self drawWhiteRectInRect:rectDraw alph:0.6 andContext:ctx];
                    
                }else {
                    //CGContextAddRect(ctx, rectDraw);
                    [self drawSmallWhitRectInRect:rectDraw andContext:ctx];
                }
                
            }
            ++data;
        }
    }
    
    CGContextFillPath(ctx);

    
}
- (void)drawBlackRectInRect:(CGRect)rect alph:(CGFloat) alp andContext:(CGContextRef)ctx {
    
    
    CGContextAddRect(ctx, rect);
   // CGContextFillPath(ctx);
}
- (void)drawWhiteRectInRect:(CGRect)rect alph:(CGFloat) alp andContext:(CGContextRef)ctx {
    
    
    CGContextAddRect(ctx, rect);
    
}
- (void)drawSmallBlackRectInRect:(CGRect)rect andContext:(CGContextRef)ctx{
    
    
   // CGContextAddRect(ctx, rect);
    CGContextAddRect(ctx, CGRectMake(rect.origin.x + rect.size.width * 1.5 /8, rect.origin.y + rect.size.height * 1.5/8, rect.size.width * 5/8, rect.size.height * 5/8));
    //CGContextFillPath(ctx);
}
- (void)drawSmallWhitRectInRect:(CGRect)rect andContext:(CGContextRef)ctx{
    //[self drawWhiteRectInRect:rect alph:0.2 andContext:ctx];
    
    
    // CGContextAddRect(ctx, rect);
    CGContextAddRect(ctx, CGRectMake(rect.origin.x + rect.size.width * 1.5/8, rect.origin.y + rect.size.height* 1.5/8, rect.size.width * 5/8, rect.size.height * 5/8));
  //  CGContextFillPath(ctx);
}



- (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size {
    if (![string length]) {
        return nil;
    }
    
    QRcode *code = QRcode_encodeString([string UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    if (!code) {
        return nil;
    }
    
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace, 1);
    
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -size);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
    
    // draw QR on this context
    [self drawQRCode:code context:ctx size:size];
    
    // get image
    CGImageRef qrCGImage = CGBitmapContextCreateImage(ctx);
    UIImage * qrImage = [UIImage imageWithCGImage:qrCGImage];
    
    // some releases
    CGContextRelease(ctx);
    CGImageRelease(qrCGImage);
    CGColorSpaceRelease(colorSpace);
    QRcode_free(code);
    
    return qrImage;
}
@end
