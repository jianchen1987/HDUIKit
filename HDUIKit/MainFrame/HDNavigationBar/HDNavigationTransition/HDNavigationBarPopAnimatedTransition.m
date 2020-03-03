//
//  HDNavigationBarPopAnimatedTransition.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarPopAnimatedTransition.h"

@implementation HDNavigationBarPopAnimatedTransition

- (void)animateTransition {
    [self.containerView insertSubview:self.toViewController.view belowSubview:self.fromViewController.view];

    // 是否隐藏tabBar
    BOOL isHideTabBar = self.toViewController.tabBarController && self.fromViewController.hidesBottomBarWhenPushed && self.toViewController.hd_captureImage;

    __block UIView *toView = nil;
    if (isHideTabBar) {
        UIImageView *captureView = [[UIImageView alloc] initWithImage:self.toViewController.hd_captureImage];
        captureView.frame = CGRectMake(0, 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight);
        [self.containerView insertSubview:captureView belowSubview:self.fromViewController.view];
        toView = captureView;
        self.toViewController.view.hidden = YES;
        self.toViewController.tabBarController.tabBar.hidden = YES;
    } else {
        toView = self.toViewController.view;
    }

    if (self.isScale) {
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight)];
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [toView addSubview:self.shadowView];

        if (HDNavigationBarDeviceVersion >= 11.0f) {
            CGRect frame = toView.frame;
            frame.origin.x = HDNavConfigure.hd_translationX;
            frame.origin.y = HDNavConfigure.hd_translationY;
            frame.size.height -= 2 * HDNavConfigure.hd_translationY;
            toView.frame = frame;
        } else {
            toView.transform = CGAffineTransformMakeScale(HDNavConfigure.hd_scaleX, HDNavConfigure.hd_scaleY);
        }
    } else {
        self.fromViewController.view.frame = CGRectMake(-(0.3 * HDNavigationBarScreenWidth), 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight);
    }

    self.fromViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.fromViewController.view.layer.shadowOpacity = 0.5f;
    self.fromViewController.view.layer.shadowRadius = 8.0f;

    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
        animations:^{
            self.fromViewController.view.frame = CGRectMake(HDNavigationBarScreenWidth, 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight);
            if (self.isScale) {
                self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            }
            if (HDNavigationBarDeviceVersion >= 11.0f) {
                toView.frame = CGRectMake(0, 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight);
            } else {
                toView.transform = CGAffineTransformIdentity;
            }
        }
        completion:^(BOOL finished) {
            [self completeTransition];
            if (isHideTabBar) {
                [toView removeFromSuperview];
                toView = nil;

                self.toViewController.view.hidden = NO;
                if (self.toViewController.navigationController.childViewControllers.count == 1) {
                    self.toViewController.tabBarController.tabBar.hidden = NO;
                }
            }
            if (self.isScale) {
                [self.shadowView removeFromSuperview];
            }
        }];
}

@end
