//
//  HDPlaceholderView.m
//  HDUIKit
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDPlaceholderView.h"
#import "HDUIGhostButton.h"
#import <HDKitCore/HDCommonDefines.h>
#import <Masonry/Masonry.h>

@interface HDPlaceholderView ()
@property (nonatomic, strong) UILabel *placeholderLabel;       ///< 占位文字
@property (nonatomic, strong) UIImageView *placeholderImageV;  ///< 占位图片
@property (nonatomic, strong) HDUIGhostButton *refreshBtn;     ///< 刷新按钮
@property (nonatomic, strong) UIView *stackView;               ///< 控制整体垂直居中
@end

@implementation HDPlaceholderView

#pragma mark - life cycle
- (void)commonInit {
    if (!self.placeholderImageV) {
        self.placeholderImageV = [[UIImageView alloc] init];
        [self addSubview:self.placeholderImageV];
    }
    self.placeholderImageV.image = [UIImage imageNamed:self.model.image];

    if (!self.placeholderLabel) {
        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.placeholderLabel];
    }

    self.placeholderLabel.text = self.model.title;
    self.placeholderLabel.textColor = self.model.titleColor;
    self.placeholderLabel.font = self.model.refreshBtnTitleFont;

    if (!self.refreshBtn) {
        self.refreshBtn = [[HDUIGhostButton alloc] init];
        self.refreshBtn.titleLabel.numberOfLines = 0;
        [self.refreshBtn addTarget:self action:@selector(tappedRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.refreshBtn];
    }
    self.refreshBtn.contentEdgeInsets = self.model.refreshButtonLabelEdgeInset;
    if (self.model.refreshBtnAttributeTitle.length) {
        [self.refreshBtn setAttributedTitle:self.model.refreshBtnAttributeTitle forState:UIControlStateNormal];
    } else {
        [self.refreshBtn setTitle:self.model.refreshBtnTitle forState:UIControlStateNormal];
        [self.refreshBtn setTitleColor:self.model.refreshBtnTitleColor forState:UIControlStateNormal];
        self.refreshBtn.titleLabel.font = self.model.refreshBtnTitleFont;
    }
    self.refreshBtn.backgroundColor = self.model.refreshBtnBackgroundColor;
    self.refreshBtn.hidden = !self.model.needRefreshBtn;

    if (!self.stackView) {
        self.stackView = [[UIView alloc] init];
        [self addSubview:self.stackView];
    }

    [self bringSubviewToFront:self];
    [self bringSubviewToFront:self.placeholderImageV];
    [self bringSubviewToFront:self.placeholderLabel];
    [self bringSubviewToFront:self.refreshBtn];
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

- (void)updateConstraints {
    [super updateConstraints];

    if (self.placeholderImageV && !self.placeholderImageV.isHidden) {
        [self.placeholderImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            if (self.model.scaleImage) {
                make.size.mas_equalTo(self.model.imageSize);
            } else {
                make.size.mas_equalTo(self.placeholderImageV.image.size);
            }
        }];
    }

    if (self.placeholderLabel && !self.placeholderLabel.isHidden) {
        [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(self).offset(-2 * kRealWidth(15));
            make.top.equalTo(self.placeholderImageV.mas_bottom).offset(self.model.marginInfoToImage);
        }];
    }

    if (self.refreshBtn && !self.refreshBtn.isHidden) {
        [self.refreshBtn sizeToFit];
        [self.refreshBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.placeholderLabel.mas_bottom).offset(self.model.marginBtnToInfo);
        }];
        [self.refreshBtn setNeedsDisplay];
    }

    if (self.stackView && !self.stackView.isHidden) {
        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.placeholderImageV);
            if (self.refreshBtn.isHidden) {
                make.bottom.equalTo(self.placeholderLabel);
            } else {
                make.bottom.equalTo(self.refreshBtn);
            }
            make.centerY.equalTo(self);
            make.left.lessThanOrEqualTo(self.placeholderImageV);
            make.left.lessThanOrEqualTo(self.placeholderLabel);
            make.right.greaterThanOrEqualTo(self.placeholderImageV);
            make.right.greaterThanOrEqualTo(self.placeholderLabel);
        }];
    }
}

#pragma mark - override system methods
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.model.needRefreshBtn) {
        if (CGRectContainsPoint(self.refreshBtn.frame, point)) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - event response
- (void)tappedRefreshBtn {
    if (self.model.clickOnRefreshButtonHandler) {
        self.model.clickOnRefreshButtonHandler();
    } else {
        !self.tappedRefreshBtnHandler ?: self.tappedRefreshBtnHandler();
    }
}

#pragma mark - getters and setters

- (void)setModel:(UIViewPlaceholderViewModel *)model {
    _model = model;

    [self commonInit];

    [self setNeedsUpdateConstraints];
}
@end
