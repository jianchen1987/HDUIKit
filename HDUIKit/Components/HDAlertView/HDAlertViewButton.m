//
//  HDAlertViewButton.m
//  ViPay
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAlertViewButton.h"
#import "HDAppTheme.h"

@implementation HDAlertViewButton
+ (instancetype)buttonWithTitle:(NSString *)title type:(HDAlertViewButtonType)type handler:(HDAlertViewButtonHandler)handler {
    return [[self alloc] initWithTitle:title type:type handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title type:(HDAlertViewButtonType)type handler:(HDAlertViewButtonHandler)handler {
    if (self = [super init]) {
        self.type = type;
        self.handler = handler;

        self.titleLabel.numberOfLines = 2;
        [self setTitle:title forState:UIControlStateNormal];

        [self setProperties];
    }
    return self;
}

#pragma mark - life cycle
- (void)commonInit {
    [self addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = [HDAppTheme HDColorG5];

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
    self.titleLabel.font = [HDAppTheme HDFontStandard3Bold];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    if (_type == HDAlertViewButtonTypeDefault) {
        [self setTitleColor:[HDAppTheme HDColorC1] forState:UIControlStateNormal];
    } else if (_type == HDAlertViewButtonTypeCustom) {
        [self setTitleColor:[HDAppTheme HDColorC1] forState:UIControlStateNormal];
    } else if (_type == HDAlertViewButtonTypeCancel) {
        [self setTitleColor:[HDAppTheme HDColorG2] forState:UIControlStateNormal];
    }
}
#pragma mark - event response
- (void)tappedButton {
    !self.handler ?: self.handler(self.alertView, self);
}

#pragma mark - getters and setters
- (void)setType:(HDAlertViewButtonType)type {
    _type = type;

    [self setProperties];
}
@end
