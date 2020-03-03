//
//  HDToastAnimator.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDToastAnimator.h"
#import "HDCommonDefines.h"
#import "HDToastContentView.h"
#import "HDToastView.h"

@interface HDToastAnimator ()
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation HDToastAnimator

- (instancetype)init {
    NSAssert(NO, @"请使用initWithToastView:初始化");
    return [self initWithToastView:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSAssert(NO, @"请使用initWithToastView:初始化");
    return [self initWithToastView:nil];
}

- (instancetype)initWithToastView:(HDToastView *)toastView {
    NSAssert(toastView, @"toastView不能为空");
    if (self = [super init]) {
        _toastView = toastView;
        _duration = 3;
    }
    return self;
}

- (void)showWithCompletion:(void (^)(BOOL finished))completion {
    self.isShowing = YES;
    self.isAnimating = YES;
    self.toastView.maskView.alpha = 0;
    self.toastView.alpha = 0;

    switch (self.animationType) {
        case HDToastAnimationTypeFade: {
            [UIView animateWithDuration:self.duration
                delay:0.0
                options:HDViewAnimationOptionsCurveOut | UIViewAnimationOptionBeginFromCurrentState
                animations:^{
                    self.toastView.alpha = 1.0;
                    self.toastView.maskView.alpha = 1.0;
                    self.toastView.backgroundView.alpha = 1.0;
                    self.toastView.contentView.alpha = 1.0;
                }
                completion:^(BOOL finished) {
                    self.isAnimating = NO;
                    if (completion) {
                        completion(finished);
                    }
                }];
        } break;

        case HDToastAnimationTypeZoom: {
            self.toastView.backgroundView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0);
            self.toastView.contentView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0);

            [UIView animateWithDuration:self.duration
                delay:0.0
                options:HDViewAnimationOptionsCurveOut | UIViewAnimationOptionBeginFromCurrentState
                animations:^{
                    self.toastView.alpha = 1.0;
                    self.toastView.maskView.alpha = 1.0;
                    self.toastView.backgroundView.alpha = 1.0;
                    self.toastView.contentView.alpha = 1.0;

                    self.toastView.backgroundView.layer.transform = CATransform3DIdentity;
                    self.toastView.contentView.layer.transform = CATransform3DIdentity;
                }
                completion:^(BOOL finished) {
                    self.isAnimating = NO;
                    if (completion) {
                        completion(finished);
                    }
                }];
        } break;

        case HDToastAnimationTypeSlide: {
            self.toastView.backgroundView.layer.transform = CATransform3DMakeTranslation(0, -50, 0);
            self.toastView.contentView.layer.transform = CATransform3DMakeTranslation(0, -50, 0);
            [UIView animateWithDuration:self.duration
                delay:0.0
                options:HDViewAnimationOptionsCurveOut | UIViewAnimationOptionBeginFromCurrentState
                animations:^{
                    self.toastView.alpha = 1.0;
                    self.toastView.maskView.alpha = 1.0;
                    self.toastView.backgroundView.alpha = 1.0;
                    self.toastView.contentView.alpha = 1.0;

                    self.toastView.backgroundView.layer.transform = CATransform3DIdentity;
                    self.toastView.contentView.layer.transform = CATransform3DIdentity;
                }
                completion:^(BOOL finished) {
                    self.isAnimating = NO;
                    if (completion) {
                        completion(finished);
                    }
                }];
        } break;

        default: {
            self.isAnimating = NO;
            if (completion) {
                completion(true);
            }
        } break;
    }
}

- (void)hideWithCompletion:(void (^)(BOOL finished))completion {
    self.isShowing = NO;
    self.isAnimating = YES;

    // 解决消失时图片位置不正确问题
    HDToastContentView *contentView = (HDToastContentView *)self.toastView.contentView;
    if ([contentView isKindOfClass:HDToastContentView.class]) {
        [contentView.customView removeFromSuperview];
    }

    switch (self.animationType) {
        case HDToastAnimationTypeFade: {
            [UIView animateWithDuration:self.duration
                delay:0.0
                options:HDViewAnimationOptionsCurveOut | UIViewAnimationOptionBeginFromCurrentState
                animations:^{
                    self.toastView.alpha = 0.0;
                    self.toastView.maskView.alpha = 0.0;
                    self.toastView.backgroundView.alpha = 0.0;
                    self.toastView.contentView.alpha = 0.0;
                }
                completion:^(BOOL finished) {
                    self.isAnimating = NO;
                    if (completion) {
                        completion(finished);
                    }
                }];
        } break;

        case HDToastAnimationTypeZoom: {
            [UIView animateWithDuration:self.duration
                delay:0.0
                options:HDViewAnimationOptionsCurveOut | UIViewAnimationOptionBeginFromCurrentState
                animations:^{
                    self.toastView.alpha = 0.0;
                    self.toastView.maskView.alpha = 0.0;
                    self.toastView.backgroundView.alpha = 0.0;
                    self.toastView.contentView.alpha = 0.0;

                    self.toastView.backgroundView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0);
                    self.toastView.contentView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0);
                }
                completion:^(BOOL finished) {
                    self.isAnimating = NO;
                    if (completion) {
                        completion(finished);
                    }
                }];
        } break;

        case HDToastAnimationTypeSlide: {
            [UIView animateWithDuration:self.duration
                delay:0.0
                options:HDViewAnimationOptionsCurveOut | UIViewAnimationOptionBeginFromCurrentState
                animations:^{
                    self.toastView.alpha = 0.0;
                    self.toastView.maskView.alpha = 0.0;
                    self.toastView.backgroundView.alpha = 0.0;
                    self.toastView.contentView.alpha = 0.0;

                    self.toastView.backgroundView.layer.transform = CATransform3DMakeTranslation(0, 50, 0);
                    self.toastView.contentView.layer.transform = CATransform3DMakeTranslation(0, 50, 0);
                }
                completion:^(BOOL finished) {
                    self.isAnimating = NO;
                    self.toastView.backgroundView.layer.transform = CATransform3DIdentity;
                    self.toastView.contentView.layer.transform = CATransform3DIdentity;
                    if (completion) {
                        completion(finished);
                    }
                }];
        } break;

        default: {
            self.isAnimating = NO;
            if (completion) {
                completion(true);
            }
        } break;
    }
}

- (BOOL)isShowing {
    return self.isShowing;
}

- (BOOL)isAnimating {
    return self.isAnimating;
}
@end
