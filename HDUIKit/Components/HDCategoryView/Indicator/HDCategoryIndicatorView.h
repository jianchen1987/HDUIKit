//
//  HDCategoryIndicatorView.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryBaseView.h"
#import "HDCategoryIndicatorCell.h"
#import "HDCategoryIndicatorCellModel.h"
#import "HDCategoryIndicatorProtocol.h"

@interface HDCategoryIndicatorView : HDCategoryBaseView

@property (nonatomic, copy) NSArray<UIView<HDCategoryIndicatorProtocol> *> *indicators;
/// cell的背景色是否渐变。默认：NO
@property (nonatomic, assign, getter=isCellBackgroundColorGradientEnabled) BOOL cellBackgroundColorGradientEnabled;
/// cell普通状态的背景色。默认：[UIColor clearColor]
@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;
/// cell选中状态的背景色。默认：[UIColor grayColor]
@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;

/// 是否显示分割线。默认为NO
@property (nonatomic, assign, getter=isSeparatorLineShowEnabled) BOOL separatorLineShowEnabled;
/// 分割线颜色。默认为[UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *separatorLineColor;
/// 分割线的size。默认为CGSizeMake(1/[UIScreen mainScreen].scale, 20)
@property (nonatomic, assign) CGSize separatorLineSize;
@end

@interface HDCategoryIndicatorView (UISubclassingIndicatorHooks)

/**
 当 contentScrollView 滚动时候，处理跟随手势的过渡效果。
 根据 cellModel 的左右位置、是否选中、ratio进行过滤数据计算。

 @param leftCellModel 左边的cellModel
 @param rightCellModel 右边的cellModel
 @param ratio 从左往右方向计算的百分比
 */
- (void)refreshLeftCellModel:(HDCategoryBaseCellModel *)leftCellModel rightCellModel:(HDCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio NS_REQUIRES_SUPER;

@end
