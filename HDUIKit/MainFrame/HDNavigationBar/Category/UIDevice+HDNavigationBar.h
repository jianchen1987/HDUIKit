//
//  UIDevice+HDNavigationBar.h
//  HDUIKit
//
//  Created by Tia on 2022/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (HDNavigationBar)

// 判断是否是刘海屏
+ (BOOL)hd_navigationBarIsNotchedScreen;

/// 顶部安全区高度
+ (CGFloat)hd_safeDistanceTop;

/// 底部安全区高度
+ (CGFloat)hd_safeDistanceBottom;

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)hd_statusBarHeight;

/// 导航栏高度
+ (CGFloat)hd_navigationBarHeight;

/// 状态栏+导航栏的高度
+ (CGFloat)hd_navigationFullHeight;

/// 底部导航栏高度
+ (CGFloat)hd_tabBarHeight;

/// 底部导航栏高度（包括安全区）
+ (CGFloat)hd_tabBarFullHeight;

@end

NS_ASSUME_NONNULL_END
