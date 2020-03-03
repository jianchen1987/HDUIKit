//
//  UINavigationController+HD.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "UINavigationController+HDUIKit.h"

@implementation UINavigationController (HDUIKit)
- (nullable UIViewController *)hd_rootViewController {
    return self.viewControllers.firstObject;
}
@end
