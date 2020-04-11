//
//  HDImageUploadAddImageView.m
//  HDUIKit
//
//  Created by VanJay on 2020/2/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDImageUploadAddImageView.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIView+HDKitCore.h>
#import <HDUIKit/HDAppTheme.h>
#import <Masonry/Masonry.h>

@interface HDImageUploadAddImageView ()
@property (nonatomic, strong) UIView *containerView;         ///< 容器
@property (nonatomic, strong) UIImageView *cameraImageView;  ///< 相机图片
@property (nonatomic, strong) UILabel *descLabel;            ///< 描述
@end

@implementation HDImageUploadAddImageView

#pragma mark - life cycle
- (void)commonInit {

    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat pieceWidth = 5;
    if (width > 46) {
        // 奇数份
        pieceWidth = (CGFloat)width / 23.0;
    }
    self.hd_dashPattern = @[@(pieceWidth), @(pieceWidth)];
    self.hd_borderColor = HDAppTheme.color.G4;
    self.hd_borderWidth = 1;
    self.hd_borderPosition = HDViewBorderPositionTop | HDViewBorderPositionLeft | HDViewBorderPositionBottom | HDViewBorderPositionRight;

    self.backgroundColor = HDAppTheme.color.G5;

    [self addSubview:self.containerView];
    [self.containerView addSubview:self.cameraImageView];
    [self.containerView addSubview:self.descLabel];
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

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraImageView);
        make.bottom.equalTo(self.descLabel);
        make.center.width.equalTo(self);
    }];

    [self.cameraImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];

    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-2 * kRealWidth(10));
        make.centerX.equalTo(self);
        make.top.equalTo(self.cameraImageView.mas_bottom).offset(kRealWidth(5));
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)containerView {
    return _containerView ?: ({ _containerView = UIView.new; });
}

- (UIImageView *)cameraImageView {
    if (!_cameraImageView) {
        _cameraImageView = [[UIImageView alloc] init];
    }
    return _cameraImageView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = UILabel.new;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = HDAppTheme.color.G2;
        _descLabel.font = HDAppTheme.font.standard4;
        _descLabel.text = @"上传图片";
    }
    return _descLabel;
}
@end
