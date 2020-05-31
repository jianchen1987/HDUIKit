//
//  HDCategoryDotCell.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryDotCell.h"
#import "HDCategoryDotCellModel.h"

@interface HDCategoryDotCell ()
@property (nonatomic, strong) CALayer *dotLayer;
@end

@implementation HDCategoryDotCell

- (void)initializeViews {
    [super initializeViews];

    _dotLayer = [CALayer layer];
    [self.contentView.layer addSublayer:self.dotLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    HDCategoryDotCellModel *myCellModel = (HDCategoryDotCellModel *)self.cellModel;
    self.dotLayer.bounds = CGRectMake(0, 0, myCellModel.dotSize.width, myCellModel.dotSize.height);
    switch (myCellModel.relativePosition) {
        case HDCategoryDotRelativePosition_TopLeft: {
            self.dotLayer.position = CGPointMake(CGRectGetMinX(self.titleLabel.frame) + myCellModel.dotOffset.x, CGRectGetMinY(self.titleLabel.frame) + myCellModel.dotOffset.y);
        } break;
        case HDCategoryDotRelativePosition_TopRight: {
            self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + myCellModel.dotOffset.x, CGRectGetMinY(self.titleLabel.frame) + myCellModel.dotOffset.y);
        } break;
        case HDCategoryDotRelativePosition_BottomLeft: {
            self.dotLayer.position = CGPointMake(CGRectGetMinX(self.titleLabel.frame) + myCellModel.dotOffset.x, CGRectGetMaxY(self.titleLabel.frame) + myCellModel.dotOffset.y);
        } break;
        case HDCategoryDotRelativePosition_BottomRight: {
            self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + myCellModel.dotOffset.x, CGRectGetMaxY(self.titleLabel.frame) + myCellModel.dotOffset.y);
        } break;
    }
    [CATransaction commit];
}

- (void)reloadData:(HDCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    HDCategoryDotCellModel *myCellModel = (HDCategoryDotCellModel *)cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.dotLayer.hidden = !myCellModel.dotHidden;
    self.dotLayer.backgroundColor = myCellModel.dotColor.CGColor;
    self.dotLayer.cornerRadius = myCellModel.dotCornerRadius;
    [CATransaction commit];

    [self setNeedsLayout];
}

@end
