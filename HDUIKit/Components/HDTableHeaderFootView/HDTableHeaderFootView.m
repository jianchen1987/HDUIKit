//
//  HDTableHeaderFootView.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTableHeaderFootView.h"
#import "HDAppTheme.h"
#import "HDLabel.h"
#import "Masonry.h"

@interface HDTableHeaderFootView ()
@property (nonatomic, strong) UIImageView *imageView;       ///< 图片
@property (nonatomic, strong) UILabel *titleLabel;          ///< 标题
@property (nonatomic, strong) UIView *rightViewContainer;   ///< 右 View
@property (nonatomic, strong) UIImageView *rightImageView;  ///< 右按钮图片
@property (nonatomic, strong) UILabel *rightLabel;          ///< 右按钮标题
@property (nonatomic, strong) HDLabel *tagLabel;            ///< 标题标签
/// 底部线条
@property (nonatomic, strong) UIView *line;
@end

@implementation HDTableHeaderFootView

+ (instancetype)headerWithTableView:(UITableView *)tableView {

    // 新建标识
    static NSString *ID = @"HDTableHeaderFootView";
    // 创建cell
    HDTableHeaderFootView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];

    if (!header) {
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        // 初始化子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.rightViewContainer];
    [self.contentView addSubview:self.line];
    [self.rightViewContainer addSubview:self.rightImageView];
    [self.rightViewContainer addSubview:self.rightLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedViewHandler)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)updateConstraints {

    const CGFloat marginToBottom = self.model.marginToBottom;
    const UIEdgeInsets edgeInsets = self.model.edgeInsets;

    if (!self.imageView.isHidden) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(edgeInsets.left);
            make.size.mas_equalTo(self.imageView.image.size);
            if (marginToBottom > 0) {
                make.centerY.equalTo(self.titleLabel);
            } else {
                make.centerY.equalTo(self.contentView);
            }
        }];
    }
    UIView *rightView = self.tagLabel.isHidden ? (self.rightViewContainer.isHidden ? nil : self.rightViewContainer) : self.tagLabel;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.imageView.isHidden) {
            make.left.equalTo(self.contentView).offset(edgeInsets.left);
        } else {
            make.left.equalTo(self.imageView.mas_right).offset(self.model.titleToImageMarin);
        }
        if (marginToBottom > 0) {
            make.bottom.equalTo(self.contentView).offset(-marginToBottom);
        } else {
            make.centerY.equalTo(self.contentView);
        }
        if (!rightView) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        } else {
            make.right.lessThanOrEqualTo(rightView.mas_left).offset(-10);
        }
    }];

    if (!self.tagLabel.isHidden) {
        [self.tagLabel sizeToFit];
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            if (!self.rightViewContainer.isHidden) {
                make.right.lessThanOrEqualTo(self.rightViewContainer.mas_left).offset(-10);
            } else {
                make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
            }
        }];
    }

    if (!self.rightViewContainer.isHidden) {
        if (HDTableHeaderFootViewRightViewAlignmentTitleRightImageLeft == self.model.rightViewAlignment) {
            [self.rightViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.rightImageView.isHidden) {
                    make.left.equalTo(self.rightImageView);
                } else {
                    make.left.equalTo(self.rightLabel);
                }
                make.right.equalTo(self.rightLabel);
                make.height.centerY.equalTo(self.contentView);
            }];

            if (!self.rightLabel.isHidden) {
                [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.contentView).offset(-edgeInsets.right);
                    if (marginToBottom > 0) {
                        make.bottom.equalTo(self.contentView).offset(-marginToBottom);
                    } else {
                        make.centerY.equalTo(self.contentView);
                    }
                }];
            }

            if (!self.rightImageView.isHidden) {
                [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (self.rightLabel.isHidden) {
                        make.right.equalTo(self.contentView).offset(-edgeInsets.right);
                    } else {
                        make.right.equalTo(self.rightLabel.mas_left).offset(-self.model.rightTitleToImageMarin);
                    }
                    make.size.mas_equalTo(self.rightImageView.image.size);
                    if (marginToBottom > 0) {
                        if (!self.rightLabel.isHidden) {
                            make.centerY.equalTo(self.rightLabel);
                        } else {
                            make.bottom.equalTo(self.contentView).offset(-marginToBottom);
                        }
                    } else {
                        make.centerY.equalTo(self.contentView);
                    }
                }];
            }
        } else if (HDTableHeaderFootViewRightViewAlignmentTitleLeftImageRight == self.model.rightViewAlignment) {
            [self.rightViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.rightLabel.isHidden) {
                    make.left.equalTo(self.rightLabel);
                } else {
                    make.left.equalTo(self.rightImageView);
                }
                make.right.equalTo(self.rightImageView);
                make.height.centerY.equalTo(self.contentView);
            }];

            if (!self.rightImageView.isHidden) {
                [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.contentView).offset(-edgeInsets.right);
                    make.size.mas_equalTo(self.rightImageView.image.size);
                    if (marginToBottom > 0) {
                        make.bottom.equalTo(self.contentView).offset(-marginToBottom);
                    } else {
                        make.centerY.equalTo(self.contentView);
                    }
                }];
            }

            if (!self.rightLabel.isHidden) {
                [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (self.rightImageView.isHidden) {
                        make.right.equalTo(self.contentView).offset(-edgeInsets.right);
                    } else {
                        make.right.equalTo(self.rightImageView.mas_left).offset(-self.model.rightTitleToImageMarin);
                    }

                    if (marginToBottom > 0) {
                        if (!self.rightImageView.isHidden) {
                            make.centerY.equalTo(self.rightImageView);
                        } else {
                            make.bottom.equalTo(self.contentView).offset(-marginToBottom);
                        }
                    } else {
                        make.centerY.equalTo(self.contentView);
                    }
                }];
            }
        }
    }
    
    if(!self.line.isHidden) {
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(edgeInsets.left);
            make.right.equalTo(self.contentView.mas_right).offset(-edgeInsets.right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(self.model.lineHeight);
        }];
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!CGRectEqualToRect(CGRectZero, self.tagLabel.frame)) {
        self.tagLabel.layer.cornerRadius = self.model.tagCornerRadius;
        self.tagLabel.layer.masksToBounds = YES;
    }
}

