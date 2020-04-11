//
//  HDActionSheetViewButton.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionSheetViewButton.h"
#import "HDAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>

@implementation HDActionSheetViewButton
+ (instancetype)buttonWithTitle:(NSString *)title type:(HDActionSheetViewButtonType)type handler:(HDActionSheetViewButtonHandler)handler {
    return [[self alloc] initWithTitle:title type:type handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title type:(HDActionSheetViewButtonType)type handler:(HDActionSheetViewButtonHandler)handler {
    if (self = [super init]) {
        self.type = type;
        self.handler = handler;

        [self setTitle:title forState:UIControlStateNormal];

        [self setProperties];
    }
    return self;
}

#pragma mark - life cycle
- (void)commonInit {
    self.adjustsImageWhenHighlighted = false;

    [self addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];

    [self setProperties];
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

- (void)setProperties {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];

    if (_type == HDActionSheetViewButtonTypeDefault) {
        self.backgroundColor = UIColor.whiteColor;
        self.titleLabel.font = HDAppTheme.font.standard2;
    } else if (_type == HDActionSheetViewButtonTypeCustom) {
        self.backgroundColor = UIColor.whiteColor;
        self.titleLabel.font = HDAppTheme.font.standard2;
    } else if (_type == HDActionSheetViewButtonTypeCancel) {
        self.backgroundColor = HDAppTheme.color.normalBackground;
        self.titleLabel.font = HDAppTheme.font.standard2Bold;
    }
}
#pragma mark - event response
- (void)tappedButton {
    !self.handler ?: self.handler(self.alertView, self);
}

#pragma mark - getters and setters
- (void)setType:(HDActionSheetViewButtonType)type {
    _type = type;

    [self setProperties];
}
@end
