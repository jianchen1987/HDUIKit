//
//  HDAnnouncementView.m
//  HDUIKit
//
//  Created by Chaos on 2021/4/22.
//

#import "HDAnnouncementView.h"
#import "HDAppTheme.h"
#import <Masonry/Masonry.h>
#import <HDKitCore/HDCommonDefines.h>

@implementation HDAnnouncementViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textFont = HDAppTheme.font.standard4;
        self.textColor = HDAppTheme.color.G3;
        self.rate = 50;
        self.backgroundColor = HDAppTheme.color.G5;
        self.contentInsets = UIEdgeInsetsMake(8, 15, 8, 15);
        self.trumpetToTextMargin = kRealWidth(5);
        self.marqueeType = HDMarqueeTypeContinuous;
        self.leadingBuffer = 0;
        self.trailingBuffer = 20;
    }
    return self;
}

@end

@interface HDAnnouncementView ()
/// 喇叭
@property (nonatomic, strong) UIImageView *iconIV;
/// label
@property (nonatomic, strong) HDMarqueeLabel *textLabel;
@end

@implementation HDAnnouncementView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self hd_setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.iconIV];
    [self addSubview:self.textLabel];

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hd_clickedViewHandler)]];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconIV.image.size);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(self.config.contentInsets.left);
    }];

    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.config.contentInsets.top);
        make.bottom.equalTo(self).offset(-self.config.contentInsets.bottom);
        make.left.equalTo(self.iconIV.mas_right).offset(self.config.trumpetToTextMargin);
        make.right.equalTo(self).offset(-self.config.contentInsets.right);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)hd_clickedViewHandler {
    !self.tappedHandler ?: self.tappedHandler();
}

#pragma mark - setter
- (void)setConfig:(HDAnnouncementViewConfig *)config {
    _config = config;
    
    self.backgroundColor = self.config.backgroundColor;
    self.iconIV.image = config.trumpetImage;
    
    self.textLabel.text = config.text;
    self.textLabel.textColor = config.textColor;
    self.textLabel.font = config.textFont;
    self.textLabel.rate = config.rate;
    self.textLabel.marqueeType = config.marqueeType;
    self.textLabel.trailingBuffer = config.trailingBuffer;
    self.textLabel.leadingBuffer = config.leadingBuffer;
    
    [self.textLabel restartLabel];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        _iconIV = imageView;
    }
    return _iconIV;
}

- (HDMarqueeLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = HDMarqueeLabel.new;
    }
    return _textLabel;
}

@end
