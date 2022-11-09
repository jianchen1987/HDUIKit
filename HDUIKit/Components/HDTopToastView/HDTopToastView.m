//
//  HDTopToastView.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTopToastView.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"
#import "NSBundle+HDUIKit.h"
#import "UIView+HDKitCore.h"
#import "UIView+HD_Extension.h"
#import <HDKitCore/HDFrameLayout.h>
#import <HDKitCore/HDKitCore.h>

// 宽度
#define kHDTopToastViewWidth (kScreenWidth * 1)

@interface HDTopToastView ()
@property (nonatomic, copy) NSString *title;                 ///< 标题
@property (nonatomic, copy) NSString *message;               ///< 内容
@property (nonatomic, assign) HDTopToastType type;           ///< 类型
@property (nonatomic, strong) HDTopToastViewConfig *config;  ///< 配置

@property (nonatomic, strong) UIImage *iconImage;   ///< icon 图片
@property (nonatomic, strong) UILabel *titleLB;     ///< 标题
@property (nonatomic, strong) UILabel *messageLB;   ///< 内容
@property (nonatomic, strong) UIImageView *iconIV;  ///< icon
@end

@implementation HDTopToastView
#pragma mark - life cycle
+ (instancetype)toastViewWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message type:(HDTopToastType)type config:(HDTopToastViewConfig *__nullable)config {
    return [[self alloc] initWithTitle:title message:message type:type config:config];
}

- (instancetype)initWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message type:(HDTopToastType)type config:(HDTopToastViewConfig *__nullable)config {
    if (self = [super initWithAnimationStyle:HDActionAlertViewTransitionStyleSlideFromTop]) {
        config = config ?: [[HDTopToastViewConfig alloc] init];

        self.config = config;
        self.title = title;
        self.message = message;
        self.type = type;

        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.allowTapBackgroundDismiss = true;
        self.solidBackgroundColorAlpha = 0;
        self.ignoreBackgroundTouchEvent = true;
    }
    return self;
}

#pragma mark - override
- (void)layoutContainerView {

    CGFloat left = (kScreenWidth - [self containerViewWidth]) * 0.5;
    CGFloat containerHeight = UIEdgeInsetsGetVerticalValue(self.config.contentViewEdgeInsets);

    if (!self.titleLB.isHidden) {
        containerHeight += [self titleLBSize].height;
        if (!self.iconIV.hidden) {
            if (self.iconIVSize.height > self.titleLBSize.height) {
                // 上下对称
                containerHeight += (2 * (self.iconIVSize.height - self.titleLBSize.height));
            }
        }
    }

    if (!self.messageLB.isHidden) {
        if (!self.titleLB.isHidden) {
            containerHeight += self.config.marginTitle2Message;
        }
        containerHeight += [self messageLBSize].height;
        if (!self.iconIV.hidden && self.titleLB.isHidden) {
            if (self.iconIVSize.height > self.messageLBSize.height) {
                // 上下对称
                containerHeight += (2 * (self.iconIVSize.height - self.messageLBSize.height));
            }
        }
    }

    if (containerHeight < _config.containerMinHeight) {
        containerHeight = _config.containerMinHeight;
    }

    CGFloat top = self.config.containerViewEdgeInsets.top;
    self.containerView.frame = CGRectMake(left, top, [self containerViewWidth], containerHeight);
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = _config.containerCorner;
    self.containerView.backgroundColor = self.config.backgroundColor;

    // 上滑消失
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.containerView addGestureRecognizer:swipeGesture];
}

- (void)setupContainerSubViews {

    // 给containerview添加子视图
    [self.containerView addSubview:self.iconIV];
    self.iconIV.image = self.iconImage;
    self.iconIV.hidden = HDIsObjectNil(self.iconImage);

    [self.containerView addSubview:self.titleLB];
    self.titleLB.text = _title;
    self.titleLB.hidden = HDIsStringEmpty(_title);

    [self.containerView addSubview:self.messageLB];
    self.messageLB.text = _message;
    self.messageLB.hidden = HDIsStringEmpty(_message);
}

