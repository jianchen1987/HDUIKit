//
//  UIWindow+HDUtils.h
//  HDUIKit
//
//  Created by VanJay on 2019/7/31.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (HDUtils)

- (UIViewController *)currentViewController;

#ifdef __IPHONE_7_0
- (UIViewController *)viewControllerForStatusBarStyle;
- (UIViewController *)viewControllerForStatusBarHidden;
#endif

@end
