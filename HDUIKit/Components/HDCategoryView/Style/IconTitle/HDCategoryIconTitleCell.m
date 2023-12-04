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

@interface HDCategoryIconTitleCell ()

@property (nonatomic, strong) NSLayoutConstraint *titleLabelTop;
@property (nonatomic, strong) NSLayoutConstraint *iconImageViewCenterX;
@property (nonatomic, strong) NSLayoutConstraint *iconImageViewTop;

@end

@implementation HDCategoryIconTitleCell

- (void)initializeViews {
    [super initializeViews];

    self.iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView;
    });
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLabelCenterY.active = NO;
    self.titleLabelTop = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.iconImageView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:2];
    self.titleLabelTop.active = YES;
    
    HDCategoryIconTitleCellModel *myCellModel = (HDCategoryIconTitleCellModel *)self.cellModel;
    self.iconImageView.bounds = CGRectMake(0, 0, myCellModel.iconSize.width, myCellModel.iconSize.height);
    
    self.iconImageViewCenterX = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    self.iconImageViewCenterX.active = YES;
    
    self.iconImageViewTop = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8];
    self.iconImageViewTop.active = YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)reloadData:(HDCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    HDCategoryIconTitleCellModel *myCellModel = (HDCategoryIconTitleCellModel *)cellModel;
    if([myCellModel.iconUrl isKindOfClass:NSString.class] && myCellModel.iconUrl.length > 0 ) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:myCellModel.iconUrl]
                              placeholderImage:[HDHelper placeholderImageWithSize:myCellModel.iconSize logoWidth:myCellModel.iconSize.height / 2.0]];
        
        self.iconImageView.layer.cornerRadius = myCellModel.iconCornerRadius;
        
        self.iconImageViewTop = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8];
        self.iconImageViewTop.active = YES;
        
    } else {
        self.titleLabelTop = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:8];
        self.titleLabelTop.active = YES;
    }
    

    [self setNeedsLayout];
}
@end
