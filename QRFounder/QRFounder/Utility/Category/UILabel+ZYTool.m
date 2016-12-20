//
//  UILabel+ZYTool.m
//  zapyaNewPro
//
//  Created by dongxin on 15/6/10.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import "UILabel+ZYTool.h"

@implementation UILabel (ZYTool)



- (void)adjustFont:(NSString *)fontName minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize isFull:(BOOL)isFull {
    if (self.text && self.text.length <= 1) {
        return;
    }
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    
    CGSize Allsize = [self getSizeWithattributes:dic];
    
    if (Allsize.height>self.frame.size.height) {
        return [self adjustFont:fontName minSize:minSize AndMaxSize:maxSize];
    }else
    {
        if (isFull) {
            return [self adjustFont:fontName minSize:minSize AndMaxSize:maxSize];
        }
    }
}

-(void)adjustFont:(NSString *)fontName minSize:(CGFloat)min AndMaxSize:(CGFloat)max {
    BOOL isad = NO;
    for (CGFloat i = max; i >= min; i--) {
        self.font = [UIFont fontWithName:fontName size:i];
        NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
        CGSize Allsize = [self getSizeWithattributes:dic];
        if (Allsize.height <= self.frame.size.height) {
            // isad = YES;
            self.font = [UIFont fontWithName:fontName size:i];
            return;
            break;
        }
    }
    if (!isad) {
        self.font = [UIFont fontWithName:fontName size:min];
        return;
    }
}


-(NSInteger)AdjustFontSizeWithMinSize:(CGFloat) min AndMaxSize:(CGFloat) max IsFull:(BOOL)isfull
{
    
    if (self.text && self.text.length <= 1) {
        return 0;
    }
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    
    CGSize Allsize = [self getSizeWithattributes:dic];
    
    if (Allsize.height>self.frame.size.height) {
       return [self AdjustFontSizeWithMinSize:min AndMaxSize:max];
    }else
    {
        if (isfull) {
          return  [self AdjustFontSizeWithMinSize:min AndMaxSize:max];
        }
    }
    return 0;
}
- (NSInteger)AdjustFontSizeWithMinSize:(CGFloat) min AndMaxSize:(CGFloat) max
{
    BOOL isad = NO;
    
    for (CGFloat i = max; i >= min; i--) {
        self.font = [UIFont systemFontOfSize:i];
        NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
        CGSize Allsize = [self getSizeWithattributes:dic];
        if (Allsize.height <= self.frame.size.height) {
           // isad = YES;
            self.font = [UIFont systemFontOfSize:i];
            return i;
            break;
        }
    }
    if (!isad) {
        self.font=[UIFont systemFontOfSize:min];
        return min;
    }
    return 0;
}
- (void)AdjustCurrentFont
{
    [self AdjustWithFont:self.font];
}
- (void)AdjustWithFont:(UIFont *)font
{
    self.numberOfLines=0;
    self.font=font;
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    
    CGSize Allsize=[self getSizeWithattributes:dic];
    // NSLog(@"%@",self.text);
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, Allsize.width, Allsize.height);
    self.lineBreakMode=NSLineBreakByCharWrapping;
    
}
- (CGSize)getSizeWithattributes:(NSDictionary *)dic
{
    CGSize Allsize;
    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
        Allsize =[self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 1990) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|
                  NSStringDrawingUsesFontLeading       attributes:dic context:nil].size;
    }else
    {
        Allsize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 1990) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return Allsize;
}
+ (CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font andWidth:(CGFloat)width{

    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize allSize;
    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
        allSize =[text boundingRectWithSize:CGSizeMake(width, 1990) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|
                  NSStringDrawingUsesFontLeading       attributes:dic context:nil].size;
    }else
    {
        allSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 1990) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return allSize;

}
+ (CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize allSize;
    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
        allSize =[text boundingRectWithSize:CGSizeMake(1990, 1990) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|
                  NSStringDrawingUsesFontLeading       attributes:dic context:nil].size;
    }else
    {
        allSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(1990, 1990) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return allSize;

}


- (void)makeWidthAdaptive {
    
    self.textAlignment = NSTextAlignmentLeft;
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.font.pointSize) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font, NSForegroundColorAttributeName : self.textColor} context:nil].size;
    
    self.bounds = CGRectMake(0, 0, textSize.width, self.font.pointSize);
}

- (void)makeHeightAdaptive {
    
    self.textAlignment = NSTextAlignmentLeft;
    
    self.numberOfLines = 0;
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font, NSForegroundColorAttributeName: self.textColor} context:nil].size;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, textSize.height);
}


@end
