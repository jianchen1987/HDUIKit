//
//  HDCategoryTitleCellModel.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorCellModel.h"
#import "HDCategoryViewDefines.h"
#import <UIKit/UIKit.h>

@interface HDCategoryTitleCellModel : HDCategoryIndicatorCellModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 标题行数
@property (nonatomic, assign) NSInteger titleNumberOfLines;
/// 标题默认颜色
@property (nonatomic, strong) UIColor *titleNormalColor;
/// 标题当前颜色
@property (nonatomic, strong) UIColor *titleCurrentColor;
/// 标题选中颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;
/// 默认字体
@property (nonatomic, strong) UIFont *titleFont;
/// 选中字体
@property (nonatomic, strong) UIFont *titleSelectedFont;
/// mask 启用与否
@property (nonatomic, assign, getter=isTitleLabelMaskEnabled) BOOL titleLabelMaskEnabled;
/// 缩放 启用与否
@property (nonatomic, assign, getter=isTitleLabelZoomEnabled) BOOL titleLabelZoomEnabled;
/// 标题默认状态缩放系数
@property (nonatomic, assign) CGFloat titleLabelNormalZoomScale;
/// 标题当前缩放系数
@property (nonatomic, assign) CGFloat titleLabelCurrentZoomScale;
/// 标题选中状态缩放系数
@property (nonatomic, assign) CGFloat titleLabelSelectedZoomScale;
/// 选中时垂直方向偏移
@property (nonatomic, assign) CGFloat titleLabelZoomSelectedVerticalOffset;
@property (nonatomic, assign, getter=isTitleLabelStrokeWidthEnabled) BOOL titleLabelStrokeWidthEnabled;
@property (nonatomic, assign) CGFloat titleLabelNormalStrokeWidth;
@property (nonatomic, assign) CGFloat titleLabelCurrentStrokeWidth;
@property (nonatomic, assign) CGFloat titleLabelSelectedStrokeWidth;
@property (nonatomic, assign) CGFloat titleLabelVerticalOffset;
@property (nonatomic, assign) HDCategoryTitleLabelAnchorPointStyle titleLabelAnchorPointStyle;
@end
