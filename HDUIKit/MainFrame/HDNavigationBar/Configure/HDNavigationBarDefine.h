//
//  HDNavigationBarDefine.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#ifndef HDNavigationBarDefine_h
#define HDNavigationBarDefine_h

#import <objc/runtime.h>

// 屏幕相关
#define HDNavigationBarScreenWidth [UIScreen mainScreen].bounds.size.width
#define HDNavigationBarScreenHeight [UIScreen mainScreen].bounds.size.height

// clang-format off
// 全面屏机型尺寸
// X、XS、11pro、12 mini、13 mini（375*812）
// XR、XS MAX、11、11 Pro Max(414,896)
// 12、12Pro、13、13 Pro、14(390,844)
// 12 Pro Max、13 Pro Max、14 Plus(428,926)
// 14 Pro(393,852)
// 14 Pro Max(430,932)
// 判断是否是刘海屏
#define HDNavigationBarIsNotchedScreen      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(428, 926),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(926, 428),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(390, 844),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(844, 390),[UIScreen mainScreen].bounds.size))\
||\
CGSizeEqualToSize(CGSizeMake(430, 932),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(932, 430),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(393, 852),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(852, 393),[UIScreen mainScreen].bounds.size)\
:\
NO)
// clang-format on

// 顶部安全区域高度
#define HDNavigationBarSafeAreaTop (HDNavigationBarIsNotchedScreen ? 24.0f : 0.0f)
// 底部安全区域高度

// 状态栏高度
#define HDNavigationBarStatusBarHeight (HDNavigationBarIsNotchedScreen ? 44.0f : 20.0f)
// 导航栏高度
#define HDNavigationBarNavBarHeight 44.0f
// 状态栏+导航栏高度
#define HD_STATUSBAR_NAVBAR_HEIGHT (HDNavigationBarStatusBarHeight + HDNavigationBarNavBarHeight)

// 设备版本号，只获取到第二级的版本号，例如 10.3.1 只会获取到10.3
#define HDNavigationBarDeviceVersion [UIDevice currentDevice].systemVersion.doubleValue

// 导航栏间距，用于不同控制器之间的间距
static const CGFloat HDNavigationBarItemSpace = -1;

// 使用static inline创建静态内联函数，方便调用，新方法默认自带前缀hd_
static inline void hd_swizzled_instanceMethod(Class oldClass, NSString *oldSelector, Class newClass) {
    NSString *newSelector = [NSString stringWithFormat:@"hd_%@", oldSelector];

    SEL originalSelector = NSSelectorFromString(oldSelector);
    SEL swizzledSelector = NSSelectorFromString(newSelector);

    Method originalMethod = class_getInstanceMethod(oldClass, NSSelectorFromString(oldSelector));
    Method swizzledMethod = class_getInstanceMethod(newClass, NSSelectorFromString(newSelector));

    BOOL isAdd = class_addMethod(oldClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isAdd) {
        class_replaceMethod(newClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#endif /* HDNavigationBarDefine_h */
