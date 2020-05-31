//
//  HDCategoryIndicatorCell.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorCell.h"
#import "HDCategoryIndicatorCellModel.h"

@interface HDCategoryIndicatorCell ()
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation HDCategoryIndicatorCell

- (void)initializeViews {
    [super initializeViews];

    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.hidden = YES;
    [self.contentView addSubview:self.separatorLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    HDCategoryIndicatorCellModel *model = (HDCategoryIndicatorCellModel *)self.cellModel;
    CGFloat lineWidth = model.separatorLineSize.width;
    CGFloat lineHeight = model.separatorLineSize.height;

    self.separatorLine.frame = CGRectMake(self.bounds.size.width - lineWidth + self.cellModel.cellSpacing / 2, (self.bounds.size.height - lineHeight) / 2.0, lineWidth, lineHeight);
}

- (void)reloadData:(HDCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    HDCategoryIndicatorCellModel *model = (HDCategoryIndicatorCellModel *)cellModel;
    self.separatorLine.backgroundColor = model.separatorLineColor;
    self.separatorLine.hidden = !model.isSepratorLineShowEnabled;

    if (model.isCellBackgroundColorGradientEnabled) {
        if (model.isSelected) {
            self.contentView.backgroundColor = model.cellBackgroundSelectedColor;
        } else {
            self.contentView.backgroundColor = model.cellBackgroundUnselectedColor;
        }
    }
}

@end
