//
//  HDScrollTitleBarViewButton.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDScrollTitleBarViewButton.h"
#import "HDCommonDefines.h"

@implementation HDScrollTitleBarViewCellModel

@end

@interface HDScrollTitleBarViewButton ()
@property (nonatomic, strong) UIImageView *bubbleBgImageView;  ///< 气泡背景
@property (nonatomic, strong) UILabel *bubbleTitleLabel;       ///< 气泡文字
@end

@implementation HDScrollTitleBarViewButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.bubbleBgImageView];
        [self.bubbleBgImageView addSubview:self.bubbleTitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.bubbleBgImageView.hidden) {
        if (!self.bubbleTitleLabel.isHidden) {
            [self.bubbleTitleLabel sizeToFit];
            CGSize titleSize = self.bubbleTitleLabel.frame.size;
            CGSize bubbleSize = CGSizeMake(titleSize.width + 10, 15);
            CGFloat x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width;
            CGFloat y = self.titleLabel.frame.origin.y;
            self.bubbleBgImageView.frame = CGRectMake(x - 2, y - 15 + 2, bubbleSize.width, bubbleSize.height);
            self.bubbleTitleLabel.frame = CGRectMake(5, (15 - bubbleSize.height) / 2, bubbleSize.width, bubbleSize.height);
        } else {
            self.bubbleBgImageView.frame = (CGRect){CGRectGetMaxX(self.titleLabel.frame) + 2, (CGRectGetHeight(self.titleLabel.frame) - self.bubbleBgImageView.image.size.height) * 0.5 + CGRectGetMinY(self.titleLabel.frame), self.bubbleBgImageView.image.size};
        }
    }
}

#pragma mark - getters and setters
- (void)setModel:(HDScrollTitleBarViewCellModel *)model {
    _model = model;
    self.bubbleTitleLabel.hidden = HDIsStringEmpty(model.bubbleText) || model.bubbleImage;
    self.bubbleBgImageView.hidden = !model.bubbleImage && HDIsStringEmpty(model.bubbleText);
    if (!self.bubbleTitleLabel.isHidden) {
        self.bubbleTitleLabel.text = model.bubbleText;
    }
    if (!self.bubbleBgImageView.isHidden) {
        self.bubbleBgImageView.image = model.bubbleImage ? model.bubbleImage : [UIImage imageNamed:@"bubble_bg"];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - lazy load
/** @lazy bubbleBgImageView */
- (UIImageView *)bubbleBgImageView {
    if (!_bubbleBgImageView) {
        _bubbleBgImageView = [[UIImageView alloc] init];
        _bubbleBgImageView.contentMode = UIViewContentModeScaleToFill;
        [_bubbleBgImageView setHidden:YES];
    }
    return _bubbleBgImageView;
}

- (UILabel *)bubbleTitleLabel {
    if (!_bubbleTitleLabel) {
        _bubbleTitleLabel = [[UILabel alloc] init];
        _bubbleTitleLabel.font = [UIFont systemFontOfSize:8];
        _bubbleTitleLabel.textColor = [UIColor whiteColor];
        _bubbleTitleLabel.numberOfLines = 1;
    }
    return _bubbleTitleLabel;
}

@end
