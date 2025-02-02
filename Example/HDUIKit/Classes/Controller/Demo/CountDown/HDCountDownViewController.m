//
//  HDCountDownViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/12.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDCountDownViewController.h"

@interface HDCountDownViewController ()
/// 倒计时按钮
@property (nonatomic, strong) HDCountDownButton *buttton;
@end

@implementation HDCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.buttton];
    [self.view setNeedsUpdateConstraints];
    [self handleCountDownTime];
}

- (void)updateViewConstraints {
    [self.buttton sizeToFit];
    [self.buttton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(30);
        if (self.buttton.shouldUseNormalStateWidth) {
            make.size.mas_equalTo(CGSizeMake(self.buttton.normalStateWidth, CGRectGetHeight(self.buttton.bounds)));
        } else {
            make.size.mas_equalTo(self.buttton.frame.size);
        }
    }];
    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateSendSMSButtonBorder];
}

#pragma mark - private methods
- (void)handleCountDownTime {
    void (^countDownChangingHandler)(HDCountDownViewController *) = ^(HDCountDownViewController *vc) {
        vc.buttton.countDownChangingHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            // NSString *title = [NSString stringWithFormat:@"%zds", second];
            NSString *title = [NSString stringWithFormat:@"%zd秒后重新获取", second];
            return title;
        };
    };

    void (^countDownFinishedHandler)(HDCountDownViewController *) = ^(HDCountDownViewController *vc) {
        vc.buttton.countDownFinishedHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            countDownButton.enabled = true;
            return @"重新获取";
        };
    };

    __weak __typeof(self) weakSelf = self;
    self.buttton.clickedCountDownButtonHandler = ^(HDCountDownButton *_Nonnull countDownButton) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        countDownButton.enabled = false;
        [strongSelf showloading];
        __weak __typeof(strongSelf) weakSelf2 = strongSelf;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
            [strongSelf2 dismissLoading];

            [countDownButton startCountDownWithSecond:5];
            countDownChangingHandler(strongSelf2);
            countDownFinishedHandler(strongSelf2);
        });
    };
}

- (void)updateSendSMSButtonBorder {
    if (_buttton && !CGSizeIsEmpty(_buttton.bounds.size)) {
        self.buttton.layer.cornerRadius = CGRectGetHeight(self.buttton.frame) * 0.5;
        self.buttton.layer.borderWidth = 1;
        self.buttton.layer.borderColor = [self.buttton titleColorForState:self.buttton.state].CGColor;
    }
}

- (HDCountDownButton *)buttton {
    if (!_buttton) {
        UIFont *font = HDAppTheme.font.standard3;
        NSString *title = @"获取验证码";
        _buttton = [HDCountDownButton buttonWithType:UIButtonTypeCustom];
        _buttton.adjustsImageWhenDisabled = NO;
        _buttton.titleLabel.font = font;
        _buttton.titleEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
        [_buttton setTitleColor:HDAppTheme.color.C1 forState:UIControlStateNormal];
        [_buttton setTitleColor:HDAppTheme.color.G2 forState:UIControlStateDisabled];
        [_buttton setTitle:title forState:UIControlStateNormal];
        _buttton.normalStateWidth = [_buttton sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        @HDWeakify(self);
        _buttton.countDownStateChangedHandler = ^(HDCountDownButton *_Nonnull countDownButton, BOOL enabled) {
            @HDStrongify(self);
            [self updateSendSMSButtonBorder];
        };
        _buttton.notNormalStateWidthGreaterThanNormalBlock = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            [self.view setNeedsUpdateConstraints];
        };
        _buttton.restoreNormalStateWidthBlock = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            [self.view setNeedsUpdateConstraints];
        };
    }
    return _buttton;
}
@end
