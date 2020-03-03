//
//  UINavigationController+HD.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (HDUIKit)
/// 获取 rootViewController
@property (nullable, nonatomic, readonly) UIViewController *hd_rootViewController;
@end

NS_ASSUME_NONNULL_END
