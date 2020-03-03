//
//  HDToastAnimator.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDToastView;

/**
 * `HDToastAnimatorDelegate`是所有`HDToastAnimator`或者其子类必须遵循的协议，是整个动画过程实现的地方。
 */
@protocol HDToastAnimatorDelegate <NSObject>

@required

- (void)showWithCompletion:(void (^)(BOOL finished))completion;
- (void)hideWithCompletion:(void (^)(BOOL finished))completion;
- (BOOL)isShowing;
- (BOOL)isAnimating;
@end

/// 动画类型
typedef NS_ENUM(NSInteger, HDToastAnimationType) {
    HDToastAnimationTypeFade = 0,
    HDToastAnimationTypeZoom,
    HDToastAnimationTypeSlide
};

/**
 * `HDToastAnimator`可以让你通过实现一些协议来自定义ToastView显示和隐藏的动画。你可以继承`HDToastAnimator`，然后实现`HDToastAnimatorDelegate`中的方法，即可实现自定义的动画。HDToastAnimator默认也提供了几种type的动画：1、HDToastAnimationTypeFade；2、HDToastAnimationTypeZoom；3、HDToastAnimationTypeSlide；
 */
@interface HDToastAnimator : NSObject <HDToastAnimatorDelegate>

/**
 * 初始化方法，请务必使用这个方法来初始化。
 *
 * @param toastView 要使用这个animator的HDToastView实例。
 */
- (instancetype)initWithToastView:(HDToastView *)toastView NS_DESIGNATED_INITIALIZER;

/**
 * 获取初始化传进来的HDToastView。
 */
@property (nonatomic, weak, readonly) HDToastView *toastView;

/**
 * 指定HDToastAnimator做动画的类型type。此功能暂时未实现，目前所有动画类型都是HDToastAnimationTypeFade。
 */
@property (nonatomic, assign) HDToastAnimationType animationType;

/// 动画时长，默认0.25
@property (nonatomic, assign) NSTimeInterval duration;

@end
