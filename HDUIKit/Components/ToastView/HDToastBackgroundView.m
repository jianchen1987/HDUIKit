//
//  HDToastBackgroundView.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDToastBackgroundView.h"
#import "HDCommonDefines.h"
#import "HDVisualEffectView.h"

@interface HDToastBackgroundView ()

@end

@implementation HDToastBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.allowsGroupOpacity = NO;
        self.backgroundColor = self.styleColor;
        self.layer.cornerRadius = self.cornerRadius;
    }
    return self;
}

- (void)setShouldBlurBackgroundView:(BOOL)shouldBlurBackgroundView {
    _shouldBlurBackgroundView = shouldBlurBackgroundView;
    if (shouldBlurBackgroundView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[HDVisualEffectView alloc] initWithEffect:effect];
        self.effectView.layer.cornerRadius = self.cornerRadius;
        self.effectView.layer.masksToBounds = YES;
        self.effectView.foregroundColor = nil;
        [self addSubview:self.effectView];
    } else {
        if (self.effectView) {
            [self.effectView removeFromSuperview];
            _effectView = nil;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.effectView) {
        self.effectView.frame = self.bounds;
    }
}

#pragma mark - UIAppearance

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
    self.backgroundColor = styleColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    if (self.effectView) {
        self.effectView.layer.cornerRadius = cornerRadius;
    }
}

@end

@interface HDToastBackgroundView (UIAppearance)

@end

@implementation HDToastBackgroundView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    HDToastBackgroundView *appearance = [HDToastBackgroundView appearance];
    appearance.styleColor = HDColor(0, 0, 0, 0.6);
    appearance.cornerRadius = 10.0;
}

@end