- (void)layoutContainerViewSubViews {

    if (!self.titleLB.isHidden) {
        [self.titleLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(self.titleLBSize);
            CGFloat top = self.config.contentViewEdgeInsets.top;
            if (!self.iconIV.hidden && self.iconIVSize.height > self.titleLBSize.height) {
                top += (self.iconIVSize.height - self.titleLBSize.height);
            }
            make.top.hd_equalTo(top);
            if (self.iconIV.hidden) {
                make.left.hd_equalTo(self.config.contentViewEdgeInsets.left);
            } else {
                CGFloat iconIVRight = self.config.contentViewEdgeInsets.left + self.config.iconWidth;
                make.left.hd_equalTo(iconIVRight).offset(self.config.marginTitleToIcon);
            }
        }];
    }

    if (!self.messageLB.isHidden) {
        [self.messageLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(self.messageLBSize);
            if (self.titleLB.isHidden) {
                CGFloat top = self.config.contentViewEdgeInsets.top;
                if (!self.iconIV.hidden && self.iconIVSize.height > self.messageLBSize.height) {
                    top += (self.iconIVSize.height - self.messageLBSize.height);
                }
                make.top.hd_equalTo(top);
            } else {
                make.top.hd_equalTo(self.titleLB.bottom).offset(self.config.marginTitle2Message);
            }
            if (self.iconIV.hidden) {
                make.left.hd_equalTo(self.config.contentViewEdgeInsets.left);
            } else {
                CGFloat iconIVRight = self.config.contentViewEdgeInsets.left + self.config.iconWidth;
                make.left.hd_equalTo(iconIVRight).offset(self.config.marginTitleToIcon);
            }
        }];
    }

    if (!self.iconIV.hidden) {
        [self.iconIV hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(self.iconIVSize);
            make.left.hd_equalTo(self.config.contentViewEdgeInsets.left);
            UIView *view = self.titleLB.isHidden ? self.messageLB : self.titleLB;
            if (view.isHidden) {
                make.top.hd_equalTo(self.config.contentViewEdgeInsets.top);
            } else {
                make.centerY.hd_equalTo(view.centerY);
            }
        }];
    }
}

#pragma mark - setter
- (void)setType:(HDTopToastType)type {
    _type = type;

    switch (type) {
        case HDTopToastTypeDefault: {
            self.iconImage = nil;
            self.config.backgroundColor = UIColor.grayColor;
            self.config.titleColor = UIColor.whiteColor;
            self.config.messageColor = UIColor.whiteColor;
            break;
        }
        case HDTopToastTypeSuccess: {
            self.config.backgroundColor = [UIColor hd_colorWithHexString:@"#22B573"];//[UIColor colorWithRed:248 / 255.0 green:52 / 255.0 blue:96 / 255.0 alpha:1.0];
            self.iconImage = [UIImage imageNamed:@"toast_success" inBundle:[NSBundle hd_UIKITTopToastResources] compatibleWithTraitCollection:nil];
            self.config.titleColor = UIColor.whiteColor;
            self.config.messageColor = UIColor.whiteColor;
            break;
        }
        case HDTopToastTypeError: {
            self.config.backgroundColor = [UIColor hd_colorWithHexString:@"#5d667f"];//[UIColor colorWithRed:93 / 255.0 green:102 / 255.0 blue:127 / 255.0 alpha:1.0];
            self.iconImage = [UIImage imageNamed:@"toast_error" inBundle:[NSBundle hd_UIKITTopToastResources] compatibleWithTraitCollection:nil];
            self.config.titleColor = UIColor.whiteColor;
            self.config.messageColor = UIColor.whiteColor;
            break;
        }
        case HDTopToastTypeWarning: {
            self.config.backgroundColor = [UIColor hd_colorWithHexString:@"#303030"];//[UIColor colorWithRed:252 / 255.0 green:203 / 255.0 blue:48 / 255.0 alpha:1.0];
            self.iconImage = [UIImage imageNamed:@"toast_warning" inBundle:[NSBundle hd_UIKITTopToastResources] compatibleWithTraitCollection:nil];
            self.config.titleColor = UIColor.whiteColor;
            self.config.messageColor = UIColor.whiteColor;
            break;
        }
        case HDTopToastTypeInfo: {
            self.config.backgroundColor = [UIColor hd_colorWithHexString:@"#5d667f"];//[UIColor colorWithRed:173 / 255.0 green:182 / 255.0 blue:200 / 255.0 alpha:1.0];
            self.iconImage = [UIImage imageNamed:@"toast_info" inBundle:[NSBundle hd_UIKITTopToastResources] compatibleWithTraitCollection:nil];
            self.config.titleColor = UIColor.whiteColor;
            self.config.messageColor = UIColor.whiteColor;
            break;
        }

        default:
            break;
    }
}

