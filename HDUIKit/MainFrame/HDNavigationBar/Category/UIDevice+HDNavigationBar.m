//
//  UIDevice+HDNavigationBar.m
//  HDUIKit
//
//  Created by Tia on 2022/9/30.
//

#import "UIDevice+HDNavigationBar.h"

@implementation UIDevice (HDNavigationBar)
/// 判断是否是刘海屏
+ (BOOL)hd_navigationBarIsNotchedScreen{
    return [UIDevice hd_safeDistanceTop] > 0;
}
/// 顶部安全区高度
+ (CGFloat)hd_safeDistanceTop {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.top;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 底部安全区高度
+ (CGFloat)hd_safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}


/// 顶部状态栏高度（包括安全区）
+ (CGFloat)hd_statusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

/// 导航栏高度
+ (CGFloat)hd_navigationBarHeight {
    return 44.0f;
}

/// 状态栏+导航栏的高度
+ (CGFloat)hd_navigationFullHeight {
    return [UIDevice hd_statusBarHeight] + [UIDevice hd_navigationBarHeight];
}

/// 底部导航栏高度
+ (CGFloat)hd_tabBarHeight {
    return 49.0f;
}

/// 底部导航栏高度（包括安全区）
+ (CGFloat)hd_tabBarFullHeight {
    return [UIDevice hd_statusBarHeight] + [UIDevice hd_safeDistanceBottom];
}

@end
