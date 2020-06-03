//
//  HDSearchBar.m
//  HDUIKit
//
//  Created by VanJay on 2019/4/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSearchBar.h"
#import "FBKVOController+HDKitCore.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"
#import "NSBundle+HDUIKit.h"
#import "UIButton+EnlargeEdge.h"
#import "UIView+HD_Extension.h"
#import <Masonry/Masonry.h>

@interface HDSearchBar () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *contentView;             ///< wrapper
@property (nonatomic, strong) UITextField *textField;          ///< 输入框
@property (nonatomic, strong) UIImageView *imageView;          ///< 输入框图标
@property (nonatomic, strong) UIButton *leftButton;            ///< 左按钮
@property (nonatomic, strong) UIButton *rightButton;           ///< 右按钮
@property (nonatomic, assign) BOOL showLeftButton;             ///< 是否显示左按钮
@property (nonatomic, assign) BOOL showRightButton;            ///< 是否显示右按钮
@property (nonatomic, strong) CAShapeLayer *shadowLayer;       ///< 阴影图层
@property (nonatomic, strong) FBKVOController *KVOController;  ///< 监听外部设置 text
@end

@implementation HDSearchBar

#pragma mark - life cycle
- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    self.marginToSide = kRealWidth(15);
    self.marginButtonTextField = kRealWidth(10);
    self.buttonTitleColor = HDAppTheme.color.C1;

    self.animationDuration = 0.25;

    _contentView = UIView.new;
    self.contentView.layer.borderColor = UIColor.clearColor.CGColor;
    self.contentView.layer.borderWidth = PixelOne;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = HDAppTheme.color.G5;
    [self addSubview:_contentView];

    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search" inBundle:[NSBundle hd_UIKitSearchBarResources] compatibleWithTraitCollection:nil]];
    [self.contentView addSubview:_imageView];

    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setEnlargeEdgeWithTop:5 left:15 bottom:5 right:15];
    _leftButton.adjustsImageWhenHighlighted = false;
    [_leftButton setImage:[UIImage imageNamed:@"back" inBundle:[NSBundle hd_UIKitSearchBarResources] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_leftButton setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(clickedLeftButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];

    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setEnlargeEdgeWithTop:5 left:15 bottom:5 right:15];
    _rightButton.adjustsImageWhenHighlighted = false;
    [_rightButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_rightButton setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(clickedRightButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];

    [self.contentView addSubview:self.textField];
    [self addTextFieldObserver];
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

- (void)activeLeftButtonConstraint {
    [self.leftButton sizeToFit];
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        if (self.showLeftButton) {
            make.left.equalTo(self).offset(self.marginToSide);
            make.width.mas_equalTo(CGRectGetWidth(self.leftButton.frame));
        } else {
            make.left.equalTo(self);
            make.width.mas_equalTo(CGFLOAT_MIN);
        }
    }];
}

- (void)activeRightButtonConstraint {
    [self.rightButton sizeToFit];
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        if (self.showRightButton) {
            make.right.equalTo(self).offset(-self.marginToSide);
            make.width.mas_equalTo(CGRectGetWidth(self.rightButton.frame));
        } else {
            make.right.equalTo(self);
            make.width.mas_equalTo(CGFLOAT_MIN);
        }
    }];
}

- (void)activeContentViewConstraint {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.showLeftButton) {
            make.left.equalTo(self.leftButton.mas_right).offset(self.marginButtonTextField);
        } else {
            make.left.equalTo(self).offset(self.marginToSide);
        }

        if (self.showRightButton) {
            make.right.equalTo(self.rightButton.mas_left).offset(-self.marginButtonTextField);
        } else {
            make.right.equalTo(self).offset(-self.marginToSide);
        }
        if (self.textFieldHeight > 0) {
            make.height.mas_equalTo(self.textFieldHeight);
        } else {
            make.height.equalTo(self).offset(-2 * 8);
        }
        make.centerY.equalTo(self);
    }];
}

- (void)updateConstraints {

    [self activeLeftButtonConstraint];
    [self activeRightButtonConstraint];
    [self activeContentViewConstraint];

    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(self.imageView.image.size);
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-8);
        make.height.equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.showBottomShadow) {
        if (!CGSizeIsEmpty(self.frame.size)) {
            if (self.shadowLayer) {
                [self.shadowLayer removeFromSuperlayer];
                self.shadowLayer = nil;
            }
            self.shadowLayer = [self setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1 shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor fillColor:UIColor.whiteColor.CGColor shadowOffset:CGSizeMake(0, 3)];
        }
    } else {
        if (self.shadowLayer) {
            [self.shadowLayer removeFromSuperlayer];
            self.shadowLayer = nil;
        }
    }

    if (!CGSizeEqualToSize(CGSizeZero, self.contentView.frame.size)) {
        self.contentView.layer.cornerRadius = CGRectGetHeight(self.contentView.frame) * 0.5;
    }
}

#pragma mark - KVO
- (void)addTextFieldObserver {
    // 添加观察者
    __weak __typeof(self) weakSelf = self;
    [self.KVOController hd_observe:self.textField
                           keyPath:@"text"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                                 __strong __typeof(weakSelf) strongSelf = weakSelf;
                                 if (object == strongSelf.textField) {
                                     NSString *oldText = change[NSKeyValueChangeOldKey];
                                     NSString *newText = change[NSKeyValueChangeNewKey];

                                     if (![newText isEqualToString:oldText]) {
                                         [strongSelf.textField sendActionsForControlEvents:UIControlEventEditingChanged];
                                     }
                                 }
                             }];
}

