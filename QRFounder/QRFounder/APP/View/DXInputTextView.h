//
//  DXInputTextView.h
//  zapyaNewPro
//
//  Created by dongxin on 15/9/21.
//  Copyright (c) 2015年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXInputTextView : UITextView
/**
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;
/**
 *  允许显示最大行数 默认 10
 */
@property (nonatomic, assign) NSInteger MaxDisplayLine;

/**
 *  获取自身文本占据有多少行
 *
 *  @return 返回行数
 */
- (NSUInteger)numberOfLinesOfText;

/**
 *  获取每行的高度
 *
 *  @return 根据iPhone或者iPad来获取每行字体的高度
 */
+ (NSUInteger)maxCharactersPerLine;

/**
 *  获取某个文本占据自身适应宽带的行数
 *
 *  @param text 目标文本
 *
 *  @return 返回占据行数
 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

@end
