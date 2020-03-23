//
//  HDScrollNavBar.m
//  HDUIKit
//
//  Created by VanJay on 2020/1/3.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDScrollNavBar.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"
#import "HDFrameLayout.h"
#import "HDScrollTitleBarTool.h"
#import "NSString+HD_Size.h"
#import "UIView+HDKitCore.h"

@interface HDScrollNavBar ()
/** 滚动容器 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 指示器 */
@property (nonatomic, strong) UIView *indicateLine;
/** 底部的线 */
@property (nonatomic, strong) UIView *bottomLine;
/** 前一个按钮 */
@property (nonatomic, weak) HDScrollTitleBarViewButton *preButton;
/** 后一个按钮 */
@property (nonatomic, weak) HDScrollTitleBarViewButton *nextButton;
/** 存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray<HDScrollTitleBarViewButton *> *allButtons;
@end

@implementation HDScrollNavBar
#pragma mark - life cycle
- (void)commonInit {
    self.isTitleLabelColorGradientChangeEnabled = YES;
    self.isIndicateLineAnimationEnabled = true;
    self.isTitleLabelZoomEnabled = true;
    self.sideMargin = 10;
    self.btnMargin = 10;
    self.currentIndex = 0;
    self.isBtnEqualWidth = NO;
    self.indicateLineHeight = 2;
    self.indicateLineColor = [HDAppTheme HDColorC1];
    self.bottomLineHeight = 0;
    self.bottomLineColor = HexColor(0xE9E9E9);
    self.normalFontSize = 15;
    self.selectedFontSize = 15;
    self.titleLabelZoomScale = 1.2;
    self.titleNormalColor = [HDAppTheme HDColorG2];
    self.titleSelectedColor = [HDAppTheme HDColorC1];
    self.marginBottomToIndicateLine = 2;
    self.isIndicateLineWidthEqualToFullButton = false;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.indicateLine];
    [self.scrollView addSubview:self.bottomLine];
}

- (void)dealloc {
    if (self.contentScrollView) {
        [self.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
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

- (void)setupButtons {
    NSInteger itensCount = self.dataSource.count;
    for (NSInteger i = 0; i < itensCount; i++) {
        HDScrollTitleBarViewCellModel *model = self.dataSource[i];
        HDScrollTitleBarViewButton *button = [self createItemWithTitle:model.title];
        [self.allButtons addObject:button];
        button.index = i;
        button.model = model;
        [button setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [button setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
    }
}

#pragma mark - layout
- (void)layoutScrollViewWithContainerSize:(CGSize)size {
    CGFloat buttonHeight = self.height - self.indicateLineHeight - self.marginBottomToIndicateLine;
    if (!self.bottomLine.isHidden) {
        buttonHeight -= self.bottomLineHeight;
    }
    CGFloat leftX = 0;

    CGFloat maxBtnWidth = 0, averageWidth = (size.width - 2 * self.sideMargin - (self.dataSource.count - 1) * self.btnMargin) / (CGFloat)self.dataSource.count;
    for (NSUInteger i = 0; i < _allButtons.count; i++) {
        HDScrollTitleBarViewButton *btn = _allButtons[i];

        CGFloat fontSize = self.normalFontSize;
        if (self.isTitleLabelZoomEnabled) {
            if (self.titleLabelZoomScale > 1) {
                fontSize = self.normalFontSize * self.titleLabelZoomScale;
            } else {
                fontSize = self.normalFontSize;
            }
        } else {
            fontSize = self.selectedFontSize > self.normalFontSize ? self.selectedFontSize : self.normalFontSize;
        }

        if (self.isBtnWidthEqualAndExpandFullWidth) {
            btn.width = averageWidth;
        } else {
            CGSize buttonSize = [btn.titleLabel.text boundingAllRectWithSize:CGSizeMake(CGFLOAT_MAX, buttonHeight) font:[HDAppTheme fontForSize:fontSize] lineSpacing:0];
            btn.width = buttonSize.width;
        }

        btn.height = buttonHeight;
        btn.top = 0;
        btn.left = leftX + _sideMargin;

        leftX += btn.width + _btnMargin;

        if (i == _allButtons.count - 1) {
            CGFloat scrollViewContentW = btn.right + _sideMargin;
            self.scrollView.contentSize = CGSizeMake(scrollViewContentW, self.scrollView.height);

            // 检查宽度，如果最后一个按钮加右边距未到达边缘，则按等比例扩大所有按钮的宽度至总宽度
            if (scrollViewContentW < self.scrollView.width) {
                [self resetButtonWidthWithLeftSpacing:self.scrollView.width - scrollViewContentW];
                self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height);
            }
        }
        // 获取按钮最大的宽度
        if (_isBtnEqualWidth && btn.width > maxBtnWidth) {
            maxBtnWidth = btn.width;
        }
    }
    leftX = 0;

    if (!self.isBtnWidthEqualAndExpandFullWidth && _isBtnEqualWidth) {
        for (NSUInteger i = 0; i < _allButtons.count; i++) {
            HDScrollTitleBarViewButton *btn = _allButtons[i];

            btn.width = maxBtnWidth;
            btn.left = leftX + _sideMargin;
            leftX += btn.width + _btnMargin;

            if (i == _allButtons.count - 1) {
                CGFloat scrollViewContentW = btn.right + _sideMargin;
                self.scrollView.contentSize = CGSizeMake(scrollViewContentW, self.scrollView.height);

                // 检查宽度，如果最后一个按钮加右边距未到达边缘，则按等比例扩大所有按钮的宽度至总宽度
                if (scrollViewContentW < self.scrollView.width) {
                    [self resetButtonWidthWithLeftSpacing:self.scrollView.width - scrollViewContentW];
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height);
                }
            }
        }
    }
}

- (void)resetButtonWidthWithLeftSpacing:(CGFloat)spacing {
    CGFloat leftX = 0;
    CGFloat scale = self.scrollView.contentSize.width - 2 * _sideMargin - (_allButtons.count - 1) * _btnMargin;
    for (HDScrollTitleBarViewButton *btn in _allButtons) {
        btn.width = btn.width + btn.width / scale * spacing;
        btn.left = leftX + _sideMargin;
        leftX += btn.width + _btnMargin;
    }
}

/** 更新指示器布局 */
- (void)updateIndicateLineFrame {
    if (!self.currentButton) return;

    [self.indicateLine hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        if (self.bottomLine.isHidden) {
            make.bottom.hd_equalTo(self.height - self.marginBottomToIndicateLine);
        } else {
            make.bottom.hd_equalTo(self.bottomLine.top - self.marginBottomToIndicateLine);
        }
        make.centerX.hd_equalTo(self.currentButton.centerX);
        make.height.hd_equalTo(self.indicateLineHeight);
        if (self.indicateLineWidth > 0) {
            make.width.hd_equalTo(self.indicateLineWidth);
        } else {
            if (self.isIndicateLineWidthEqualToFullButton) {
                make.width.hd_equalTo(self.currentButton.width);
            } else {
                make.width.hd_equalTo(self.currentButton.titleLabel.width);
            }
        }
    }];
    self.indicateLine.layer.cornerRadius = CGRectGetHeight(self.indicateLine.bounds) * 0.5;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGSizeIsEmpty(self.size)) return;

    self.scrollView.frame = self.bounds;

    [self layoutScrollViewWithContainerSize:self.size];

    if (!self.bottomLine.isHidden) {
        [self.bottomLine hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.height.hd_equalTo(self.bottomLineHeight);
            make.width.hd_equalTo(self.width);
            make.bottom.hd_equalTo(self.height);
            make.centerX.hd_equalTo(self.width * 0.5);
        }];
    }

    // 设置初始指示器坐标
    [self.indicateLine hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        if (self.bottomLine.isHidden) {
            make.bottom.hd_equalTo(self.height - self.marginBottomToIndicateLine);
        } else {
            make.bottom.hd_equalTo(self.bottomLine.top - self.marginBottomToIndicateLine);
        }
        make.height.hd_equalTo(self.indicateLineHeight);

        if (self.indicateLineWidth > 0) {
            make.width.hd_equalTo(self.indicateLineWidth);
        } else {
            if (self.isIndicateLineWidthEqualToFullButton) {
                [self.allButtons[self.currentIndex] sizeToFit];
                CGSize size = self.allButtons[self.currentIndex].size;
                make.width.hd_equalTo(size.width);
            } else {
                CGSize size = [self.allButtons[self.currentIndex].titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
                make.width.hd_equalTo(size.width);
            }
        }
        make.centerX.hd_equalTo(self.allButtons[self.currentIndex].centerX);
    }];
}

