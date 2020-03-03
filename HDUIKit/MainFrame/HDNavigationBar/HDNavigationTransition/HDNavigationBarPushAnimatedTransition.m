//
//  HDNavigationBarPushAnimatedTransition.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarPushAnimatedTransition.h"

@implementation HDNavigationBarPushAnimatedTransition

- (void)animateTransition {
    // 解决UITabbarController左滑push时的显示问题
    BOOL isHideTabBar = self.fromViewController.tabBarController && self.toViewController.hidesBottomBarWhenPushed;

    __block UIView *fromView = nil;
    if (isHideTabBar) {
        // 获取fromViewController的截图
        UIImage *captureImage = [self getCaptureWithView:self.fromViewController.view.window];
        UIImageView *captureView = [[UIImageView alloc] initWithImage:captureImage];
        captureView.frame = CGRectMake(0, 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight);
        [self.containerView addSubview:captureView];
        fromView = captureView;
        self.fromViewController.hd_captureImage = captureImage;
        self.fromViewController.view.hidden = YES;
        self.fromViewController.tabBarController.tabBar.hidden = YES;
    } else {
        fromView = self.fromViewController.view;
    }
    [self.containerView addSubview:self.toViewController.view];

    if (self.isScale) {
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight)];
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [fromView addSubview:self.shadowView];
    }

    // 设置toViewController
    self.toViewController.view.frame = CGRectMake(HDNavigationBarScreenWidth, 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight);
    self.toViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.toViewController.view.layer.shadowOpacity = 0.6f;
    self.toViewController.view.layer.shadowRadius = 8.0f;

    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
        animations:^{
            if (self.isScale) {
                self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
                if (HDNavigationBarDeviceVersion >= 11.0f) {
                    CGRect frame = fromView.frame;
                    frame.origin.x = HDNavConfigure.hd_translationX;
                    frame.origin.y = HDNavConfigure.hd_translationY;
                    frame.size.height -= 2 * HDNavConfigure.hd_translationY;
                    fromView.frame = frame;
                } else {
                    fromView.transform = CGAffineTransformMakeScale(HDNavConfigure.hd_scaleX, HDNavConfigure.hd_scaleY);
                }
            } else {
                fromView.frame = CGRectMake(-(0.3 * HDNavigationBarScreenWidth), 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight);
            }

            self.toViewController.view.frame = CGRectMake(0, 0, HDNavigationBarScreenWidth, HDNavigationBarScreenHeight);
        }
        completion:^(BOOL finished) {
            [self completeTransition];
            if (isHideTabBar) {
                [fromView removeFromSuperview];
                fromView = nil;

                self.fromViewController.view.hidden = NO;
                if (self.fromViewController.navigationController.childViewControllers.count == 1) {
                    self.fromViewController.tabBarController.tabBar.hidden = NO;
                }
            }
            if (self.isScale) {
                [self.shadowView removeFromSuperview];
            }
        }];
}

@end
