//
//  HDNavigationBarConfigure.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarDefine.h"
#import <UIKit/UIKit.h>

// 配置类宏定义
#define HDNavConfigure [HDNavigationBarConfigure sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface HDNavigationBarConfigure : NSObject

/// 导航栏背景色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 导航栏标题颜色
@property (nonatomic, strong) UIColor *titleColor;

/// 导航栏标题字体
@property (nonatomic, strong) UIFont *titleFont;

/// 返回按钮样式
@property (nonatomic, strong) UIImage *backButtonImage;

/// 是否禁止导航栏左右item间距调整，默认是NO
@property (nonatomic, assign) BOOL hd_disableFixSpace;

/// 导航栏左侧按钮距屏幕左边间距，默认是12，可自行调整
@property (nonatomic, assign) CGFloat hd_navItemLeftSpace;

/// 导航栏右侧按钮距屏幕右边间距，默认是12，可自行调整
@property (nonatomic, assign) CGFloat hd_navItemRightSpace;

/// 是否隐藏状态栏，默认NO
@property (nonatomic, assign) BOOL statusBarHidden;

/// 状态栏类型，默认UIStatusBarStyleDefault
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/// 左滑push过渡临界值，默认0.3，大于此值完成push操作
@property (nonatomic, assign) CGFloat hd_pushTransitionCriticalValue;

/// 右滑pop过渡临界值，默认0.5，大于此值完成pop操作
@property (nonatomic, assign) CGFloat hd_popTransitionCriticalValue;

// 以下属性需要设置导航栏转场缩放为YES
/// 手机系统大于11.0，使用下面的值控制x、y轴的位移距离，默认（5，5）
@property (nonatomic, assign) CGFloat hd_translationX;
@property (nonatomic, assign) CGFloat hd_translationY;

/// 手机系统小于11.0，使用下面的值控制x、y周的缩放程度，默认（0.95，0.97）
@property (nonatomic, assign) CGFloat hd_scaleX;
@property (nonatomic, assign) CGFloat hd_scaleY;

/// 导航栏左右间距，内部使用
@property (nonatomic, assign, readonly) CGFloat navItemLeftSpace;
@property (nonatomic, assign, readonly) CGFloat navItemRightSpace;

/// 单例，设置一次全局使用
+ (instancetype)sharedInstance;

/// 设置默认配置
- (void)setupDefaultConfigure;

/// 设置自定义配置，此方法只需调用一次
/// @param block 配置回调
- (void)setupCustomConfigure:(void (^)(HDNavigationBarConfigure *configure))block;

/// 更新配置
/// @param block 配置回调
- (void)updateConfigure:(void (^)(HDNavigationBarConfigure *configure))block;

#pragma mark - 内部方法

/// 获取当前item修复间距
- (CGFloat)hd_fixedSpace;

@end

NS_ASSUME_NONNULL_END
