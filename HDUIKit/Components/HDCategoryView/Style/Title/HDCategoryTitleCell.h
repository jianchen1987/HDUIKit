//
//  HDCategoryTitleCell.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorCell.h"
#import "HDCategoryViewDefines.h"
@class HDCategoryTitleCellModel;

@interface HDCategoryTitleCell : HDCategoryIndicatorCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *maskTitleLabel;
@property (nonatomic, strong, readonly) NSLayoutConstraint *titleLabelCenterX;
@property (nonatomic, strong, readonly) NSLayoutConstraint *titleLabelCenterY;
@property (nonatomic, strong, readonly) NSLayoutConstraint *maskTitleLabelCenterX;

- (HDCategoryCellSelectedAnimationBlock)preferredTitleZoomAnimationBlock:(HDCategoryTitleCellModel *)cellModel baseScale:(CGFloat)baseScale;

- (HDCategoryCellSelectedAnimationBlock)preferredTitleStrokeWidthAnimationBlock:(HDCategoryTitleCellModel *)cellModel attributedString:(NSMutableAttributedString *)attributedString;

- (HDCategoryCellSelectedAnimationBlock)preferredTitleColorAnimationBlock:(HDCategoryTitleCellModel *)cellModel;

@end
