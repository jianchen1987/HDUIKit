//
//  UINavigationController+Extension.h
//  HDUIKit
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Extension)

/**
 判断指定 class 是否存在

@param class  指定 class
*/
- (BOOL)isDestViewControllerClassExists:(Class)class;

/**
 pop 到指定 class

 @param class  指定 class
 */
- (BOOL)popToViewControllerClass:(Class)class;

- (BOOL)popToViewControllerClass:(Class)class animated:(BOOL)animated;

/**
 从导航控制器中删除指定的控制器
 
 @param specificClass 指定控制器 类名
 @param isOnlyOnce 是否只删一个，因为栈里可能 push 多个同类控制器
 */
- (void)removeSpecificViewControllerClass:(Class)specificClass onlyOnce:(BOOL)isOnlyOnce;

/// 不连续push 同一类型的控制器
/// @param viewController 待 push 的控制器
/// @param animated 是否动画
- (void)pushViewControllerDiscontinuous:(UIViewController *)viewController animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