#pragma mark - override
- (void)show {
    [super show];

    NSTimeInterval hideAfterDuration = self.config.hideAfterDuration;

    NSMutableString *text = [NSMutableString string];
    if (!self.titleLB.isHidden && HDIsStringNotEmpty(self.title)) {
        [text appendString:self.title];
    }
    if (!self.messageLB.isHidden && HDIsStringNotEmpty(self.message)) {
        [text appendString:self.message];
    }

    if (hideAfterDuration == -1) {
        hideAfterDuration = [self smartDelaySecondsForTipsText:text];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideAfterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

#pragma mark - private methods
- (NSTimeInterval)smartDelaySecondsForTipsText:(NSString *)text {
    NSUInteger length = text.hd_lengthWhenCountingNonASCIICharacterAsTwo;
    if (length <= 20) {
        return 1.5;
    } else if (length <= 40) {
        return 2.0;
    } else if (length <= 50) {
        return 2.5;
    } else {
        return 3.0;
    }
}

- (CGFloat)containerViewWidth {
    return kHDTopToastViewWidth - UIEdgeInsetsGetHorizontalValue(self.config.containerViewEdgeInsets);
}

- (CGSize)iconIVSize {
    CGFloat scale = 1.0;
    if (self.iconImage) {
        scale = self.iconImage.size.height / self.iconImage.size.width;
    }
    return CGSizeMake(self.config.iconWidth, self.config.iconWidth * scale);
}

- (CGSize)titleLBSize {
    CGFloat maxTitleWidth = [self containerViewWidth] - UIEdgeInsetsGetHorizontalValue(self.config.contentViewEdgeInsets);
    if (self.type != HDTopToastTypeDefault) {
        maxTitleWidth -= (self.config.marginTitleToIcon + self.config.iconWidth);
    }
    return [self.titleLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
}

- (CGSize)messageLBSize {
    CGFloat maxTitleWidth = [self containerViewWidth] - UIEdgeInsetsGetHorizontalValue(self.config.contentViewEdgeInsets);
    if (self.type != HDTopToastTypeDefault) {
        maxTitleWidth -= (self.config.marginTitleToIcon + self.config.iconWidth);
    }
    return [self.messageLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
}

#pragma mark - lazy load
- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.numberOfLines = 0;
        _titleLB.textColor = _config.titleColor;
        _titleLB.font = _config.titleFont;
    }
    return _titleLB;
}

- (UILabel *)messageLB {
    if (!_messageLB) {
        _messageLB = [[UILabel alloc] init];
        _messageLB.textAlignment = NSTextAlignmentLeft;
        _messageLB.numberOfLines = 0;
        _messageLB.textColor = _config.messageColor;
        _messageLB.font = _config.messageFont;
    }
    return _messageLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        _iconIV = imageView;
    }
    return _iconIV;
}
@end
