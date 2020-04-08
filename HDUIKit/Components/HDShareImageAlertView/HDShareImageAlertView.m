//
//  HDShareImageAlertView.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDShareImageAlertView.h"
#import "HDAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIView+HD_Extension.h>

#define KAlertViewWidth kScreenWidth

@implementation HDShareImageAlertViewConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleFont = HDAppTheme.font.standard2Bold;
        self.titleColor = HDAppTheme.color.G1;
        self.subTitleFont = HDAppTheme.font.standard3;
        self.subTitleColor = HDAppTheme.color.G2;
        self.tipLBFont = HDAppTheme.font.standard3;
        self.tipLBColor = HDAppTheme.color.G2;
        self.contentViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), kRealWidth(15), kRealWidth(15));
        self.marginTitleToSubTitle = kRealWidth(10);
        self.marginSubTitleToImage = kRealWidth(20);
        self.marginImageToTip = kRealWidth(20);
        self.cancelTitleFont = HDAppTheme.font.standard2Bold;
        self.cancelTitleColor = HDAppTheme.color.G1;
        self.cancelButtonBackgroundColor = HexColor(0xF5F7FA);
        self.buttonHeight = kRealWidth(45);
        self.containerCorner = 10;
    }
    return self;
}
@end

@interface HDShareImageAlertView ()
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;  ///< iPhoneX 系列底部填充
@property (nonatomic, strong) UIImageView *imageV;                     ///< 图片
@property (nonatomic, strong) UILabel *titleLB;                        ///< 标题
@property (nonatomic, strong) UILabel *subTitleLB;                     ///< 子标题
@property (nonatomic, strong) UILabel *tipLB;                          ///< 提示
@property (nonatomic, strong) UIButton *cancelButton;                  ///< 取消按钮

@property (nonatomic, strong) HDShareImageAlertViewConfig *config;  ///< 配置
@property (nonatomic, strong) UIImage *image;                       ///< 图片
@property (nonatomic, copy) NSString *title;                        ///< 标题
@property (nonatomic, copy) NSString *subTitle;                     ///< 子标题
@property (nonatomic, copy) NSString *tipStr;                       ///< 提示标题
@property (nonatomic, copy) NSString *cancelTitle;                  ///< 取消标题
@end

@implementation HDShareImageAlertView

+ (instancetype)alertViewWithTitle:(NSString *)title subTitle:(NSString *__nullable)subTitle tipStr:(NSString *__nullable)tipStr cancelTitle:(NSString *__nullable)cancelTitle image:(UIImage *)image config:(HDShareImageAlertViewConfig *__nullable)config {
    return [[self alloc] initWithWithTitle:title subTitle:subTitle tipStr:tipStr cancelTitle:cancelTitle image:image config:config];
}

- (instancetype)initWithWithTitle:(NSString *)title subTitle:(NSString *__nullable)subTitle tipStr:(NSString *__nullable)tipStr cancelTitle:(NSString *__nullable)cancelTitle image:(UIImage *)image config:(HDShareImageAlertViewConfig *__nullable)config {
    if (self = [super init]) {

        config = config ?: [[HDShareImageAlertViewConfig alloc] init];

        _config = config;
        _title = title;
        _subTitle = subTitle;
        _tipStr = tipStr;
        _image = image;
        _cancelTitle = cancelTitle;

        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.allowTapBackgroundDismiss = true;
    }
    return self;
}

/** 布局containerview的位置,就是那个看得到的视图 */
- (void)layoutContainerView {

    CGFloat left = 0;
    CGFloat containerHeight = 0;

    if (HDIsStringNotEmpty(_title)) {
        containerHeight += self.config.contentViewEdgeInsets.top;
        containerHeight += [self titleLBSize].height;
    }

    if (HDIsStringNotEmpty(_cancelTitle)) {
        containerHeight += [self cancelButtonSize].height;
    }

    if (HDIsStringNotEmpty(_subTitle)) {
        containerHeight += ([self subTitleLBSize].height + self.config.marginTitleToSubTitle);
    }

    containerHeight += ([self imageViewSize].height + self.config.marginSubTitleToImage);

    if (HDIsStringNotEmpty(_tipStr)) {
        containerHeight += ([self tipLBSize].height + self.config.marginImageToTip);
        containerHeight += self.config.contentViewEdgeInsets.bottom;
    }

    containerHeight += kiPhoneXSeriesSafeBottomHeight;

    CGFloat top = kScreenHeight - containerHeight;
    self.containerView.frame = CGRectMake(left, top, KAlertViewWidth, containerHeight);

    if (!CGSizeEqualToSize(self.containerView.frame.size, CGSizeZero)) {
        [self.containerView setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:self.config.containerCorner];
    }
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
}

/** 给containerview添加子视图 */
- (void)setupContainerSubViews {

    if (HDIsStringNotEmpty(_title)) {
        [self.containerView addSubview:self.titleLB];
    }

    if (HDIsStringNotEmpty(_subTitle)) {
        [self.containerView addSubview:self.subTitleLB];
    }

    [self.containerView addSubview:self.imageV];

    if (HDIsStringNotEmpty(_tipStr)) {
        [self.containerView addSubview:self.tipLB];
    }

    if (HDIsStringNotEmpty(_cancelTitle)) {
        [self.containerView addSubview:self.cancelButton];
    }

    if (iPhoneXSeries) {
        [self.containerView addSubview:self.iphoneXSeriousSafeAreaFillView];
    }
}

