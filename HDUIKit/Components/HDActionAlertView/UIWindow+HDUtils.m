//
//  UIWindow+HDUtils.m
//  ViPay
//
//  Created by VanJay on 2019/7/31.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "UIWindow+HDUtils.h"

@implementation UIWindow (HDUtils)

- (UIViewController *)currentViewController {
    UIViewController *viewController = self.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

#ifdef __IPHONE_7_0

- (UIViewController *)viewControllerForStatusBarStyle {
    UIViewController *currentViewController = [self currentViewController];

    while ([currentViewController childViewControllerForStatusBarStyle]) {
        currentViewController = [currentViewController childViewControllerForStatusBarStyle];
    }
    return currentViewController;
}

- (UIViewController *)viewControllerForStatusBarHidden {
    UIViewController *currentViewController = [self currentViewController];

    while ([currentViewController childViewControllerForStatusBarHidden]) {
        currentViewController = [currentViewController childViewControllerForStatusBarHidden];
    }
    return currentViewController;
}

#endif

@end
