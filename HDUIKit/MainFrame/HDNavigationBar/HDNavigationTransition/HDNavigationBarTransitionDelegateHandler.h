//
//  HDNavigationBarTransitionDelegateHandler.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarPopAnimatedTransition.h"
#import "HDNavigationBarPushAnimatedTransition.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDNavigationControllerDelegateHandler : NSObject <UINavigationControllerDelegate>

/// 当前处理的导航控制器
@property (nonatomic, weak) UINavigationController *navigationController;

/// 手势处理
/// @param gesture 手势
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture;

@end

@interface HDGestureRecognizerDelegateHandler : NSObject <UIGestureRecognizerDelegate>

/// 当前处理的导航控制器
@property (nonatomic, weak) UINavigationController *navigationController;

/// 系统返回手势的target
@property (nonatomic, weak) id systemTarget;

/// 自定义返回手势的target
@property (nonatomic, weak) HDNavigationControllerDelegateHandler *customTarget;

@end

NS_ASSUME_NONNULL_END
