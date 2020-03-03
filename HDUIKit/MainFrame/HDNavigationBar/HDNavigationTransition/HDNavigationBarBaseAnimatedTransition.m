//
//  HDNavigationBarBaseAnimatedTransition.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarBaseAnimatedTransition.h"

@implementation HDNavigationBarBaseAnimatedTransition

+ (instancetype)transitionWithScale:(BOOL)isScale {
    return [[self alloc] initWithScale:isScale];
}

- (instancetype)initWithScale:(BOOL)isScale {
    if (self = [super init]) {
        self.isScale = isScale;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
// 转场动画需要的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return UINavigationControllerHideShowBarDuration;
}

// 转场动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 获取容器
    UIView *containerView = [transitionContext containerView];

    // 获取转场前后的控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    self.containerView = containerView;
    self.fromViewController = fromVC;
    self.toViewController = toVC;
    self.transitionContext = transitionContext;

    // 开始动画
    [self animateTransition];
}

// 子类实现
- (void)animateTransition {
}

- (void)completeTransition {
    [self.transitionContext completeTransition:!self.transitionContext.transitionWasCancelled];
}

- (UIImage *)getCaptureWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIViewController (HDCapture)

static char kAssociatedObjectKey_captureImage;
- (void)setHd_captureImage:(UIImage *)hd_captureImage {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_captureImage, hd_captureImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)hd_captureImage {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_captureImage);
}

@end
