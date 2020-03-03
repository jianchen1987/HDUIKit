//
//  UINavigationController+HDNavigationBar.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (HDNavigationBar)

/// 创建导航控制器并开启手势控制（无缩放）
/// @param rootVC 根控制器
+ (instancetype)rootVC:(UIViewController *)rootVC;

/// 创建导航控制器并开启手势控制
/// @param rootVC 根控制器
/// @param transitionScale 是否缩放
+ (instancetype)rootVC:(UIViewController *)rootVC transitionScale:(BOOL)transitionScale;

/// 导航栏转场时是否缩放，此属性只能在初始化导航栏时有效
@property (nonatomic, assign, readonly) BOOL hd_transitionScale;

/// 是否开启左滑push操作，默认是NO，此时不可禁用控制器的滑动返回手势
@property (nonatomic, assign) BOOL hd_openScrollLeftPush;

/// 是否开启HDNavigationBar的手势处理，默认为NO
/// 只能通过上面的两个初始化方法开启
@property (nonatomic, assign, readonly) BOOL hd_openGestureHandle;

@end

NS_ASSUME_NONNULL_END