#pragma mark - event response
- (void)buttonClicked:(HDScrollTitleBarViewButton *)button {
    if (!self.isTitleLabelZoomEnabled) {
        [self clickButtonWhenNotGraduallyChangFont:button];
    } else {
        _preButton = _currentButton;
        _currentButton.selected = NO;
        button.selected = YES;
        _currentButton = button;
    }

    [self setScrollViewContentOffsetWithIndex:button.index];
    _currentIndex = button.index;

    if (!self.forbiddenInvokeHandler && self.selectedBtnHandler) {
        self.selectedBtnHandler(button.index);
    }

    // 用户拖动触发的 click 就不要继续了
    if (self.contentScrollView.isTracking || self.contentScrollView.isDecelerating) return;

    CGFloat offX = button.index * self.contentScrollView.width;
    [self.contentScrollView setContentOffset:CGPointMake(offX, 0) animated:YES];
}

#pragma mark - public methods
- (void)selectBtnAtIndex:(NSUInteger)btnIndex {
    if (isnan(btnIndex) || isinf(btnIndex)) return;

    if (self.allButtons.count >= btnIndex + 1) {
        HDScrollTitleBarViewButton *button = self.allButtons[btnIndex];
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - private methods

- (HDScrollTitleBarViewButton *)createItemWithTitle:(NSString *)title {
    HDScrollTitleBarViewButton *button = [[HDScrollTitleBarViewButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [HDAppTheme fontForSize:self.normalFontSize];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = self.buttonTitleEdgeInsets;
    [self.scrollView addSubview:button];
    return button;
}

- (void)setupNormalFontSizeItem {
    self.preButton.titleLabel.font = [HDAppTheme fontForSize:self.normalFontSize];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:self.normalFontSize];

    [self.preButton setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
    [self.nextButton setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
}

#pragma mark - 带渐变
/** 设置滚动容器位置 */
- (void)setScrollViewContentOffsetWithIndex:(NSInteger)index {
    HDScrollTitleBarViewButton *selectButton = self.allButtons[index];

    const CGFloat boundsWidth = self.scrollView.bounds.size.width;
    const CGFloat contentWidth = self.scrollView.contentSize.width;

    if (boundsWidth >= contentWidth) return;

    CGFloat margin = 0;
    [UIView animateWithDuration:0.1
                     animations:^{
                         CGFloat offSetX = selectButton.center.x - boundsWidth * 0.5 + margin;
                         CGFloat offsetX1 = (contentWidth - selectButton.center.x) - boundsWidth * 0.5 + margin;
                         if (offSetX > 0 && offsetX1 > 0) {
                             self.scrollView.contentOffset = CGPointMake(offSetX, 0);
                         } else if (offSetX < 0) {
                             self.scrollView.contentOffset = CGPointMake(0, 0);
                         } else if (offsetX1 < 0) {
                             self.scrollView.contentOffset = CGPointMake(contentWidth - boundsWidth - margin, 0);
                         }
                     }];
}

- (void)changeButtonStyleWithOffset:(CGFloat)offsetX width:(CGFloat)width {

    [self setupNormalFontSizeItem];

    CGFloat percent = fmod(offsetX, width) / width;
    NSInteger index = offsetX / width;

    if (self.contentScrollView.isTracking || self.contentScrollView.isDecelerating) {
        [self selectBtnAtIndex:index];
    }

    if (self.allButtons.count > index) {
        self.preButton = self.allButtons[index];
    }
    if (self.allButtons.count > index + 1) {
        self.nextButton = (index + 1 < self.dataSource.count) ? self.allButtons[index + 1] : nil;
    }

    [self setItemFontSizeWithPreButton:self.preButton nextButton:self.nextButton andPercent:percent];
    [self setItemFontColorWithFrontItem:self.preButton nextButton:self.nextButton andPercent:percent];
    [self setIndicateLineAnimationWithPreButton:self.preButton nextButton:self.nextButton andPercent:percent];
}

- (void)setItemFontColorWithFrontItem:(HDScrollTitleBarViewButton *)preButton nextButton:(HDScrollTitleBarViewButton *)nextButton andPercent:(CGFloat)percent {
    if (self.isTitleLabelColorGradientChangeEnabled) {

        [preButton setTitleColor:[HDScrollTitleBarTool interpolationColorFrom:self.titleNormalColor to:self.titleSelectedColor percent:1 - percent] forState:UIControlStateNormal];
        [nextButton setTitleColor:[HDScrollTitleBarTool interpolationColorFrom:self.titleNormalColor to:self.titleSelectedColor percent:percent] forState:UIControlStateNormal];
    } else {
        if (percent > 0.5) {
            nextButton.titleLabel.textColor = self.titleSelectedColor;
            preButton.titleLabel.textColor = self.titleNormalColor;
        } else {
            nextButton.titleLabel.textColor = self.titleNormalColor;
            preButton.titleLabel.textColor = self.titleSelectedColor;
        }
    }
}

- (void)setItemFontSizeWithPreButton:(HDScrollTitleBarViewButton *)preButton nextButton:(HDScrollTitleBarViewButton *)nextButton andPercent:(CGFloat)percent {

    if (self.isTitleLabelZoomEnabled) {
        CGFloat frontFontSize = (1 - percent) * (self.titleLabelZoomScale * self.normalFontSize - self.normalFontSize) + self.normalFontSize;
        CGFloat nextFontSize = percent * (self.titleLabelZoomScale * self.normalFontSize - self.normalFontSize) + self.normalFontSize;

        preButton.titleLabel.font = [HDAppTheme fontForSize:frontFontSize];
        nextButton.titleLabel.font = [HDAppTheme fontForSize:nextFontSize];
    } else {
        if (percent > 0.5) {
            nextButton.titleLabel.font = [HDAppTheme fontForSize:self.selectedFontSize];
            preButton.titleLabel.font = [HDAppTheme fontForSize:self.normalFontSize];
        } else {
            nextButton.titleLabel.font = [HDAppTheme fontForSize:self.normalFontSize];
            preButton.titleLabel.font = [HDAppTheme fontForSize:self.selectedFontSize];
        }
    }
}

- (void)setIndicateLineAnimationWithPreButton:(HDScrollTitleBarViewButton *)preButton nextButton:(HDScrollTitleBarViewButton *)nextButton andPercent:(CGFloat)percent {
    if (self.indicateLineHeight <= 0) return;

    // N多细节处理
    [self.indicateLine hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        if (self.bottomLine.isHidden) {
            make.bottom.hd_equalTo(self.height - self.marginBottomToIndicateLine);
        } else {
            make.bottom.hd_equalTo(self.bottomLine.top - self.marginBottomToIndicateLine);
        }
        make.height.hd_equalTo(self.indicateLineHeight);
        if (percent < 0.5) {
            if (self.isIndicateLineAnimationEnabled) {
                if (self.indicateLineWidth > 0) {
                    make.left.hd_equalTo(preButton.centerX - self.indicateLineWidth * 0.5);
                    CGFloat width = percent * 2 * (nextButton.centerX + self.indicateLineWidth * 0.5 - preButton.centerX - self.indicateLineWidth * 0.5) + self.indicateLineWidth;
                    make.width.hd_equalTo(width);
                } else {
                    if (self.isIndicateLineWidthEqualToFullButton) {
                        make.left.hd_equalTo(preButton.left);
                        CGFloat width = percent * 2 * (nextButton.right - preButton.right) + preButton.width;
                        width = width >= preButton.width ? width : preButton.width;
                        make.width.hd_equalTo(width);
                    } else {
                        CGRect nextButtonLabelFrame = [nextButton.titleLabel convertRect:nextButton.titleLabel.bounds toView:self];
                        CGRect preButtonLabelFrame = [preButton.titleLabel convertRect:preButton.titleLabel.bounds toView:self];
                        make.left.hd_equalTo(CGRectGetMinX(preButtonLabelFrame));
                        CGFloat width = percent * 2 * (CGRectGetMaxX(nextButtonLabelFrame) - CGRectGetMaxX(preButtonLabelFrame)) + preButton.titleLabel.width;
                        width = width >= preButton.titleLabel.width ? width : preButton.titleLabel.width;
                        make.width.hd_equalTo(width);
                    }
                }
            } else {
                if (self.indicateLineWidth > 0) {
                    make.centerX.hd_equalTo(preButton.centerX);
                    make.width.hd_equalTo(self.indicateLineWidth);
                } else {
                    if (self.isIndicateLineWidthEqualToFullButton) {
                        make.left.hd_equalTo(preButton.left);
                        make.right.hd_equalTo(preButton.right);
                    } else {
                        CGRect preButtonLabelFrame = [preButton.titleLabel convertRect:preButton.titleLabel.bounds toView:self];
                        make.left.hd_equalTo(CGRectGetMinX(preButtonLabelFrame));
                        make.right.hd_equalTo(CGRectGetMaxX(preButtonLabelFrame));
                    }
                }
            }
        } else {
            if (self.isIndicateLineAnimationEnabled) {
                if (self.indicateLineWidth > 0) {
                    make.right.hd_equalTo(nextButton.centerX + self.indicateLineWidth * 0.5);
                    CGFloat width = (1 - percent) * 2 * (nextButton.centerX + self.indicateLineWidth * 0.5 - preButton.centerX - self.indicateLineWidth * 0.5) + self.indicateLineWidth;
                    make.width.hd_equalTo(width);
                } else {
                    if (self.isIndicateLineWidthEqualToFullButton) {
                        make.right.hd_equalTo(nextButton.right);
                        CGFloat width = (1 - percent) * 2 * (nextButton.right - preButton.right) + preButton.width;
                        width = width >= nextButton.width ? width : nextButton.width;
                        make.width.hd_equalTo(width);
                    } else {
                        CGRect nextButtonLabelFrame = [nextButton.titleLabel convertRect:nextButton.titleLabel.bounds toView:self];
                        CGRect preButtonLabelFrame = [preButton.titleLabel convertRect:preButton.titleLabel.bounds toView:self];
                        make.right.hd_equalTo(CGRectGetMaxX(nextButtonLabelFrame));
                        CGFloat width = (1 - percent) * 2 * (CGRectGetMaxX(nextButtonLabelFrame) - CGRectGetMaxX(preButtonLabelFrame)) + preButton.titleLabel.width;
                        width = width >= nextButton.titleLabel.width ? width : nextButton.titleLabel.width;
                        make.width.hd_equalTo(width);
                    }
                }
            } else {
                if (self.indicateLineWidth > 0) {
                    make.centerX.hd_equalTo(nextButton.centerX);
                    make.width.hd_equalTo(self.indicateLineWidth);
                } else {
                    if (self.isIndicateLineWidthEqualToFullButton) {
                        make.right.hd_equalTo(nextButton.right);
                        make.left.hd_equalTo(nextButton.left);
                    } else {
                        CGRect nextButtonLabelFrame = [nextButton.titleLabel convertRect:nextButton.titleLabel.bounds toView:self];
                        make.left.hd_equalTo(CGRectGetMinX(nextButtonLabelFrame));
                        make.right.hd_equalTo(CGRectGetMaxX(nextButtonLabelFrame));
                    }
                }
            }
        }
    }];
}

#pragma mark - 不带渐变
- (void)clickButtonWhenNotGraduallyChangFont:(HDScrollTitleBarViewButton *)button {
    _preButton = _currentButton;

    _preButton.titleLabel.font = [HDAppTheme fontForSize:self.normalFontSize];

    _currentButton.selected = NO;
    button.selected = YES;
    _currentButton = button;

    _currentButton.titleLabel.font = [HDAppTheme fontForSize:self.normalFontSize];
}

- (void)selectItemWhenNotGraduallyChangFont:(HDScrollTitleBarViewButton *)button {
    _preButton = _currentButton;

    _preButton.titleLabel.font = [HDAppTheme fontForSize:self.normalFontSize];

    _currentButton.selected = NO;
    button.selected = YES;
    _currentButton = button;

    _currentButton.titleLabel.font = [HDAppTheme fontForSize:self.normalFontSize];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIScrollView *)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {

    if ([object isEqual:self.contentScrollView]) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            [self changeButtonStyleWithOffset:self.contentScrollView.contentOffset.x width:self.contentScrollView.width];
        }
    }
}

#pragma mark - getters and setters
- (void)setDataSource:(NSArray<HDScrollTitleBarViewCellModel *> *)dataSource {
    [self setDataSource:dataSource invokeHandler:nil];
}

- (void)setDataSource:(NSArray<HDScrollTitleBarViewCellModel *> *)dataSource invokeHandler:(void (^)(void))invokeHandler {
    _dataSource = dataSource;

    if (self.allButtons.count == 0) {
        [self setupButtons];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 创建的时候模拟点击默认的
        [self selectBtnAtIndex:self.currentIndex];

        [self updateIndicateLineFrame];

        !invokeHandler ?: invokeHandler();
    });
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView {

    if (_contentScrollView != nil) {
        [_contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _contentScrollView = contentScrollView;

    [_contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setSideMargin:(CGFloat)sideMargin {
    if (_sideMargin == sideMargin) return;

    _sideMargin = sideMargin;

    [self setNeedsLayout];
}

- (void)setBtnMargin:(CGFloat)btnMargin {
    if (btnMargin == _btnMargin) return;
    _btnMargin = btnMargin;

    [self setNeedsLayout];
}

- (void)setIndicateLineHeight:(CGFloat)indicateLineHeight {
    if (_indicateLineHeight == indicateLineHeight) return;
    _indicateLineHeight = indicateLineHeight;

    self.indicateLine.hidden = indicateLineHeight <= 0;
    [self setNeedsLayout];
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight {
    if (bottomLineHeight == _bottomLineHeight) return;
    _bottomLineHeight = bottomLineHeight;

    self.bottomLine.hidden = bottomLineHeight <= 0;
    [self setNeedsLayout];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor;

    for (HDScrollTitleBarViewButton *button in self.allButtons) {
        [button setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;

    for (HDScrollTitleBarViewButton *button in self.allButtons) {
        [button setTitleColor:titleSelectedColor forState:UIControlStateSelected];
    }
}

- (void)setIndicateLineColor:(UIColor *)indicateLineColor {
    _indicateLineColor = indicateLineColor;

    _indicateLine.backgroundColor = indicateLineColor;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;

    _bottomLine.backgroundColor = bottomLineColor;
}

- (void)setIsTitleLabelColorGradientChangeEnabled:(BOOL)isTitleLabelColorGradientChangeEnabled {
    _isTitleLabelColorGradientChangeEnabled = isTitleLabelColorGradientChangeEnabled;

    if (!isTitleLabelColorGradientChangeEnabled) {
        for (HDScrollTitleBarViewButton *button in self.allButtons) {
            [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
            [button setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;

    if (currentIndex > _dataSource.count - 1) return;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 创建的时候模拟点击默认的
        [self selectBtnAtIndex:currentIndex];
    });
}

- (CGFloat)fullExpandedWidth {
    [self layoutScrollViewWithContainerSize:CGSizeMake(100, 40)];
    return self.scrollView.contentSize.width;
}

#pragma mark - lazy load
- (NSMutableArray<HDScrollTitleBarViewButton *> *)allButtons {
    return _allButtons ?: ({ _allButtons = [NSMutableArray array]; });
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.showsVerticalScrollIndicator = false;
    }
    return _scrollView;
}

- (UIView *)indicateLine {
    if (!_indicateLine) {
        _indicateLine = UIView.new;
        _indicateLine.backgroundColor = self.indicateLineColor;
    }
    return _indicateLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = self.bottomLineColor;
    }
    return _bottomLine;
}
@end
