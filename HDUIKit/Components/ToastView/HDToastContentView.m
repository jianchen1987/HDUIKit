//
//  HDToastContentView.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDToastContentView.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"
#import "UIView+HDKitCore.h"

@interface HDToastContentView ()
@property (nonatomic, assign) BOOL isSquareAndHeightChanged;  ///< 正方形且高度被强制改变
@end

@implementation HDToastContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.allowsGroupOpacity = NO;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {

    _textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [HDAppTheme HDFontStandard3];
    self.textLabel.opaque = NO;
    [self addSubview:self.textLabel];

    _detailTextLabel = [[UILabel alloc] init];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.font = [HDAppTheme HDFontStandard4];
    self.detailTextLabel.opaque = NO;
    [self addSubview:self.detailTextLabel];
}

- (void)setCustomView:(UIView *)customView {
    if (self.customView) {
        [self.customView removeFromSuperview];
        _customView = nil;
    }
    _customView = customView;
    [self addSubview:self.customView];
    [self updateCustomViewTintColor];
    [self setNeedsLayout];
}

- (void)setTextLabelText:(NSString *)textLabelText {
    _textLabelText = textLabelText;
    if (textLabelText) {
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:textLabelText attributes:self.textLabelAttributes];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self setNeedsLayout];
    }
}

- (void)setDetailTextLabelText:(NSString *)detailTextLabelText {
    _detailTextLabelText = detailTextLabelText;
    if (detailTextLabelText) {
        self.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:detailTextLabelText attributes:self.detailTextLabelAttributes];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self sizeThatFits:size shouldConsiderMinimumSize:YES];
}

- (CGSize)sizeThatFits:(CGSize)size shouldConsiderMinimumSize:(BOOL)shouldConsiderMinimumSize {
    BOOL hasCustomView = !!self.customView;
    BOOL hasTextLabel = self.textLabel.text.length > 0;
    BOOL hasDetailTextLabel = self.detailTextLabel.text.length > 0;

    CGFloat width = 0;
    CGFloat height = 0;

    CGFloat maxContentWidth = size.width - UIEdgeInsetsGetHorizontalValue(self.insets);
    CGFloat maxContentHeight = size.height - UIEdgeInsetsGetVerticalValue(self.insets);

    if (hasCustomView) {
        width = fmin(maxContentWidth, fmax(width, CGRectGetWidth(self.customView.frame)));
        height += (CGRectGetHeight(self.customView.frame) + ((hasTextLabel || hasDetailTextLabel) ? self.customViewMarginBottom : 0));
    }

    if (hasTextLabel) {
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(maxContentWidth, maxContentHeight)];
        width = fmin(maxContentWidth, fmax(width, textLabelSize.width));
        height += (textLabelSize.height + (hasDetailTextLabel ? self.textLabelMarginBottom : 0));
    }

    if (hasDetailTextLabel) {
        CGSize detailTextLabelSize = [self.detailTextLabel sizeThatFits:CGSizeMake(maxContentWidth, maxContentHeight)];
        width = fmin(maxContentWidth, fmax(width, detailTextLabelSize.width));
        height += (detailTextLabelSize.height + self.detailTextLabelMarginBottom);
    }

    width += UIEdgeInsetsGetHorizontalValue(self.insets);
    height += UIEdgeInsetsGetVerticalValue(self.insets);

    if (shouldConsiderMinimumSize) {
        width = fmax(width, self.minimumSize.width);
        height = fmax(height, self.minimumSize.height);
    }
    if (self.isSquare) {
        self.isSquareAndHeightChanged = width > height;

        width = fmax(width, height);
        height = fmax(width, height);
    }
    return CGSizeMake(width, height);
}

