//
//  UINavigationController+Extension.m
//  HDUIKit
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

- (BOOL)isDestViewControllerClassExists:(Class)class {
    BOOL isExist = false;
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:class]) {
            isExist = true;
            break;
        }
    }
    return isExist;
}

- (BOOL)popToViewControllerClass:(Class)class {
    return [self popToViewControllerClass:class animated:true];
}

- (BOOL)popToViewControllerClass:(Class)class animated:(BOOL)animated {

    if (![self isDestViewControllerClassExists:class]) return false;

    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:class]) {

            [self popToViewController:controller animated:animated];
            return true;
        }
    }
    return true;
}

- (void)removeSpecificViewControllerClass:(Class)specificClass onlyOnce:(BOOL)isOnlyOnce {
    NSArray *viewControllers = self.viewControllers;
    NSMutableArray *newVCArray = [NSMutableArray arrayWithArray:viewControllers];

    for (short i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:specificClass]) {
            [newVCArray removeObject:vc];
            if (isOnlyOnce) {
                break;
            }
        }
    }
    self.viewControllers = [newVCArray copy];
}

- (void)pushViewControllerDiscontinuous:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count <= 0) {
        [self pushViewController:viewController animated:animated];
        return;
    }

    // 判断最后一个界面是不是要 push 的控制器同一类型
    UIViewController *lastVC = self.viewControllers.lastObject;
    if ([viewController isKindOfClass:lastVC.class]) {
        return;
    }

    [self pushViewController:viewController animated:animated];
}
@end
