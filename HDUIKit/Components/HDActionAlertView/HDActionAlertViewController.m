//
//  HDActionAlertViewController.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertViewController.h"
#import "UIWindow+HDUtils.h"

@interface HDActionAlertViewController ()

@end

@implementation HDActionAlertViewController

#pragma mark - life cycle

- (void)loadView {
    self.view = self.alertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.alertView setup];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.alertView resetTransition];
    [self.alertView invalidateLayout];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotate];
    }
    return YES;
}
@end
