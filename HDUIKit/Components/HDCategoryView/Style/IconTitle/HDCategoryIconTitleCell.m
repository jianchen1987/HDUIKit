//
//  HDCategoryIconTitleCell.m
//  HDKitCore
//
//  Created by seeu on 2023/11/30.
//

#import "HDCategoryIconTitleCell.h"
#import "HDCategoryIconTitleCellModel.h"
#import <SDWebImage/SDWebImage.h>
#import <HDKitCore/HDKitCore.h>

@implementation HDCategoryIconTitleCell
- (void)initializeViews {
    [super initializeViews];

    self.iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView;
    });
    [self.contentView addSubview:self.iconImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
    HDCategoryIconTitleCellModel *myCellModel = (HDCategoryIconTitleCellModel *)self.cellModel;
    self.iconImageView.bounds = CGRectMake(0, 0, myCellModel.iconSize.width, myCellModel.iconSize.height);
    switch (myCellModel.relativePosition) {
        case HDCategoryIconRelativePositionTop: {
            self.iconImageView.center = CGPointMake(CGRectGetMidX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame) - myCellModel.offset - (myCellModel.iconSize.height / 2.0));
        } break;
        case HDCategoryIconRelativePositionLeft: {
            self.iconImageView.center = CGPointMake(CGRectGetMinX(self.titleLabel.frame) - myCellModel.offset - (myCellModel.iconSize.width / 2.0), CGRectGetMidY(self.titleLabel.frame));
        } break;
        case HDCategoryIconRelativePositionBottom: {
            self.iconImageView.center = CGPointMake(CGRectGetMidX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + myCellModel.offset + (myCellModel.iconSize.height / 2.0));
        } break;
        case HDCategoryIconRelativePositionRight: {
            self.iconImageView.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + myCellModel.offset + (myCellModel.iconSize.width / 2.0), CGRectGetMidY(self.titleLabel.frame));
        } break;
    }
//    [CATransaction commit];

}

- (void)reloadData:(HDCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    HDCategoryIconTitleCellModel *myCellModel = (HDCategoryIconTitleCellModel *)cellModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:myCellModel.iconUrl] placeholderImage:[HDHelper placeholderImageWithSize:myCellModel.iconSize]];
    self.iconImageView.layer.cornerRadius = myCellModel.iconCornerRadius;
    

    [self setNeedsLayout];
}
@end
