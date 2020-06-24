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
#import <HDKitCore/UIImage+HDKitCore.h>
#import <HDKitCore/UIView+HD_Extension.h>
#import <HDUIKit/HDAppTheme.h>

// 宽度
#define kHDCustomViewActionViewWidth (kScreenWidth * 1)

static CGFloat const kCloseButtonW = 30.0;
static CGFloat const kCloseButtonEdgeMargin = 10.0;

@interface HDCustomViewActionView ()
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;  ///< iPhoneX 系列底部填充
@property (nonatomic, strong) UILabel *titleLabel;                     ///< 标题
@property (nonatomic, strong) UIButton *button;                        ///< 按钮
@property (nonatomic, strong) UIView *contentView;                     ///< 自定义 View
@property (nonatomic, strong) HDCustomViewActionViewConfig *config;    ///< 配置
@property (nonatomic, strong) UIScrollView *scrollView;                ///< 滚动容器
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

    if (self.config.style == HDCustomViewActionViewStyleCancel) {
        containerHeight += self.config.buttonHeight;
    }

    if (!self.titleLabel.isHidden) {
        containerHeight += (self.titleLBSize.height + self.config.marginTitleToContentView);
    } else {
        if (self.config.style == HDCustomViewActionViewStyleClose) {
            containerHeight += (kCloseButtonW + self.config.marginTitleToContentView);
        }
    }

    if (self.config.style == HDCustomViewActionViewStyleCancel) {
        containerHeight += kiPhoneXSeriesSafeBottomHeight;
    }

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
        if (self.config.shouldAddScrollViewContainer) {
            [self.containerView addSubview:self.scrollView];
            [self.scrollView addSubview:self.contentView];
        } else {
            [self.containerView addSubview:self.contentView];
        }
    }
    if (self.config.style == HDCustomViewActionViewStyleCancel && iPhoneXSeries) {
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
        if (self.config.style == HDCustomViewActionViewStyleCancel) {
            [self.button hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.left.hd_equalTo(0);
                make.width.hd_equalTo(self.containerView.width);
                make.height.hd_equalTo(self.config.buttonHeight);
                make.bottom.hd_equalTo(self.containerView.height);
            }];
        }
    }

    if (!self.titleLabel.isHidden) {
        [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.left.hd_equalTo(self.config.containerViewEdgeInsets.left);
            make.top.hd_equalTo(self.config.containerViewEdgeInsets.top);
            make.size.hd_equalTo(self.titleLBSize);
        }];
    }

    if (self.config.style == HDCustomViewActionViewStyleClose) {
        [self.button hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(CGSizeMake(kCloseButtonW, kCloseButtonW));
            make.right.hd_equalTo(self.containerView.width - kCloseButtonEdgeMargin);
            if (!self.titleLabel.isHidden) {
                make.centerY.hd_equalTo(self.titleLabel.centerY);
            } else {
                make.top.hd_equalTo(self.config.containerViewEdgeInsets.top);
            }
        }];
    }

    UIView *outerView;
    if (!self.config.shouldAddScrollViewContainer) {
        outerView = self.contentView;
    } else {
        outerView = self.scrollView;
    }
    [outerView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(self.config.contentHorizontalEdgeMargin);
        if (!self.titleLabel.isHidden) {
            make.top.hd_equalTo(self.titleLabel.bottom).offset(self.config.marginTitleToContentView);
        } else {
            if (self.config.style == HDCustomViewActionViewStyleClose) {
                make.top.hd_equalTo(self.button.bottom).offset(self.config.marginTitleToContentView);
            } else {
                make.top.hd_equalTo(self.config.containerViewEdgeInsets.top);
            }
        }
        // 计算剩余高度
        CGFloat leftHeight;
        if (self.config.style == HDCustomViewActionViewStyleCancel) {
            leftHeight = CGRectGetMinY(self.button.frame) - UIEdgeInsetsGetVerticalValue(self.config.containerViewEdgeInsets);
        } else {
            leftHeight = self.containerView.height - UIEdgeInsetsGetVerticalValue(self.config.containerViewEdgeInsets);
        }

        if (!self.titleLabel.isHidden) {
            leftHeight -= (CGRectGetHeight(self.titleLabel.frame) + self.config.marginTitleToContentView);
        }
        if (self.contentView.size.height <= leftHeight) {
            make.size.hd_equalTo(self.contentView.size);
        } else {
            make.width.hd_equalTo(self.contentView.size.width);
            make.height.hd_equalTo(leftHeight);

            if (outerView == self.contentView && self.config.shouldAddScrollViewContainer) {
                UIScrollView *contentView = (UIScrollView *)self.contentView;
                contentView.contentSize = CGSizeMake(self.contentView.size.width, self.contentView.height);
            }
        }
    }];

    if (outerView == self.scrollView) {
        [self.contentView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.left.hd_equalTo(0);
            make.width.hd_equalTo(self.scrollView.width);
            make.top.hd_equalTo(0);
            make.height.hd_equalTo(self.contentView.height);
        }];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.contentView.height);
    }
}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    if (_contentView) {
        return _config.contentHorizontalEdgeMargin * 2 + _contentView.frame.size.width;
    } else {
        return kHDCustomViewActionViewWidth;
    }
}

- (CGSize)titleLBSize {
    CGFloat maxTitleWidth = self.containerViewWidth - (_config.containerViewEdgeInsets.left + _config.containerViewEdgeInsets.right);

    if (self.config.style == HDCustomViewActionViewStyleClose) {
        maxTitleWidth = maxTitleWidth - (kCloseButtonW + kCloseButtonEdgeMargin);
    }

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
        _iphoneXSeriousSafeAreaFillView.backgroundColor = HDAppTheme.color.normalBackground;
    }
    return _iphoneXSeriousSafeAreaFillView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];

        if (self.config.style == HDCustomViewActionViewStyleCancel) {
            [_button setTitle:self.config.buttonTitle forState:UIControlStateNormal];
            [_button setTitleColor:self.config.buttonTitleColor forState:UIControlStateNormal];
            _button.backgroundColor = self.config.buttonBgColor;
            _button.titleLabel.font = self.config.buttonTitleFont;
        } else if (self.config.style == HDCustomViewActionViewStyleClose) {
            UIImage *image = [UIImage hd_imageWithShape:HDUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:HDAppTheme.color.G3];
            [_button setImage:image forState:UIControlStateNormal];
        }
        [_button addTarget:self action:@selector(clickedButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.bounces = self.config.scrollViewBounces;
    }
    return _scrollView;
}
@end
