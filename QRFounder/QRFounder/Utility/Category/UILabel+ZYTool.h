//
//  UILabel+ZYTool.h
//  zapyaNewPro
//
//  Created by dongxin on 15/6/10.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZYTool)

//lable不变情况下,在一定范围内动态调节字体
- (NSInteger)AdjustFontSizeWithMinSize:(CGFloat) min AndMaxSize:(CGFloat) max IsFull:(BOOL)isfull;

- (void)adjustFont:(NSString *)fontName minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize isFull:(BOOL)isFull;

/**
 *  宽度不变依据字体适配自身高度
 */
- (void)AdjustCurrentFont;
- (void)AdjustWithFont:(UIFont *)font;
/**
 *  宽度无限获取一行字符串size
 *
 *  @param text
 *  @param font
 *
 *  @return Size
 */
+ (CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font;
+ (CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font andWidth:(CGFloat)width;
/**
 *  宽度自适应
 */
- (void)makeWidthAdaptive;

/**
 *  高度自适应
 */
- (void)makeHeightAdaptive;

@end
