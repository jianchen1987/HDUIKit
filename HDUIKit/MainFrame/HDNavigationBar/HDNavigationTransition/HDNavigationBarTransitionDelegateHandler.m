//
//  HDNavigationBarTransitionDelegateHandler.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarTransitionDelegateHandler.h"
#import "UINavigationController+HDNavigationBar.h"
#import "UIViewController+HDNavigationBar.h"

@interface HDNavigationControllerDelegateHandler ()

/// 是否是push操作
@property (nonatomic, assign) BOOL isGesturePush;

/// push动画
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *pushTransition;

/// pop动画
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *popTransition;

@end

@implementation HDNavigationControllerDelegateHandler

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (self.navigationController.hd_transitionScale || (self.navigationController.hd_openScrollLeftPush && self.pushTransition)) {
        if (operation == UINavigationControllerOperationPush) {
            return [HDNavigationBarPushAnimatedTransition transitionWithScale:self.navigationController.hd_transitionScale];
        } else if (operation == UINavigationControllerOperationPop) {
            return [HDNavigationBarPopAnimatedTransition transitionWithScale:self.navigationController.hd_transitionScale];
        }
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.navigationController.hd_transitionScale || (self.navigationController.hd_openScrollLeftPush && self.pushTransition)) {
        if ([animationController isKindOfClass:[HDNavigationBarPushAnimatedTransition class]]) {
            return self.pushTransition;
        } else if ([animationController isKindOfClass:[HDNavigationBarPopAnimatedTransition class]]) {
            return self.popTransition;
        }
    }
    return nil;
}

#pragma mark - 滑动手势处理
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    UIViewController *visibleVC = self.navigationController.visibleViewController;

    // 进度
    CGFloat progress = [gesture translationInView:gesture.view].x / gesture.view.bounds.size.width;
    CGPoint velocity = [gesture velocityInView:gesture.view];

    // 在手势开始的时候判断是push操作还是pop操作
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.isGesturePush = velocity.x < 0 ? YES : NO;
    }

    // push时progess < 0 需要做处理
    if (self.isGesturePush) {
        progress = -progress;
    }

    progress = MIN(1.0f, MAX(0.0f, progress));

    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.isGesturePush) {  // push
            if (self.navigationController.hd_openScrollLeftPush) {
                if (visibleVC.hd_pushDelegate && [visibleVC.hd_pushDelegate respondsToSelector:@selector(pushToNextViewController)]) {
                    self.pushTransition = [UIPercentDrivenInteractiveTransition new];
                    self.pushTransition.completionCurve = UIViewAnimationCurveEaseOut;
                    [self.pushTransition updateInteractiveTransition:0];

                    [visibleVC.hd_pushDelegate pushToNextViewController];
                }
            }
        } else {  // pop
            if (visibleVC.hd_popDelegate) {
                if ([visibleVC.hd_popDelegate respondsToSelector:@selector(viewControllerPopScrollBegan)]) {
                    [visibleVC.hd_popDelegate viewControllerPopScrollBegan];
                }
            } else {
                self.popTransition = [UIPercentDrivenInteractiveTransition new];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.isGesturePush) {
            if (self.pushTransition) {
                [self.pushTransition updateInteractiveTransition:progress];
            }
        } else {
            if (visibleVC.hd_popDelegate) {
                if ([visibleVC.hd_popDelegate respondsToSelector:@selector(viewControllerPopScrollUpdate:)]) {
                    [visibleVC.hd_popDelegate viewControllerPopScrollUpdate:progress];
                }
            } else {
                [self.popTransition updateInteractiveTransition:progress];
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (self.isGesturePush) {
            if (self.pushTransition) {
                if (progress > HDNavConfigure.hd_pushTransitionCriticalValue) {
                    [self.pushTransition finishInteractiveTransition];
                } else {
                    [self.pushTransition cancelInteractiveTransition];
                }
            }
        } else {
            if (visibleVC.hd_popDelegate) {
                if ([visibleVC.hd_popDelegate respondsToSelector:@selector(viewControllerPopScrollEnded)]) {
                    [visibleVC.hd_popDelegate viewControllerPopScrollEnded];
                }
            } else {
                if (progress > HDNavConfigure.hd_popTransitionCriticalValue) {
                    [self.popTransition finishInteractiveTransition];
                } else {
                    [self.popTransition cancelInteractiveTransition];
                }
            }
        }
        self.pushTransition = nil;
        self.popTransition = nil;
        self.isGesturePush = NO;
    }
}

@end

@implementation HDGestureRecognizerDelegateHandler

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIViewController *visibleVC = self.navigationController.visibleViewController;

    if (self.navigationController.hd_openScrollLeftPush) {
        // 开启了左滑push功能
    } else if (visibleVC.hd_popDelegate) {
        // 设置了hd_popDelegate
    } else {
        // 忽略根控制器
        if (self.navigationController.viewControllers.count <= 1) return NO;
    }

    // 忽略禁用手势
    if (visibleVC.hd_interactivePopDisabled) return NO;

    CGPoint transition = [gestureRecognizer translationInView:gestureRecognizer.view];

    SEL action = NSSelectorFromString(@"handleNavigationTransition:");

    if (transition.x < 0) {  // 左滑处理
        // 开启了左滑push并设置了代理
        if (self.navigationController.hd_openScrollLeftPush && visibleVC.hd_pushDelegate) {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        } else {
            return NO;
        }
    } else {  // 右滑处理
        // 解决根控制器右滑时出现的卡死情况
        if (visibleVC.hd_popDelegate) {
            // 实现了hd_popDelegate，不作处理
        } else {
            if (self.navigationController.viewControllers.count <= 1) return NO;
        }

        // 全屏滑动时起作用
        if (!visibleVC.hd_fullScreenPopDisabled) {
            // 上下滑动
            if (transition.x == 0) return NO;
        }

        // 忽略超出手势区域
        CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
        CGFloat maxAllowDistance = visibleVC.hd_maxPopDistance;

        if (maxAllowDistance > 0 && beginningLocation.x > maxAllowDistance) {
            return NO;
        } else if (visibleVC.hd_popDelegate) {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        } else if (!self.navigationController.hd_transitionScale) {  // 非缩放，系统处理
            [gestureRecognizer removeTarget:self.customTarget action:@selector(panGestureAction:)];
            [gestureRecognizer addTarget:self.systemTarget action:action];
        } else {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        }
    }

    // 忽略导航控制器正在做转场动画
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) return NO;

    return YES;
}

@end
