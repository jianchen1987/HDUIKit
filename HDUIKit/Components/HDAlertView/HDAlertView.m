//
//  HDAlertView.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAlertView.h"
#import "HDAlertViewButton.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"
#import "UIView+HDFrameLayout.h"
#import "UIView+HDKitCore.h"
#import "UIView+HD_Extension.h"

// 宽度
#define kHDAlertViewWidth (kScreenWidth * 0.8)

@interface HDAlertView ()
@property (nonatomic, copy) NSString *title;              ///< 标题
@property (nonatomic, copy) NSString *message;            ///< 内容
@property (nonatomic, strong) HDAlertViewConfig *config;  ///< 配置
@property (nonatomic, strong) UIView *contentView;        ///< 自定义 View

@property (nonatomic, strong) UILabel *titleLB;                              ///< 标题
@property (nonatomic, strong) UILabel *messageLB;                            ///< 内容
@property (nonatomic, strong) NSMutableArray<HDAlertViewButton *> *buttons;  ///< 按钮
@end

@implementation HDAlertView
#pragma mark - life cycle
+ (instancetype)alertViewWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message config:(HDAlertViewConfig *__nullable)config {
    return [[self alloc] initWithTitle:title message:message config:config];
}

- (instancetype)initWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message config:(HDAlertViewConfig *__nullable)config {
    if (self = [super init]) {
        config = config ?: [[HDAlertViewConfig alloc] init];

        _title = title;
        _message = message;
        _config = config;

        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.allowTapBackgroundDismiss = false;
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *__nullable)title contentView:(UIView *)contentView config:(HDAlertViewConfig *__nullable)config {
    return [[self alloc] initWithTitle:title contentView:contentView config:config];
}

- (instancetype)initWithTitle:(NSString *__nullable)title contentView:(UIView *)contentView config:(HDAlertViewConfig *__nullable)config {
    if (self = [super init]) {
        config = config ?: [[HDAlertViewConfig alloc] init];

        _title = title;
        _config = config;
        _contentView = contentView;

        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromTop;
        self.allowTapBackgroundDismiss = true;
    }
    return self;
}

#pragma mark - override
- (void)layoutContainerView {

    if (_contentView) {  // 自定义上部
        CGFloat left = (kScreenWidth - [self containerViewWidth]) * 0.5;
        CGFloat containerHeight = _config.contentViewEdgeInsets.top + CGRectGetHeight(_contentView.frame) + _config.contentViewEdgeInsets.bottom;

        if (!self.titleLB.isHidden) {
            containerHeight += [self titleLBSize].height + _config.containerViewEdgeInsets.top;
        }

        if (self.buttons.count > 0) {
            containerHeight += [self buttonsSize].height + _config.containerViewEdgeInsets.bottom;
        }

        CGFloat top = (kScreenHeight - containerHeight) * 0.5;
        self.containerView.frame = CGRectMake(left, top, [self containerViewWidth], containerHeight);

        return;
    }
    CGFloat left = (kScreenWidth - [self containerViewWidth]) * 0.5;
    CGFloat containerHeight = _config.containerViewEdgeInsets.top + _config.containerViewEdgeInsets.bottom;
    if (!self.titleLB.isHidden) {
        containerHeight += [self titleLBSize].height;
    }

    if (!self.messageLB.isHidden) {
        containerHeight += [self messageLBSize].height + _config.marginTitle2Message;
    }

    if (self.buttons.count > 0) {
        containerHeight += [self buttonsSize].height + _config.marginMessageToButton;
    }

    if (containerHeight < _config.containerMinHeight) {
        containerHeight = _config.containerMinHeight;
    }

    CGFloat top = (kScreenHeight - containerHeight) * 0.5;
    self.containerView.frame = CGRectMake(left, top, [self containerViewWidth], containerHeight);
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = _config.containerCorner;
}

- (void)setupContainerSubViews {

    // 给containerview添加子视图
    [self.containerView addSubview:self.titleLB];
    self.titleLB.text = _title;
    self.titleLB.hidden = HDIsStringEmpty(_title);

    if (_contentView) {  // 自定义上部
        [self.containerView addSubview:self.contentView];

        for (HDAlertViewButton *button in self.buttons) {
            [self.containerView addSubview:button];
        }

        return;
    }

    [self.containerView addSubview:self.messageLB];
    self.messageLB.text = _message;
    self.messageLB.hidden = HDIsStringEmpty(_message);

    for (HDAlertViewButton *button in self.buttons) {
        [self.containerView addSubview:button];
    }
}

- (void)layoutContainerViewSubViews {

    // 计算按钮位置
    CGFloat buttonW_2 = (CGRectGetWidth(self.containerView.frame) - _config.containerViewEdgeInsets.left - _config.containerViewEdgeInsets.right - _config.buttonHMargin) * 0.5;
    CGFloat buttonY_1_2 = self.containerView.height - _config.containerViewEdgeInsets.bottom - [self buttonsSize].height;

    CGFloat buttonW_2_above = CGRectGetWidth(self.containerView.frame) - _config.containerViewEdgeInsets.left - _config.containerViewEdgeInsets.right;

    for (short i = 0; i < self.buttons.count; i++) {
        HDAlertViewButton *button = self.buttons[i];
        if (self.buttons.count == 1) {
            button.frame = (CGRect){_config.containerViewEdgeInsets.left, buttonY_1_2, [self buttonsSize]};
            [button setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:_config.buttonCorner];
        } else if (self.buttons.count == 2) {
            button.frame = CGRectMake(_config.containerViewEdgeInsets.left + (buttonW_2 + _config.buttonHMargin) * i, buttonY_1_2, buttonW_2, _config.buttonHeight);
            if (i == 0) {
                [button setRoundedCorners:UIRectCornerBottomLeft radius:_config.buttonCorner];
            } else if (i == 1) {
                [button setRoundedCorners:UIRectCornerBottomRight radius:_config.buttonCorner];
            }
        } else {
            button.frame = CGRectMake(_config.containerViewEdgeInsets.left, self.containerView.height - _config.containerViewEdgeInsets.bottom + _config.buttonVMargin - (_config.buttonHeight + _config.buttonVMargin) * (self.buttons.count - i), buttonW_2_above, _config.buttonHeight);
            if (i == self.buttons.count - 1) {
                [button setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:_config.buttonCorner];
            }
        }
    }

    if (_contentView) {  // 自定义上部

        if (!self.titleLB.isHidden) {
            self.titleLB.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self titleLBSize].width) * 0.5, _config.containerViewEdgeInsets.top, [self titleLBSize]};

            self.contentView.frame = CGRectMake(_config.contentViewEdgeInsets.left, CGRectGetMaxY(self.titleLB.frame) + _config.contentViewEdgeInsets.top, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
        } else {
            self.contentView.frame = CGRectMake(_config.contentViewEdgeInsets.left, _config.contentViewEdgeInsets.top, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
        }

        return;
    }

    if (self.titleLB.isHidden) {
        // 计算内容位置
        if (!self.messageLB.isHidden) {

            if (self.buttons.count > 0) {
                HDAlertViewButton *topButton = self.buttons[0];
                self.messageLB.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self messageLBSize].width) * 0.5, (CGRectGetMinY(topButton.frame) - [self messageLBSize].height) * 0.5, [self messageLBSize]};
            } else {
                self.messageLB.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self messageLBSize].width) * 0.5, (CGRectGetHeight(self.containerView.frame) - [self messageLBSize].height) * 0.5, [self messageLBSize]};
            }
        }
    } else {

        if (!self.messageLB.isHidden) {
            if (self.buttons.count > 0) {
                HDAlertViewButton *topButton = self.buttons[0];
                self.titleLB.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self titleLBSize].width) * 0.5, (CGRectGetMinY(topButton.frame) - [self titleLBSize].height - [self messageLBSize].height - _config.marginTitle2Message) * 0.5, [self titleLBSize]};
            } else {
                self.titleLB.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self titleLBSize].width) * 0.5, (CGRectGetHeight(self.containerView.frame) - [self titleLBSize].height - [self messageLBSize].height - _config.marginTitle2Message) * 0.5, [self titleLBSize]};
            }

            self.messageLB.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self messageLBSize].width) * 0.5, CGRectGetMaxY(self.titleLB.frame) + _config.marginTitle2Message, [self messageLBSize]};

        } else {
            if (self.buttons.count > 0) {
                HDAlertViewButton *topButton = self.buttons[0];
                self.titleLB.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self titleLBSize].width) * 0.5, (CGRectGetMinY(topButton.frame) - [self titleLBSize].height) * 0.5, [self titleLBSize]};
            } else {
                self.titleLB.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self titleLBSize].width) * 0.5, (CGRectGetHeight(self.containerView.frame) - [self titleLBSize].height) * 0.5, [self titleLBSize]};
            }
        }
    }
}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    if (_contentView) {
        return _config.contentViewEdgeInsets.left + _config.contentViewEdgeInsets.right + _contentView.frame.size.width;
    } else {
        return kHDAlertViewWidth;
    }
}