#pragma mark - event response
- (void)clickedLeftButtonHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarLeftButtonClicked:)]) {
        [self.delegate searchBarLeftButtonClicked:self];
    }
}

- (void)clickedRightButtonHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarRightButtonClicked:)]) {
        [self.delegate searchBarRightButtonClicked:self];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}

#pragma mark - public methods
- (void)setShowLeftButton:(BOOL)showLeftButton animated:(BOOL)animated {
    self.showLeftButton = showLeftButton;

    void (^updateConstraints)(void) = ^(void) {
        [self activeLeftButtonConstraint];
        [self activeRightButtonConstraint];
        [self activeContentViewConstraint];
        [self layoutIfNeeded];
    };

    if (!animated || CGSizeIsEmpty(self.contentView.frame.size)) {
        updateConstraints();
    } else {
        [UIView animateWithDuration:self.animationDuration
                         animations:^{
                             updateConstraints();
                         }];
    }
}

- (void)setLeftButtonTitle:(NSString *)title {
    [_leftButton setTitle:title forState:UIControlStateNormal];
    [_leftButton setImage:nil forState:UIControlStateNormal];
    [self setShowLeftButton:self.showLeftButton animated:true];
}

- (void)setLeftButtonImage:(UIImage *)image {
    [_leftButton setTitle:nil forState:UIControlStateNormal];
    [_leftButton setImage:image forState:UIControlStateNormal];

    [self setShowLeftButton:self.showRightButton animated:true];
}

- (void)setShowRightButton:(BOOL)showRightButton animated:(BOOL)animated {
    self.showRightButton = showRightButton;

    void (^updateConstraints)(void) = ^(void) {
        [self activeLeftButtonConstraint];
        [self activeRightButtonConstraint];
        [self activeContentViewConstraint];
        [self layoutIfNeeded];
    };

    if (!animated || CGSizeIsEmpty(self.contentView.frame.size)) {
        updateConstraints();
    } else {
        [UIView animateWithDuration:self.animationDuration
                         animations:^{
                             updateConstraints();
                         }];
    }
}

- (void)setRightButtonTitle:(NSString *)title {
    [_rightButton setTitle:title forState:UIControlStateNormal];
    [_rightButton setImage:nil forState:UIControlStateNormal];
    [self setShowRightButton:self.showRightButton animated:true];
}

- (void)setRightButtonImage:(UIImage *)image {
    [_rightButton setTitle:nil forState:UIControlStateNormal];
    [_rightButton setImage:image forState:UIControlStateNormal];

    [self setShowRightButton:self.showRightButton animated:true];
}

- (NSString *)getText {
    return self.textField.text;
}

- (void)disableTextField {
    self.textField.userInteractionEnabled = false;
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldClear:)]) {
        return [self.delegate searchBarShouldClear:self];
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate searchBar:self shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        return [self.delegate searchBarTextDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        return [self.delegate searchBarTextDidEndEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0)) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:reason:)]) {
        return [self.delegate searchBarTextDidEndEditing:self reason:reason];
    }
}

#pragma mark - getters and setters
- (void)setShowBottomShadow:(BOOL)showBottomShadow {
    _showBottomShadow = showBottomShadow;

    [self setNeedsLayout];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.textField.font = _textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textField.textColor = _textColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.textField.tintColor = _tintColor;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = _text;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;

    if (placeHolder && [placeHolder isKindOfClass:NSString.class] && placeHolder.length > 0) {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: self.placeholderColor}];
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.contentView.layer.borderColor = _borderColor.CGColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;

    if (self.placeHolder && [self.placeHolder isKindOfClass:NSString.class] && self.placeHolder.length > 0) {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHolder attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    }
}

- (void)setInputFieldBackgrounColor:(UIColor *)inputFieldBackgrounColor {
    _inputFieldBackgrounColor = inputFieldBackgrounColor;

    self.contentView.backgroundColor = inputFieldBackgrounColor;
}

- (void)setHEdgeMargin:(CGFloat)marginToSide {
    if (_marginToSide == marginToSide) return;

    _marginToSide = marginToSide;

    [self setNeedsUpdateConstraints];
}

- (void)setSearchImage:(UIImage *)searchImage {
    _searchImage = searchImage;

    self.imageView.image = searchImage;
}

- (void)setTextFieldHeight:(CGFloat)textFieldHeight {
    _textFieldHeight = textFieldHeight;

    [self setNeedsUpdateConstraints];
}

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor {
    _buttonTitleColor = buttonTitleColor;

    if (_leftButton && !_leftButton.isHidden) {
        [_leftButton setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    }

    if (_rightButton && !_rightButton.isHidden) {
        [_rightButton setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    }
}

#pragma mark - lazy load
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = HDAppTheme.font.standard3;
        _textField.textColor = HDAppTheme.color.G1;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        _textField.rightViewMode = UITextFieldViewModeUnlessEditing;
        _textField.tintColor = HDAppTheme.color.C1;
        _textField.delegate = self;
        [_textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (FBKVOController *)KVOController {
    if (!_KVOController) {
        _KVOController = [FBKVOController controllerWithObserver:self];
    }
    return _KVOController;
}
@end
