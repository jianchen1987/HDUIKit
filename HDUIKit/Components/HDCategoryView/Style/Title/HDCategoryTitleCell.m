//
//  HDCategoryTitleCell.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryTitleCell.h"
#import "HDCategoryFactory.h"
#import "HDCategoryTitleCellModel.h"

@interface HDCategoryTitleCell ()
@property (nonatomic, strong) CALayer *titleMaskLayer;
@property (nonatomic, strong) CALayer *maskTitleMaskLayer;
@property (nonatomic, strong) NSLayoutConstraint *maskTitleLabelCenterY;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *maskTitleLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterX;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterY;
@property (nonatomic, strong) NSLayoutConstraint *maskTitleLabelCenterX;

@property (nonatomic, strong) NSLayoutConstraint *titleLabelLeft;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelRight;
@end

@implementation HDCategoryTitleCell

- (void)initializeViews {
    [super initializeViews];

    _titleLabel = [[UILabel alloc] init];
    self.titleLabel.clipsToBounds = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    self.titleLabelLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    self.titleLabelRight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];

    self.titleLabelCenterX = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    self.titleLabelCenterY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.titleLabelCenterX.active = YES;
    self.titleLabelCenterY.active = YES;

    _titleMaskLayer = [CALayer layer];
    self.titleMaskLayer.backgroundColor = [UIColor redColor].CGColor;

    _maskTitleLabel = [[UILabel alloc] init];
    self.maskTitleLabel.hidden = YES;
    self.maskTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.maskTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.maskTitleLabel];

    self.maskTitleLabelCenterX = [NSLayoutConstraint constraintWithItem:self.maskTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    self.maskTitleLabelCenterY = [NSLayoutConstraint constraintWithItem:self.maskTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.maskTitleLabelCenterX.active = YES;
    self.maskTitleLabelCenterY.active = YES;

    _maskTitleMaskLayer = [CALayer layer];
    self.maskTitleMaskLayer.backgroundColor = [UIColor redColor].CGColor;
    self.maskTitleLabel.layer.mask = self.maskTitleMaskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    HDCategoryTitleCellModel *myCellModel = (HDCategoryTitleCellModel *)self.cellModel;
    switch (myCellModel.titleLabelAnchorPointStyle) {
        case HDCategoryTitleLabelAnchorPointStyleCenter:
            self.titleLabelCenterY.constant = 0 + myCellModel.titleLabelVerticalOffset;
            break;
        case HDCategoryTitleLabelAnchorPointStyleTop: {
            CGFloat percent = (myCellModel.titleLabelCurrentZoomScale - myCellModel.titleLabelNormalZoomScale) / (myCellModel.titleLabelSelectedZoomScale - myCellModel.titleLabelNormalZoomScale);
            self.titleLabelCenterY.constant = -self.titleLabel.bounds.size.height / 2 - myCellModel.titleLabelVerticalOffset - myCellModel.titleLabelZoomSelectedVerticalOffset * percent;
        } break;
        case HDCategoryTitleLabelAnchorPointStyleBottom: {
            CGFloat percent = (myCellModel.titleLabelCurrentZoomScale - myCellModel.titleLabelNormalZoomScale) / (myCellModel.titleLabelSelectedZoomScale - myCellModel.titleLabelNormalZoomScale);
            self.titleLabelCenterY.constant = self.titleLabel.bounds.size.height / 2 + myCellModel.titleLabelVerticalOffset + myCellModel.titleLabelZoomSelectedVerticalOffset * percent;
        } break;
        default:
            break;
    }
    
    // 因为titleLabel是通过约束布局的，在layoutSubviews方法中，它的frame并没有确定。像子类HDCategoryNumberCell中的numberLabel需要依赖于titleLabel的frame进行布局。所以这里必须立马触发self.contentView的视图布局。
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)reloadData:(HDCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    HDCategoryTitleCellModel *myCellModel = (HDCategoryTitleCellModel *)cellModel;
    self.titleLabel.numberOfLines = myCellModel.titleNumberOfLines;
    self.maskTitleLabel.numberOfLines = myCellModel.titleNumberOfLines;
    switch (myCellModel.titleLabelAnchorPointStyle) {
        case HDCategoryTitleLabelAnchorPointStyleCenter:
            self.titleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.maskTitleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
            break;
        case HDCategoryTitleLabelAnchorPointStyleTop:
            self.titleLabel.layer.anchorPoint = CGPointMake(0.5, 0);
            self.maskTitleLabel.layer.anchorPoint = CGPointMake(0.5, 0);
            break;
        case HDCategoryTitleLabelAnchorPointStyleBottom:
            self.titleLabel.layer.anchorPoint = CGPointMake(0.5, 1);
            self.maskTitleLabel.layer.anchorPoint = CGPointMake(0.5, 1);
            break;
        default:
            break;
    }

    if (myCellModel.isTitleLabelZoomEnabled) {
        // 先把font设置为缩放的最大值，再缩小到最小值，最后根据当前的titleLabelZoomScale值，进行缩放更新。这样就能避免transform从小到大时字体模糊
        UIFont *maxScaleFont = [UIFont fontWithDescriptor:myCellModel.titleFont.fontDescriptor size:myCellModel.titleFont.pointSize * myCellModel.titleLabelSelectedZoomScale];
        CGFloat baseScale = myCellModel.titleFont.lineHeight / maxScaleFont.lineHeight;
        if (myCellModel.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:myCellModel]) {
            HDCategoryCellSelectedAnimationBlock block = [self preferredTitleZoomAnimationBlock:myCellModel baseScale:baseScale];
            [self addSelectedAnimationBlock:block];
        } else {
            self.titleLabel.font = maxScaleFont;
            self.maskTitleLabel.font = maxScaleFont;
            CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale * myCellModel.titleLabelCurrentZoomScale, baseScale * myCellModel.titleLabelCurrentZoomScale);
            self.titleLabel.transform = currentTransform;
            self.maskTitleLabel.transform = currentTransform;
        }
        // 自适应字体取消左右约束，titleLabel会比cell宽
        self.titleLabelLeft.active = NO;
        self.titleLabelRight.active = NO;
    } else {
        if (myCellModel.isSelected) {
            self.titleLabel.font = myCellModel.titleSelectedFont;
            self.maskTitleLabel.font = myCellModel.titleSelectedFont;
        } else {
            self.titleLabel.font = myCellModel.titleFont;
            self.maskTitleLabel.font = myCellModel.titleFont;
        }
        // 约束titleLabel宽度不超过cell宽度
        self.titleLabelLeft.active = YES;
        self.titleLabelRight.active = YES;
    }

    NSString *titleString = myCellModel.title ? myCellModel.title : @"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleString];
    if (myCellModel.isTitleLabelStrokeWidthEnabled) {
        if (myCellModel.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:myCellModel]) {
            HDCategoryCellSelectedAnimationBlock block = [self preferredTitleStrokeWidthAnimationBlock:myCellModel attributedString:attributedString];
            [self addSelectedAnimationBlock:block];
        } else {
            [attributedString addAttribute:NSStrokeWidthAttributeName value:@(myCellModel.titleLabelCurrentStrokeWidth) range:NSMakeRange(0, titleString.length)];
            self.titleLabel.attributedText = attributedString;
            self.maskTitleLabel.attributedText = attributedString;
        }
    } else {
        self.titleLabel.attributedText = attributedString;
        self.maskTitleLabel.attributedText = attributedString;
    }

    if (myCellModel.isTitleLabelMaskEnabled) {
        self.maskTitleLabel.hidden = NO;
        self.titleLabel.textColor = myCellModel.titleNormalColor;
        self.maskTitleLabel.textColor = myCellModel.titleSelectedColor;
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];

        CGRect topMaskframe = myCellModel.backgroundViewMaskFrame;
        // 将相对于cell的backgroundViewMaskFrame转换为相对于maskTitleLabel
        // 使用self.bounds.size.width而不是self.contentView.bounds.size.width。因为某些情况下，会出现self.bounds是正确的，而self.contentView.bounds还是重用前的状态。
        topMaskframe.origin.y = 0;
        CGRect bottomMaskFrame = topMaskframe;
        CGFloat maskStartX = 0;
        if (self.maskTitleLabel.bounds.size.width >= self.bounds.size.width) {
            topMaskframe.origin.x -= (self.maskTitleLabel.bounds.size.width - self.bounds.size.width) / 2;
            bottomMaskFrame.size.width = self.maskTitleLabel.bounds.size.width;
            maskStartX = -(self.maskTitleLabel.bounds.size.width - self.bounds.size.width) / 2;
        } else {
            bottomMaskFrame.size.width = self.bounds.size.width;
            topMaskframe.origin.x -= (self.bounds.size.width - self.maskTitleLabel.bounds.size.width) / 2;
            maskStartX = 0;
        }
        bottomMaskFrame.origin.x = topMaskframe.origin.x;
        if (topMaskframe.origin.x > maskStartX) {
            bottomMaskFrame.origin.x = topMaskframe.origin.x - bottomMaskFrame.size.width;
        } else {
            bottomMaskFrame.origin.x = CGRectGetMaxX(topMaskframe);
        }

        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (topMaskframe.size.width > 0 && CGRectIntersectsRect(topMaskframe, self.maskTitleLabel.frame)) {
            self.titleLabel.layer.mask = self.titleMaskLayer;
            self.maskTitleMaskLayer.frame = topMaskframe;
            self.titleMaskLayer.frame = bottomMaskFrame;
        } else {
            self.maskTitleMaskLayer.frame = topMaskframe;
            self.titleLabel.layer.mask = nil;
        }
        [CATransaction commit];
    } else {
        self.maskTitleLabel.hidden = YES;
        self.titleLabel.layer.mask = nil;
        if (myCellModel.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:myCellModel]) {
            HDCategoryCellSelectedAnimationBlock block = [self preferredTitleColorAnimationBlock:myCellModel];
            [self addSelectedAnimationBlock:block];
        } else {
            self.titleLabel.textColor = myCellModel.titleCurrentColor;
        }
    }

    [self startSelectedAnimationIfNeeded:myCellModel];
}

