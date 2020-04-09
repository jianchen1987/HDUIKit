//
//  HDCustomViewActionView.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCustomViewActionView.h"
#import "HDFrameLayout.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIView+HD_Extension.h>

// 宽度
#define kHDCustomViewActionViewWidth (kScreenWidth * 1)

@interface HDCustomViewActionView ()
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;  ///< iPhoneX 系列底部填充
@property (nonatomic, strong) UILabel *titleLabel;                     ///< 标题
@property (nonatomic, strong) UIButton *button;                        ///< 按钮
@property (nonatomic, strong) UIView *contentView;                     ///< 自定义 View
@property (nonatomic, strong) HDCustomViewActionViewConfig *config;    ///< 配置
@end

@implementation HDCustomViewActionView

+ (instancetype)actionViewWithContentView:(UIView<HDCustomViewActionViewProtocol> *)contentView config:(HDCustomViewActionViewConfig *__nullable)config {
    return [[self alloc] initWithContentView:contentView config:config];
}

- (instancetype)initWithContentView:(UIView<HDCustomViewActionViewProtocol> *)contentView config:(HDCustomViewActionViewConfig *__nullable)config {
    if (self = [super init]) {
        config = config ?: [[HDCustomViewActionViewConfig alloc] init];

        _config = config;
        _contentView = contentView;

        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.allowTapBackgroundDismiss = true;
    }
    return self;
}

#pragma mark - override
- (void)layoutContainerView {

    CGFloat left = 0;
    CGFloat containerHeight = self.config.containerViewEdgeInsets.top + self.config.containerViewEdgeInsets.bottom;

    if (self.contentView) {
        containerHeight += CGRectGetHeight(self.contentView.frame);
    }

    containerHeight += self.config.buttonHeight;

    if (!self.titleLabel.isHidden) {
        containerHeight += (self.titleLBSize.height + self.config.marginTitleToContentView);
    }

    containerHeight += kiPhoneXSeriesSafeBottomHeight;

    if (containerHeight < _config.containerMinHeight) {
        containerHeight = _config.containerMinHeight;
    }

    if (containerHeight > _config.containerMaxHeight) {
        containerHeight = _config.containerMaxHeight;
    }

    CGFloat top = kScreenHeight - containerHeight;
    self.containerView.frame = CGRectMake(left, top, self.containerViewWidth, containerHeight);

    if (!CGSizeEqualToSize(self.containerView.frame.size, CGSizeZero)) {
        [self.containerView setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:_config.containerCorner];
    }
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
}

- (void)setupContainerSubViews {

    // 给containerview添加子视图
    [self.containerView addSubview:self.titleLabel];
    self.titleLabel.hidden = HDIsStringEmpty(_config.title);
    if (!self.titleLabel.isHidden) {
        self.titleLabel.text = _config.title;
    }

    [self.containerView addSubview:self.button];

    if (self.contentView) {  // 自定义上部
        [self.containerView addSubview:self.contentView];
    }
    if (iPhoneXSeries) {
        [self.containerView addSubview:self.iphoneXSeriousSafeAreaFillView];
    }
}

- (void)layoutContainerViewSubViews {

    if (_iphoneXSeriousSafeAreaFillView) {
        self.iphoneXSeriousSafeAreaFillView.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame) - kiPhoneXSeriesSafeBottomHeight, self.containerViewWidth, kiPhoneXSeriesSafeBottomHeight);

        [self.button hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.left.hd_equalTo(0);
            make.width.hd_equalTo(self.containerView.width);
            make.height.hd_equalTo(self.config.buttonHeight);
            make.bottom.hd_equalTo(self.iphoneXSeriousSafeAreaFillView.top);
        }];
    } else {
        [self.button hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.left.hd_equalTo(0);
            make.width.hd_equalTo(self.containerView.width);
            make.height.hd_equalTo(self.config.buttonHeight);
            make.bottom.hd_equalTo(self.containerView.height);
        }];
    }

    if (!self.titleLabel.isHidden) {
        [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.left.hd_equalTo(self.config.containerViewEdgeInsets.left);
            make.top.hd_equalTo(self.config.containerViewEdgeInsets.top);
            make.size.hd_equalTo(self.titleLBSize);
        }];
    }

    [self.contentView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(self.config.containerViewEdgeInsets.left);
        if (!self.titleLabel.isHidden) {
            make.top.hd_equalTo(self.titleLabel.bottom).offset(self.config.marginTitleToContentView);
        } else {
            make.top.hd_equalTo(self.config.containerViewEdgeInsets.top);
        }
        // 计算剩余高度
        CGFloat leftHeight = CGRectGetMinY(self.button.frame) - self.config.containerViewEdgeInsets.top - self.config.containerViewEdgeInsets.bottom;
        if (!self.titleLabel.isHidden) {
            leftHeight -= (CGRectGetHeight(self.titleLabel.frame) + self.config.marginTitleToContentView);
        }
        if (self.contentView.size.height <= leftHeight) {
            make.size.hd_equalTo(self.contentView.size);
        } else {
            make.width.hd_equalTo(self.contentView.size.width);
            make.height.hd_equalTo(leftHeight);
        }
    }];
}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    if (_contentView) {
        return _config.containerViewEdgeInsets.left + _config.containerViewEdgeInsets.right + _contentView.frame.size.width;
    } else {
        return kHDCustomViewActionViewWidth;
    }
}

- (CGSize)titleLBSize {
    const CGFloat maxTitleWidth = self.containerViewWidth - (_config.containerViewEdgeInsets.left + _config.containerViewEdgeInsets.right);
    return [self.titleLabel sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
}

#pragma mark - event response
- (void)clickedButtonHandler {
    [self dismiss];
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = _config.titleFont;
        _titleLabel.textColor = _config.titleColor;
    }
    return _titleLabel;
}

- (UIView *)iphoneXSeriousSafeAreaFillView {
    if (!_iphoneXSeriousSafeAreaFillView) {
        _iphoneXSeriousSafeAreaFillView = [[UIView alloc] init];
        _iphoneXSeriousSafeAreaFillView.backgroundColor = HexColor(0xF5F7FA);
    }
    return _iphoneXSeriousSafeAreaFillView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:self.config.buttonTitle forState:UIControlStateNormal];
        [_button setTitleColor:self.config.buttonTitleColor forState:UIControlStateNormal];
        _button.backgroundColor = self.config.buttonBgColor;
        _button.titleLabel.font = self.config.buttonTitleFont;
        [_button addTarget:self action:@selector(clickedButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end
