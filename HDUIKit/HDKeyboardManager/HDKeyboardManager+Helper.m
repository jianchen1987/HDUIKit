//
//  HDKeyboardManager+Helper.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDKeyboardManager+Helper.h"
#import <objc/runtime.h>

@implementation UIView (HD_Keyboard_Hierarchy)

- (UIViewController *)viewContainingController {
    UIResponder *nextResponder = self;
    do {
        nextResponder = [nextResponder nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController *)nextResponder;

    } while (nextResponder);

    return nil;
}

- (UISearchBar *)textFieldSearchBar {
    UIResponder *searchBar = [self nextResponder];

    while (searchBar) {
        if ([searchBar isKindOfClass:[UISearchBar class]]) {
            return (UISearchBar *)searchBar;
        } else if ([searchBar isKindOfClass:[UIViewController class]]) {
            break;
        }
        searchBar = [searchBar nextResponder];
    }

    return nil;
}
@end

@implementation UIView (HD_Keyboard_Additions)

- (void)setShouldResignOnTouchOutsideMode:(HDKMEnableMode)shouldResignOnTouchOutsideMode {
    objc_setAssociatedObject(self, @selector(shouldResignOnTouchOutsideMode), @(shouldResignOnTouchOutsideMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HDKMEnableMode)shouldResignOnTouchOutsideMode {
    NSNumber *shouldResignOnTouchOutsideMode = objc_getAssociatedObject(self, @selector(shouldResignOnTouchOutsideMode));

    return [shouldResignOnTouchOutsideMode unsignedIntegerValue];
}

@end