- (HDCategoryCellSelectedAnimationBlock)preferredTitleZoomAnimationBlock:(HDCategoryTitleCellModel *)cellModel baseScale:(CGFloat)baseScale {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat percent) {
        if (cellModel.isSelected) {
            //将要选中，scale从小到大插值渐变
            cellModel.titleLabelCurrentZoomScale = [HDCategoryFactory interpolationFrom:cellModel.titleLabelNormalZoomScale to:cellModel.titleLabelSelectedZoomScale percent:percent];
        } else {
            //将要取消选中，scale从大到小插值渐变
            cellModel.titleLabelCurrentZoomScale = [HDCategoryFactory interpolationFrom:cellModel.titleLabelSelectedZoomScale to:cellModel.titleLabelNormalZoomScale percent:percent];
        }
        CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale * cellModel.titleLabelCurrentZoomScale, baseScale * cellModel.titleLabelCurrentZoomScale);
        weakSelf.titleLabel.transform = currentTransform;
        weakSelf.maskTitleLabel.transform = currentTransform;
    };
}

- (HDCategoryCellSelectedAnimationBlock)preferredTitleStrokeWidthAnimationBlock:(HDCategoryTitleCellModel *)cellModel attributedString:(NSMutableAttributedString *)attributedString {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat percent) {
        if (cellModel.isSelected) {
            // 将要选中，StrokeWidth从小到大插值渐变
            cellModel.titleLabelCurrentStrokeWidth = [HDCategoryFactory interpolationFrom:cellModel.titleLabelNormalStrokeWidth to:cellModel.titleLabelSelectedStrokeWidth percent:percent];
        } else {
            // 将要取消选中，StrokeWidth从大到小插值渐变
            cellModel.titleLabelCurrentStrokeWidth = [HDCategoryFactory interpolationFrom:cellModel.titleLabelSelectedStrokeWidth to:cellModel.titleLabelNormalStrokeWidth percent:percent];
        }
        [attributedString addAttribute:NSStrokeWidthAttributeName value:@(cellModel.titleLabelCurrentStrokeWidth) range:NSMakeRange(0, attributedString.string.length)];
        weakSelf.titleLabel.attributedText = attributedString;
        weakSelf.maskTitleLabel.attributedText = attributedString;
    };
}

- (HDCategoryCellSelectedAnimationBlock)preferredTitleColorAnimationBlock:(HDCategoryTitleCellModel *)cellModel {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat percent) {
        if (cellModel.isSelected) {
            // 将要选中，textColor从titleNormalColor到titleSelectedColor插值渐变
            cellModel.titleCurrentColor = [HDCategoryFactory interpolationColorFrom:cellModel.titleNormalColor to:cellModel.titleSelectedColor percent:percent];
        } else {
            // 将要取消选中，textColor从titleSelectedColor到titleNormalColor插值渐变
            cellModel.titleCurrentColor = [HDCategoryFactory interpolationColorFrom:cellModel.titleSelectedColor to:cellModel.titleNormalColor percent:percent];
        }
        weakSelf.titleLabel.textColor = cellModel.titleCurrentColor;
    };
}

@end