- (void)layoutSubviews {
    [super layoutSubviews];

    BOOL hasCustomView = !!self.customView;
    BOOL hasTextLabel = self.textLabel.text.length > 0;
    BOOL hasDetailTextLabel = self.detailTextLabel.text.length > 0;

    CGFloat vInsets = UIEdgeInsetsGetVerticalValue(self.insets);

    CGFloat contentLimitWidth = self.hd_width - UIEdgeInsetsGetHorizontalValue(self.insets);
    CGSize contentSize = [self sizeThatFits:self.bounds.size shouldConsiderMinimumSize:NO];

    CGFloat minY = self.insets.top + CGFloatGetCenter(self.hd_height - vInsets, contentSize.height - vInsets);
    if (hasCustomView) {
        self.customView.hd_left = self.insets.left + CGFloatGetCenter(contentLimitWidth, self.customView.hd_width);
        self.customView.hd_top = minY;
        minY = self.customView.hd_bottom + self.customViewMarginBottom;
    }
    if (hasTextLabel) {
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
        self.textLabel.hd_left = self.insets.left;
        self.textLabel.hd_top = minY;
        self.textLabel.hd_width = contentLimitWidth;
        self.textLabel.hd_height = textLabelSize.height;
        minY = self.textLabel.hd_bottom + self.textLabelMarginBottom;
    }
    if (hasDetailTextLabel) {
        CGSize detailTextLabelSize = [self.detailTextLabel sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
        self.detailTextLabel.hd_left = self.insets.left;
        self.detailTextLabel.hd_top = minY;
        self.detailTextLabel.hd_width = contentLimitWidth;
        self.detailTextLabel.hd_height = detailTextLabelSize.height;
    }
    if (self.isSquareAndHeightChanged) {
        // 正方形且高度被强制改变，纠正 Y 值
        if (hasCustomView && hasTextLabel && hasDetailTextLabel) {
            minY = CGFloatGetCenter(self.hd_height, self.customView.hd_height + self.customViewMarginBottom + self.textLabel.hd_height + self.textLabelMarginBottom + self.detailTextLabel.hd_height);
            self.customView.hd_top = minY;
            self.textLabel.hd_top = self.customView.hd_bottom + self.customViewMarginBottom;
            self.detailTextLabel.hd_top = self.textLabel.hd_bottom + self.textLabelMarginBottom;
        } else if (hasCustomView && hasTextLabel) {
            minY = CGFloatGetCenter(self.hd_height, self.customView.hd_height + self.customViewMarginBottom + self.textLabel.hd_height);
            self.customView.hd_top = minY;
            self.textLabel.hd_top = self.customView.hd_bottom + self.customViewMarginBottom;
        } else if (hasCustomView && hasDetailTextLabel) {
            minY = CGFloatGetCenter(self.hd_height, self.customView.hd_height + self.customViewMarginBottom + self.detailTextLabel.hd_height);
            self.customView.hd_top = minY;
            self.detailTextLabel.hd_top = self.customView.hd_bottom + self.customViewMarginBottom;
        } else if (hasTextLabel && hasDetailTextLabel) {
            minY = CGFloatGetCenter(self.hd_height, self.textLabel.hd_height + self.textLabelMarginBottom + self.detailTextLabel.hd_height);
            self.textLabel.hd_top = minY;
            self.detailTextLabel.hd_top = self.textLabel.hd_bottom + self.textLabelMarginBottom;
        } else if (hasCustomView) {
            minY = CGFloatGetCenter(self.hd_height, self.customView.hd_height);
            self.customView.hd_top = minY;
        } else if (hasTextLabel) {
            minY = CGFloatGetCenter(self.hd_height, self.textLabel.hd_height);
            self.textLabel.hd_top = minY;
        } else if (hasDetailTextLabel) {
            minY = CGFloatGetCenter(self.hd_height, self.detailTextLabel.hd_height);
            self.detailTextLabel.hd_top = minY;
        }
    }
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    if (self.customView) {
        [self updateCustomViewTintColor];
    }

    // 如果通过 attributes 设置了文字颜色，则不再响应 tintColor
    if (!self.textLabelAttributes[NSForegroundColorAttributeName]) {
        self.textLabel.textColor = self.tintColor;
    }

    if (!self.detailTextLabelAttributes[NSForegroundColorAttributeName]) {
        self.detailTextLabel.textColor = self.tintColor;
    }
}

- (void)updateCustomViewTintColor {
    if (!self.customView) {
        return;
    }
    self.customView.tintColor = self.tintColor;
    if ([self.customView isKindOfClass:[UIActivityIndicatorView class]]) {
        UIActivityIndicatorView *customView = (UIActivityIndicatorView *)self.customView;
        customView.color = self.tintColor;
    }
}

#pragma mark - UIAppearance

- (void)setInsets:(UIEdgeInsets)insets {
    if (UIEdgeInsetsEqualToEdgeInsets(_insets, insets)) return;
    _insets = insets;
    [self setNeedsLayout];
}

- (void)setMinimumSize:(CGSize)minimumSize {
    if (CGSizeEqualToSize(_minimumSize, minimumSize)) return;
    _minimumSize = minimumSize;
    [self setNeedsLayout];
}

- (void)setSquare:(BOOL)square {
    if (_square == square) return;
    _square = square;
    [self setNeedsLayout];
}

- (void)setCustomViewMarginBottom:(CGFloat)customViewMarginBottom {
    if (_customViewMarginBottom == customViewMarginBottom) return;
    _customViewMarginBottom = customViewMarginBottom;
    [self setNeedsLayout];
}

- (void)setTextLabelMarginBottom:(CGFloat)textLabelMarginBottom {
    if (_textLabelMarginBottom == textLabelMarginBottom) return;
    _textLabelMarginBottom = textLabelMarginBottom;
    [self setNeedsLayout];
}

- (void)setDetailTextLabelMarginBottom:(CGFloat)detailTextLabelMarginBottom {
    if (_detailTextLabelMarginBottom == detailTextLabelMarginBottom) return;
    _detailTextLabelMarginBottom = detailTextLabelMarginBottom;
    [self setNeedsLayout];
}

- (void)setTextLabelAttributes:(NSDictionary *)textLabelAttributes {
    _textLabelAttributes = textLabelAttributes;
    if (self.textLabelText && self.textLabelText.length > 0) {
        // 刷新label的attributes
        self.textLabelText = self.textLabelText;
    }
}

- (void)setDetailTextLabelAttributes:(NSDictionary *)detailTextLabelAttributes {
    _detailTextLabelAttributes = detailTextLabelAttributes;
    if (self.detailTextLabelText && self.detailTextLabelText.length > 0) {
        // 刷新label的attributes
        self.detailTextLabelText = self.detailTextLabelText;
    }
}

@end

@interface HDToastContentView (UIAppearance)

@end

@implementation HDToastContentView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    HDToastContentView *appearance = [HDToastContentView appearance];
    appearance.insets = UIEdgeInsetsMake(15, 12, 15, 12);
    appearance.minimumSize = CGSizeZero;
    appearance.square = false;
    appearance.customViewMarginBottom = 8;
    appearance.textLabelMarginBottom = 4;
    appearance.detailTextLabelMarginBottom = 0;
}

@end
