//
//  HDCategoryNumberView.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryNumberCell.h"
#import "HDCategoryNumberCellModel.h"
#import "HDCategoryTitleView.h"

@interface HDCategoryNumberView : HDCategoryTitleView

/**
 需要与 titles 的 count 对应
 */
@property (nonatomic, copy) NSArray<NSNumber *> *counts;
/**
 内部默认不会格式化数字，直接转成字符串显示。比如业务需要数字超过999显示999+，可以通过该block实现。
 */
@property (nonatomic, copy) NSString * (^numberStringFormatterBlock)(NSInteger number);
/**
 numberLabel的font，默认：[UIFont systemFontOfSize:11]
 */
@property (nonatomic, strong) UIFont *numberLabelFont;
/**
 数字的背景色，默认：[UIColor colorWithRed:241/255.0 green:147/255.0 blue:95/255.0 alpha:1]
 */
@property (nonatomic, strong) UIColor *numberBackgroundColor;
/**
 数字的title颜色，默认：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *numberTitleColor;
/**
 numberLabel的宽度补偿，label真实的宽度是文字内容的宽度加上补偿的宽度，默认：10
 */
@property (nonatomic, assign) CGFloat numberLabelWidthIncrement;
/**
 numberLabel的高度，默认：14
 */
@property (nonatomic, assign) CGFloat numberLabelHeight;
/**
 numberLabel  x,y方向的偏移 （+值：水平方向向右，竖直方向向下）
 */
@property (nonatomic, assign) CGPoint numberLabelOffset;

@end
