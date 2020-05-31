//
//  HDCategoryDotView.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryDotCell.h"
#import "HDCategoryDotCellModel.h"
#import "HDCategoryTitleView.h"

@interface HDCategoryDotView : HDCategoryTitleView
/// 相对于titleLabel的位置，默认：HDCategoryDotRelativePosition_TopRight
@property (nonatomic, assign) HDCategoryDotRelativePosition relativePosition;
/// @[@(布尔值)]数组，控制红点是否显示
@property (nonatomic, copy) NSArray<NSNumber *> *dotStates;
/// 红点的尺寸。默认：CGSizeMake(5, 5)
@property (nonatomic, assign) CGSize dotSize;
/// 红点的圆角值。默认：HDCategoryViewAutomaticDimension（self.dotSize.height/2）
@property (nonatomic, assign) CGFloat dotCornerRadius;
/// 红点的颜色。默认：[UIColor redColor]
@property (nonatomic, strong) UIColor *dotColor;
/// 红点  x, y 方向的偏移 （+值：水平方向向右，竖直方向向下）
@property (nonatomic, assign) CGPoint dotOffset;
@end