- (CGSize)titleLBSize {
    const CGFloat maxTitleWidth = [self containerViewWidth] - 2 * _config.labelHEdgeMargin;
    return [self.titleLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
}

- (CGSize)messageLBSize {
    const CGFloat maxTitleWidth = [self containerViewWidth] - 2 * _config.labelHEdgeMargin;
    return [self.messageLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
}

- (CGSize)buttonsSize {
    const CGFloat buttonsWidth = [self containerViewWidth] - _config.containerViewEdgeInsets.left - _config.containerViewEdgeInsets.right;

    if (self.buttons.count <= 0) {
        return CGSizeZero;
    } else if (self.buttons.count <= 2) {
        return CGSizeMake(buttonsWidth, _config.buttonHeight);
    } else {  // 三个及以上，垂直排列
        return CGSizeMake(buttonsWidth, _config.buttonHeight * self.buttons.count + (self.buttons.count - 1) * _config.buttonVMargin);
    }
}

#pragma mark - public methods
- (void)addButton:(HDAlertViewButton *)button {
    [self.buttons addObject:button];
    button.alertView = self;

    [self invalidateLayout];
}

- (void)addButtons:(NSArray<HDAlertViewButton *> *)buttons {
    [self.buttons addObjectsFromArray:buttons];
    for (HDAlertViewButton *button in buttons) {
        button.alertView = self;
    }

    [self invalidateLayout];
}

#pragma mark - lazy load
- (NSMutableArray<HDAlertViewButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.numberOfLines = 0;
        _titleLB.textColor = _config.titleColor;
        _titleLB.font = _config.titleFont;
    }
    return _titleLB;
}

- (UILabel *)messageLB {
    if (!_messageLB) {
        _messageLB = [[UILabel alloc] init];
        _messageLB.textAlignment = NSTextAlignmentCenter;
        _messageLB.numberOfLines = 0;
        _messageLB.textColor = _config.messageColor;
        _messageLB.font = _config.messageFont;
    }
    return _messageLB;
}
@end
