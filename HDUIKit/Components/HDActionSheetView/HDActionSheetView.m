//
//  HDActionSheetView.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionSheetView.h"
#import "HDActionSheetViewButton.h"
#import "HDAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIView+HD_Extension.h>

// 宽度
#define kHDActionSheetViewWidth (kScreenWidth * 1)

@interface HDActionSheetView ()
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;              ///< iPhoneX 系列底部填充
@property (nonatomic, copy) NSString *cancelButtonTitle;                           ///< 取消按钮标题
@property (nonatomic, strong) HDActionSheetViewConfig *config;                     ///< 配置
@property (nonatomic, strong) NSMutableArray<HDActionSheetViewButton *> *buttons;  ///< 按钮
@property (nonatomic, strong) NSMutableArray<UIView *> *lines;                     ///< 线条
@end

@implementation HDActionSheetView
#pragma mark - life cycle
+ (instancetype)alertViewWithCancelButtonTitle:(NSString *__nullable)cancelButtonTitle config:(HDActionSheetViewConfig *__nullable)config {
    return [[self alloc] initWithCancelButtonTitle:cancelButtonTitle config:config];
}

- (instancetype)initWithCancelButtonTitle:(NSString *__nullable)cancelButtonTitle config:(HDActionSheetViewConfig *__nullable)config {
    if (self = [super init]) {
        config = config ?: [[HDActionSheetViewConfig alloc] init];

        _cancelButtonTitle = cancelButtonTitle;

        HDActionSheetViewButton *cancelBTN = [HDActionSheetViewButton buttonWithTitle:_cancelButtonTitle
                                                                                 type:HDActionSheetViewButtonTypeCancel
                                                                              handler:^(HDActionSheetView *alertView, HDActionSheetViewButton *button) {
            if(alertView.cancelButtonHandler) {
                alertView.cancelButtonHandler(alertView, button);
            } else {
                [alertView dismiss];
            }
                                                                              }];
        cancelBTN.alertView = self;
        [self.buttons addObject:cancelBTN];

        _config = config;

        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.allowTapBackgroundDismiss = true;
    }
    return self;
}

#pragma mark - override
- (void)layoutContainerView {

    CGFloat left = 0;
    CGFloat containerHeight = 0;

    if (self.buttons.count > 0) {
        containerHeight += [self buttonsAndLinesSize].height;
    }

    containerHeight += kiPhoneXSeriesSafeBottomHeight;

    CGFloat top = kScreenHeight - containerHeight;
    self.containerView.frame = CGRectMake(left, top, kHDActionSheetViewWidth, containerHeight);

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
    for (HDActionSheetViewButton *button in self.buttons) {
        [self.containerView addSubview:button];
    }

    for (short i = 0; i < self.buttons.count - 2; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = _config.lineColor;
        [self.containerView addSubview:line];
        [self.lines addObject:line];
    }

    if (iPhoneXSeries) {
        [self.containerView addSubview:self.iphoneXSeriousSafeAreaFillView];
    }
}

- (void)layoutContainerViewSubViews {

    // 计算按钮位置
    const CGFloat buttonW = CGRectGetWidth(self.containerView.frame), buttonH = _config.buttonHeight;

    for (short i = 0; i < self.buttons.count; i++) {
        HDActionSheetViewButton *button = self.buttons[i];

        button.frame = CGRectMake(0, (_config.buttonHeight + _config.lineHeight) * i, buttonW, buttonH);
    }

    CGFloat lineX = _config.lineEdgeInsets.left;
    CGFloat lineW = CGRectGetWidth(self.containerView.frame) - _config.lineEdgeInsets.left - _config.lineEdgeInsets.right;
    CGFloat lineH = _config.lineHeight;
    for (short i = 0; i < self.lines.count; i++) {
        UIView *line = self.lines[i];

        line.frame = CGRectMake(lineX, _config.buttonHeight + (_config.buttonHeight + _config.lineHeight) * i, lineW, lineH);
    }
    if (_iphoneXSeriousSafeAreaFillView) {
        self.iphoneXSeriousSafeAreaFillView.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame) - kiPhoneXSeriesSafeBottomHeight, CGRectGetWidth(self.containerView.frame), kiPhoneXSeriesSafeBottomHeight);
    }
}

#pragma mark - private methods
- (CGSize)buttonsAndLinesSize {
    const CGFloat buttonsWidth = kHDActionSheetViewWidth;
    CGFloat height = self.buttons.count * _config.buttonHeight + (self.buttons.count - 2) * _config.lineHeight;

    return CGSizeMake(buttonsWidth, height);
}

#pragma mark - public methods
- (void)addButton:(HDActionSheetViewButton *)button {

    if (button.type != HDActionSheetViewButtonTypeCancel) {
        [self.buttons addObject:button];
        [self sortButtons];
        button.alertView = self;

        [self invalidateLayout];
    }
}

- (void)addButtons:(NSArray<HDActionSheetViewButton *> *)buttons {

    // 过滤取消类型的
    for (HDActionSheetViewButton *button in buttons) {
        if (button.type != HDActionSheetViewButtonTypeCancel) {
            [self.buttons addObject:button];
        }
    }
    [self sortButtons];
    for (HDActionSheetViewButton *button in buttons) {
        button.alertView = self;
    }

    [self invalidateLayout];
}

#pragma mark - private methods
- (void)sortButtons {
    [self.buttons sortUsingComparator:^NSComparisonResult(HDActionSheetViewButton *_Nonnull obj1, HDActionSheetViewButton *_Nonnull obj2) {
        return obj1.type == HDActionSheetViewButtonTypeCancel;
    }];
}

#pragma mark - lazy load
- (NSMutableArray<HDActionSheetViewButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray<UIView *> *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

- (UIView *)iphoneXSeriousSafeAreaFillView {
    if (!_iphoneXSeriousSafeAreaFillView) {
        _iphoneXSeriousSafeAreaFillView = [[UIView alloc] init];
        _iphoneXSeriousSafeAreaFillView.backgroundColor = HDAppTheme.color.normalBackground;
    }
    return _iphoneXSeriousSafeAreaFillView;
}
@end
