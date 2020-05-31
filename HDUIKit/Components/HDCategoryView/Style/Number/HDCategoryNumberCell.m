//
//  HDCategoryNumberCell.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryNumberCell.h"
#import "HDCategoryNumberCellModel.h"

@interface HDCategoryNumberCell ()

@end

@implementation HDCategoryNumberCell

- (void)initializeViews {
    [super initializeViews];

    self.numberLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label;
    });
    [self.contentView addSubview:self.numberLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.numberLabel sizeToFit];
    HDCategoryNumberCellModel *myCellModel = (HDCategoryNumberCellModel *)self.cellModel;
    self.numberLabel.bounds = CGRectMake(0, 0, self.numberLabel.bounds.size.width + myCellModel.numberLabelWidthIncrement, myCellModel.numberLabelHeight);
    self.numberLabel.layer.cornerRadius = myCellModel.numberLabelHeight / 2.0;

    self.numberLabel.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + myCellModel.numberLabelOffset.x, CGRectGetMinY(self.titleLabel.frame) + myCellModel.numberLabelOffset.y);
}

- (void)reloadData:(HDCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    HDCategoryNumberCellModel *myCellModel = (HDCategoryNumberCellModel *)cellModel;
    self.numberLabel.hidden = myCellModel.count == 0;
    self.numberLabel.backgroundColor = myCellModel.numberBackgroundColor;
    self.numberLabel.font = myCellModel.numberLabelFont;
    self.numberLabel.textColor = myCellModel.numberTitleColor;
    self.numberLabel.text = myCellModel.numberString;

    [self setNeedsLayout];
}

@end
