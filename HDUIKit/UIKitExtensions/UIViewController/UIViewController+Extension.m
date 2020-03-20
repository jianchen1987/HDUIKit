//
//  UIViewController+Extension.m
//  HDUIKit
//
//  Created by 谢 on 2019/1/9.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)
+ (instancetype)viewFromXIB {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]
        lastObject];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^__nullable)(void))completion {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animated completion:completion];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
        if (completion) {
            completion();
        }
    }
}

- (BOOL)isDisplaying {
    return self.isViewLoaded && self.view.window;
}

- (BOOL)isLastVCInNavController {
    if (!self.navigationController) return false;

    return self.navigationController.viewControllers.lastObject == self;
}
@end