/** 设置子视图的frame */
- (void)layoutContainerViewSubViews {
    const CGFloat containerViewWidth = CGRectGetWidth(self.containerView.frame);

    if (_titleLB) {
        const CGSize titleLBSize = [self titleLBSize];
        const CGFloat titleLBX = (containerViewWidth - titleLBSize.width) * 0.5;
        self.titleLB.frame = (CGRect){titleLBX, self.config.contentViewEdgeInsets.top, titleLBSize};
    }

    if (_subTitleLB) {
        const CGSize subTitleLBSize = [self subTitleLBSize];
        const CGFloat subTitleLBX = (containerViewWidth - subTitleLBSize.width) * 0.5;
        self.subTitleLB.frame = (CGRect){subTitleLBX, CGRectGetMaxY(self.titleLB.frame) + self.config.marginTitleToSubTitle, subTitleLBSize};
    }

    const CGSize imageViewSize = [self imageViewSize];
    const CGFloat imageViewX = (containerViewWidth - imageViewSize.width) * 0.5;
    const CGFloat imageViewYRef = _subTitleLB ? CGRectGetMaxY(self.subTitleLB.frame) : CGRectGetMaxY(self.tipLB.frame);
    self.imageV.frame = (CGRect){imageViewX, imageViewYRef + self.config.marginSubTitleToImage, imageViewSize};

    if (_tipLB) {
        const CGSize tipLBSize = [self tipLBSize];
        const CGFloat tipLBX = (containerViewWidth - tipLBSize.width) * 0.5;
        self.tipLB.frame = (CGRect){tipLBX, CGRectGetMaxY(self.imageV.frame) + self.config.marginImageToTip, tipLBSize};
    }

    if (_iphoneXSeriousSafeAreaFillView) {
        self.iphoneXSeriousSafeAreaFillView.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame) - kiPhoneXSeriesSafeBottomHeight, CGRectGetWidth(self.containerView.frame), kiPhoneXSeriesSafeBottomHeight);
    }

    if (_cancelTitle) {
        CGFloat cancelButtonBottom = _iphoneXSeriousSafeAreaFillView ? CGRectGetMinY(self.iphoneXSeriousSafeAreaFillView.frame) : CGRectGetHeight(self.containerView.frame);
        self.cancelButton.frame = (CGRect){0, cancelButtonBottom - [self cancelButtonSize].height, [self cancelButtonSize]};
    }
}

#pragma mark - private methods
- (CGSize)titleLBSize {
    if (HDIsStringEmpty(_title)) return CGSizeZero;

    const CGFloat maxTitleWidth = KAlertViewWidth - self.config.contentViewEdgeInsets.left - self.config.contentViewEdgeInsets.right;
    return [self.titleLB sizeThatFits:CGSizeMake(maxTitleWidth, MAXFLOAT)];
}

- (CGSize)subTitleLBSize {
    if (HDIsStringEmpty(_subTitle)) return CGSizeZero;

    const CGFloat maxTitleWidth = KAlertViewWidth - self.config.contentViewEdgeInsets.left - self.config.contentViewEdgeInsets.right;
    return [self.subTitleLB sizeThatFits:CGSizeMake(maxTitleWidth, MAXFLOAT)];
}

- (CGSize)tipLBSize {
    if (HDIsStringEmpty(_tipStr)) return CGSizeZero;

    const CGFloat maxTitleWidth = KAlertViewWidth - self.config.contentViewEdgeInsets.left - self.config.contentViewEdgeInsets.right;
    return [self.tipLB sizeThatFits:CGSizeMake(maxTitleWidth, MAXFLOAT)];
}

- (CGSize)imageViewSize {
    const CGFloat width = KAlertViewWidth * 0.6;
    return CGSizeMake(width, width);
}

- (CGSize)cancelButtonSize {
    if (HDIsStringEmpty(_cancelTitle)) return CGSizeZero;
    return CGSizeMake(KAlertViewWidth, self.config.buttonHeight);
}

#pragma mark - event response
- (void)cancelBTNDidClicked {
    [self dismiss];
}

#pragma mark - lazy load
- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = self.title;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.textColor = self.config.titleColor;
        _titleLB.numberOfLines = 0;
        _titleLB.font = self.config.titleFont;
    }
    return _titleLB;
}

- (UILabel *)subTitleLB {
    if (!_subTitleLB) {
        _subTitleLB = [[UILabel alloc] init];
        _subTitleLB.text = self.subTitle;
        _subTitleLB.textAlignment = NSTextAlignmentCenter;
        _subTitleLB.textColor = self.config.subTitleColor;
        _subTitleLB.numberOfLines = 0;
        _subTitleLB.font = self.config.subTitleFont;
    }
    return _subTitleLB;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] init];
        _tipLB.text = self.tipStr;
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.textColor = self.config.tipLBColor;
        _tipLB.numberOfLines = 0;
        _tipLB.font = self.config.tipLBFont;
    }
    return _tipLB;
}

- (UIImageView *)imageV {
    return _imageV ?: ({ _imageV = [[UIImageView alloc] initWithImage:self.image]; });
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = self.config.cancelTitleFont;
        [_cancelButton setTitleColor:self.config.cancelTitleColor forState:UIControlStateNormal];
        _cancelButton.backgroundColor = self.config.cancelButtonBackgroundColor;
        [_cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelBTNDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)iphoneXSeriousSafeAreaFillView {
    if (!_iphoneXSeriousSafeAreaFillView) {
        _iphoneXSeriousSafeAreaFillView = [[UIView alloc] init];
        _iphoneXSeriousSafeAreaFillView.backgroundColor = self.config.cancelButtonBackgroundColor;
    }
    return _iphoneXSeriousSafeAreaFillView;
}
@end
