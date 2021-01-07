//
//  HDSocialShareCell.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSocialShareCell.h"
#import "HDAppTheme.h"
#import "HDSocialShareCellModel.h"
#import "Masonry.h"
#import <HDKitCore/HDCommonDefines.h>

@interface HDSocialShareCell ()
@property (nonatomic, strong) UIView *containerView;  ///< 容器，控制整体垂直居中
@property (nonatomic, strong) UIImageView *logoIV;    ///< logo
@property (nonatomic, strong) UILabel *titleLB;       ///< 标题
@end

@implementation HDSocialShareCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
}

#pragma mark - life cycle
- (void)commonInit {

    self.contentView.backgroundColor = UIColor.clearColor;

    _containerView = [[UIView alloc] init];
    [self.contentView addSubview:_containerView];

    _logoIV = [[UIImageView alloc] init];
    [self.contentView addSubview:_logoIV];

    _titleLB = [[UILabel alloc] init];
    _titleLB.font = HDAppTheme.font.standard4;
    _titleLB.adjustsFontSizeToFitWidth = true;
    _titleLB.minimumScaleFactor = 0.7;
    _titleLB.textColor = HDAppTheme.color.G2;
    _titleLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLB];
}

- (void)updateConstraints {

    [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.width.equalTo(self.contentView);
        make.top.equalTo(self.logoIV);
        make.bottom.equalTo(self.titleLB);
    }];

    [_logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView).multipliedBy(50.f / 110.f);
        make.height.equalTo(self.logoIV.mas_width);
        make.centerX.equalTo(self.contentView);
    }];

    [_titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(9));
        make.centerX.width.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - getters and setters
- (void)setModel:(HDSocialShareCellModel *)model {
    _model = model;

    _logoIV.image = model.image;
    _titleLB.text = model.title;

    [self setNeedsUpdateConstraints];
}

@end
