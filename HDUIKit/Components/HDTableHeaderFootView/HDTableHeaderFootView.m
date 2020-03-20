//
//  HDTableHeaderFootView.m
//  ViPay
//
//  Created by VanJay on 2019/9/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTableHeaderFootView.h"
#import "HDAppTheme.h"
#import "Masonry.h"

@interface HDTableHeaderFootView ()
@property (nonatomic, strong) UIImageView *imageView;       ///< 图片
@property (nonatomic, strong) UILabel *titleLabel;          ///< 标题
@property (nonatomic, strong) UIView *rightViewContainer;   ///< 右 View
@property (nonatomic, strong) UIImageView *rightImageView;  ///< 右按钮图片
@property (nonatomic, strong) UILabel *rightLabel;          ///< 右按钮标题
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
    [self.contentView addSubview:self.rightViewContainer];
    [self.rightViewContainer addSubview:self.rightImageView];
    [self.rightViewContainer addSubview:self.rightLabel];
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
    }];

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
    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setModel:(HDTableHeaderFootViewModel *)model {
    _model = model;

    self.contentView.backgroundColor = model.backgroundColor;

    _imageView.hidden = !model.image;

    if (model.image) {
        _imageView.image = model.image;
    }

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

    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedRightButtonHandler {
    !self.rightButtonClickedHandler ?: self.rightButtonClickedHandler();
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
@end
