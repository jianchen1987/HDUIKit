//
//  HDKeyBoardTheme.m
//  HDUIKit
//
//  Created by VanJay on 2019/5/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDKeyBoardTheme.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"
#import "UIImage+HDKitCore.h"
#import "UIView+HD_Extension.h"

@implementation HDKeyBoardButtonModel
+ (instancetype)modelWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(HDKeyBoardButtonType)type {
    return [[self alloc] initWithIsCapital:isCapital showText:showText value:value type:type];
}

- (instancetype)initWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(HDKeyBoardButtonType)type {
    if (self = [super init]) {
        self.isCapital = isCapital;
        self.showText = showText;
        self.value = value;
        self.type = type;
    }
    return self;
}
@end

@interface HDKeyBoardButton ()
@property (nonatomic, strong) UIView *redPointView;  ///< 红点
@end

@implementation HDKeyBoardButton
#pragma mark - life cycle
+ (instancetype)keyBoardButtonWithModel:(HDKeyBoardButtonModel *)model {
    return [[self alloc] initKeyBoardButtonWithModel:model];
}

- (instancetype)initKeyBoardButtonWithModel:(HDKeyBoardButtonModel *)model {
    if (self = [super init]) {
        self.model = model;

        [self commonInit];
    }
    return self;
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

- (void)commonInit {
    [self hd_updateTitle];
}

#pragma mark - public methods
- (void)hd_updateTitle {
    if (self.model) {
        if (self.model.type == HDKeyBoardButtonTypeLetter) {
            if (self.model.isCapital) {
                [self setTitle:[self.model.showText uppercaseString] forState:UIControlStateNormal];
                self.model.value = [self.model.value uppercaseString];
                self.model.showText = [self.model.value uppercaseString];
            } else {
                [self setTitle:[self.model.showText lowercaseString] forState:UIControlStateNormal];
                self.model.value = [self.model.value lowercaseString];
                self.model.showText = [self.model.value lowercaseString];
            }
        } else {
            [self setTitle:self.model.showText forState:UIControlStateNormal];
        }
    }
}

#pragma mark - getters and setters
- (void)setModel:(HDKeyBoardButtonModel *)model {
    _model = model;

    [self hd_updateTitle];
}

#pragma mark - getters and setters
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    if (highlighted) {
        [self setTitleColor:self.model.highlightTitleColor forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage hd_imageWithColor:self.model.highlightBgColor] forState:UIControlStateNormal];
    } else {
        [self setTitleColor:self.model.titleColor forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage hd_imageWithColor:self.model.bgColor] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (selected) {
        [self setBackgroundImage:[UIImage hd_imageWithColor:self.model.selectedBgColor] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:[UIImage hd_imageWithColor:self.model.bgColor] forState:UIControlStateNormal];
    }
    if (self.model.type == HDKeyBoardButtonTypeShift) {
        selected ? [self addRedPoint] : [self removeRedPoint];
    }
}

- (void)addRedPoint {
    _redPointView = [[UIView alloc] init];
    _redPointView.backgroundColor = [HDAppTheme HDColorC1];
    _redPointView.frame = CGRectMake(5, 5, kRealWidth(6), kRealWidth(6));
    [self addSubview:_redPointView];
    [_redPointView setRoundedCorners:UIRectCornerAllCorners radius:_redPointView.bounds.size.height * 0.5];
}

- (void)removeRedPoint {
    if (self.redPointView) {
        [self.redPointView removeFromSuperview];
        self.redPointView = nil;
    }
}

@end

@implementation HDKeyBoardTheme

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认值
        self.backgroundColor = [HDAppTheme HDColorG1];
        self.buttonBgColor = HDColor(93, 102, 127, 0.4);
        self.buttonSelectedBgColor = HDColor(93, 102, 127, 1);
        self.buttonHighlightBgColor = HDColor(93, 102, 127, 1);
        self.funcButtonBgColor = HDColor(93, 102, 127, 1);
        self.funcButtonHighlightBgColor = HDColor(93, 102, 127, 0.4);
        self.funcButtonSelectedBgColor = HDColor(93, 102, 127, 0.4);
        self.digitalButtonFont = [UIFont fontWithName:@"PingFang SC" size:23];
        self.letterButtonFont = [UIFont fontWithName:@"Helvetica Neue" size:22];
        self.buttonTitleColor = UIColor.whiteColor;
        self.buttonTitleHighlightColor = UIColor.whiteColor;
        self.enterpriseLabelFont = [UIFont fontWithName:@"PingFang SC" size:15];
        self.enterpriseShowStyle = HDKeyBoardEnterpriseInfoShowTypeImageLeft;
        self.enterpriseMargin = 10;
        self.enterpriseLabelColor = [HDAppTheme HDColorG3];
        self.deleteButtonImage = @"keyboard_delete";
        self.shiftButtonImage = @"keyboard_shift";
        self.shiftButtonSelectedImage = @"keyboard_shift_selected";
        self.enterpriseText = @"- HDUIKit 安全键盘 -";
        self.doneButtonName = @"Done";
        self.doneButtonTitleColor = UIColor.whiteColor;
        self.doneButtonHighlightTitleColor = UIColor.whiteColor;
        self.doneButtonBgColor = HDColor(248, 52, 96, 1);
        self.doneButtonHighlightBgColor = HDColor(248, 52, 96, 0.5);
    }
    return self;
}
@end
