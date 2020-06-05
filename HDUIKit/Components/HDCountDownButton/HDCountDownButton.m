//
//  HDCountDownButton.m
//  HDUIKit
//
//  Created by VanJay on 2019/11/8.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCountDownButton.h"
#import "HDWeakTimer.h"

@interface HDCountDownButton () {
    NSTimer *_timer;
    NSDate *_startDate;
}
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSUInteger totalSecond;
@end

@implementation HDCountDownButton
#pragma mark - life cycle
- (void)commonInit {
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - event response
- (void)touched:(HDCountDownButton *)sender {
    if (self.clickedCountDownButtonHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.clickedCountDownButtonHandler(sender);
        });
    }
}

#pragma mark - getters and setters
- (NSInteger)leftSecond {
    return self.second;
}

- (void)setEnabled:(BOOL)enabled {
    if (self.enabled == enabled) return;

    [super setEnabled:enabled];

    !self.countDownStateChangedHandler ?: self.countDownStateChangedHandler(self, enabled);
}

#pragma mark - count down method
- (void)startCountDownWithSecond:(NSUInteger)totalSecond {
    _totalSecond = totalSecond;
    _second = totalSecond;

    __weak typeof(self) weakSelf = self;
    _timer = [HDWeakTimer scheduledTimerWithTimeInterval:1.0
                                                   block:^(id userInfo) {
                                                       typeof(weakSelf) strongSelf = weakSelf;
                                                       [strongSelf timerStart];
                                                   }
                                                userInfo:nil
                                                 repeats:true];

    _startDate = [NSDate date];
    _timer.fireDate = [NSDate distantPast];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerStart {
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_startDate];

    _second = _totalSecond - (NSInteger)(deltaTime + 0.5);

    if (_second <= 0.0) {
        [self stopCountDown];
    } else {
        if (self.countDownChangingHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = self.countDownChangingHandler(self, self.second);
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateDisabled];

                [self fittingGreaterSizeThanNormalState];
            });
        } else {
            NSString *title = [NSString stringWithFormat:@"%zds", _second];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];

            [self fittingGreaterSizeThanNormalState];
        }
    }
}

- (void)stopCountDown {
    void (^setTitleHandler)(void) = ^(void) {
        if (self.countDownFinishedHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = self.countDownFinishedHandler(self, self.totalSecond);
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateDisabled];

                [self fittingGreaterSizeThanNormalState];
            });
        } else {
            [self setTitle:@"重新获取" forState:UIControlStateNormal];
            [self setTitle:@"重新获取" forState:UIControlStateDisabled];

            [self fittingGreaterSizeThanNormalState];
        }
    };

    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];
                _second = _totalSecond;
                setTitleHandler();
            }
        }
    } else {
        setTitleHandler();
    }
}

#pragma mark - private methods
- (void)fittingGreaterSizeThanNormalState {
    // 判断新宽度与原始宽度大小
    CGSize newSize = [self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (newSize.width > self.normalStateWidth) {
        self.shouldUseNormalStateWidth = false;
        !self.notNormalStateWidthGreaterThanNormalBlock ?: self.notNormalStateWidthGreaterThanNormalBlock(self);
    } else {
        self.shouldUseNormalStateWidth = true;
        // 恢复原始大小
        !self.restoreNormalStateWidthBlock ?: self.restoreNormalStateWidthBlock(self);
    }
}
@end