#pragma mark - getters and setters
- (void)setModel:(HDTableHeaderFootViewModel *)model {
    _model = model;

    self.contentView.backgroundColor = model.backgroundColor;

    _imageView.hidden = !model.image;

    if (model.image) {
        _imageView.image = model.image;
    }
    
    _titleLabel.numberOfLines = model.titleNumberOfLines;
    if (model.title.length > 0) {
        _titleLabel.text = model.title;
        _titleLabel.font = model.titleFont;
        _titleLabel.textColor = model.titleColor;
    } else if (model.attrTitle) {
        _titleLabel.attributedText = model.attrTitle;
    }

    _rightViewContainer.hidden = model.rightButtonTitle.length <= 0 && !model.rightButtonImage;
    _rightLabel.hidden = model.rightButtonTitle.length <= 0;
    if (!_rightLabel.isHidden) {
        _rightLabel.text = model.rightButtonTitle;
        _rightLabel.font = model.rightButtonTitleFont;
        _rightLabel.textColor = model.rightButtonTitleColor;
    }
    _rightImageView.hidden = !model.rightButtonImage;
    if (!_rightImageView.isHidden) {
        _rightImageView.image = model.rightButtonImage;
    }

    if (model.tag.length > 0) {
        _tagLabel.text = model.tag;
        _tagLabel.hidden = NO;
        _tagLabel.font = model.tagFont;
        _tagLabel.textColor = model.tagColor;
        _tagLabel.backgroundColor = model.tagBackgroundColor;
        _tagLabel.hd_edgeInsets = model.tagTitleEdgeInset;
    } else {
        _tagLabel.hidden = YES;
    }
    
    if(model.lineHeight > 0) {
        [self.line setHidden:NO];
    } else {
        [self.line setHidden:YES];
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedRightButtonHandler {
    !self.rightButtonClickedHandler ?: self.rightButtonClickedHandler();
}
- (void)clickedViewHandler {
    !self.viewClickedHandler ?: self.viewClickedHandler(self.model);
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.hidden = true;
    }
    return _imageView;
}

- (UIView *)rightViewContainer {
    if (!_rightViewContainer) {
        _rightViewContainer = UIView.new;
        _rightViewContainer.hidden = true;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedRightButtonHandler)];
        [_rightViewContainer addGestureRecognizer:recognizer];
    }
    return _rightViewContainer;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = UILabel.new;
    }
    return _rightLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = UIImageView.new;
    }
    return _rightImageView;
}

- (HDLabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[HDLabel alloc] init];
    }
    return _tagLabel;
}
- (UIView *)line {
    if(!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.color.G5;
    }
    return _line;
}
@end
