//
//  UIViewController+HDNavigationBar.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCustomNavigationBar.h"
#import "HDNavigationBarConfigure.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const HDViewControllerPropertyChangedNotification;

// 左滑push代理
@protocol HDViewControllerPushDelegate <NSObject>

- (void)pushToNextViewController;

@end

// 右滑pop代理
@protocol HDViewControllerPopDelegate <NSObject>

@optional
- (void)viewControllerPopScrollBegan;
- (void)viewControllerPopScrollUpdate:(float)progress;
- (void)viewControllerPopScrollEnded;

@end

@interface UIViewController (HDNavigationBarCategory)

/// 是否禁止当前控制器的滑动返回（包括全屏滑动返回和边缘滑动返回）
@property (nonatomic, assign) BOOL hd_interactivePopDisabled;

/// 是否禁止当前控制器的全屏滑动返回
@property (nonatomic, assign) BOOL hd_fullScreenPopDisabled;

/// 全屏滑动时，滑动区域距离屏幕左侧的最大位置，默认是0：表示全屏可滑动
@property (nonatomic, assign) CGFloat hd_maxPopDistance;

/// 设置导航栏透明度
@property (nonatomic, assign) CGFloat hd_navBarAlpha;

/// 设置状态栏是否隐藏，默认NO：不隐藏
@property (nonatomic, assign) BOOL hd_statusBarHidden;

/// 设置导航栏类型
@property (nonatomic, assign) UIStatusBarStyle hd_statusBarStyle;

/// 返回按钮图片
@property (nonatomic, strong) UIImage *hd_backButtonImage;

/// 左滑push代理
@property (nonatomic, weak) id<HDViewControllerPushDelegate> hd_pushDelegate;

/// 右滑pop代理，如果设置了hd_popDelegate，原来的滑动返回手势将失效
@property (nonatomic, weak) id<HDViewControllerPopDelegate> hd_popDelegate;

/// 返回按钮点击方法
/// @param sender sender
- (void)hd_backItemClick:(id)sender;

@end

@interface UIViewController (HDNavigationBar)

@property (nonatomic, strong) HDCustomNavigationBar *hd_navigationBar;

@property (nonatomic, strong) UINavigationItem *hd_navigationItem;

/// 是否创建了hd_navigationBar
/// 返回YES表面当前控制器使用了自定义的hd_navigationBar，默认为NO
@property (nonatomic, assign) BOOL hd_NavBarInit;

#pragma mark - 常用属性快速设置
@property (nonatomic, strong) UIColor *hd_navBackgroundColor;
@property (nonatomic, strong) UIImage *hd_navBackgroundImage;

@property (nonatomic, strong) UIColor *hd_navShadowColor;
@property (nonatomic, strong) UIImage *hd_navShadowImage;
@property (nonatomic, assign) BOOL hd_navLineHidden;

@property (nullable, nonatomic, strong) UIView *hd_navTitleView;
@property (nonatomic, strong) UIColor *hd_navTitleColor;
@property (nonatomic, strong) UIFont *hd_navTitleFont;

@property (nullable, nonatomic, strong) UIBarButtonItem *hd_navLeftBarButtonItem;
@property (nullable, nonatomic, strong) NSArray<UIBarButtonItem *> *hd_navLeftBarButtonItems;
@property (nullable, nonatomic, strong) UIBarButtonItem *hd_navRightBarButtonItem;
@property (nullable, nonatomic, strong) NSArray<UIBarButtonItem *> *hd_navRightBarButtonItems;

@property (nonatomic, assign) CGFloat hd_navItemLeftSpace;
@property (nonatomic, assign) CGFloat hd_navItemRightSpace;

/// 显示导航栏分割线
- (void)showNavLine;

/// 隐藏导航栏分割线
- (void)hideNavLine;

/// 刷新导航栏frame
- (void)refreshNavBarFrame;

/// 获取当前controller里的最高层可见的viewController
- (nullable UIViewController *)hd_visibleViewControllerIfExist;

@end

NS_ASSUME_NONNULL_END
