//
//  UIViewController+HDNavigationBar.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarTransitionDelegateHandler.h"
#import "UIBarButtonItem+HDNavigationBar.h"
#import "UIImage+HDNavigationBar.h"
#import "UIViewController+HDNavigationBar.h"

NSString *const HDViewControllerPropertyChangedNotification = @"HDViewControllerPropertyChangedNotification";

@implementation UIViewController (HDNavigationBarCategory)

- (void)setHd_interactivePopDisabled:(BOOL)hd_interactivePopDisabled {
    objc_setAssociatedObject(self, @selector(hd_interactivePopDisabled), @(hd_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self postPropertyChangeNotification];
}

- (BOOL)hd_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHd_fullScreenPopDisabled:(BOOL)hd_fullScreenPopDisabled {
    objc_setAssociatedObject(self, @selector(hd_fullScreenPopDisabled), @(hd_fullScreenPopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self postPropertyChangeNotification];
}

- (BOOL)hd_fullScreenPopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHd_maxPopDistance:(CGFloat)hd_maxPopDistance {
    objc_setAssociatedObject(self, @selector(hd_maxPopDistance), @(hd_maxPopDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self postPropertyChangeNotification];
}

- (CGFloat)hd_maxPopDistance {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setHd_navBarAlpha:(CGFloat)hd_navBarAlpha {
    objc_setAssociatedObject(self, @selector(hd_navBarAlpha), @(hd_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationBar.hd_navBarBackgroundAlpha = hd_navBarAlpha;
}

- (CGFloat)hd_navBarAlpha {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setHd_statusBarHidden:(BOOL)hd_statusBarHidden {
    objc_setAssociatedObject(self, @selector(hd_statusBarHidden), @(hd_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];

        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)hd_statusBarHidden {
    id hidden = objc_getAssociatedObject(self, _cmd);
    return (hidden != nil) ? [hidden boolValue] : HDNavConfigure.statusBarHidden;
}

- (void)setHd_hasManuallySetStatusBarStyle:(BOOL)hd_hasManuallySetStatusBarStyle {
    objc_setAssociatedObject(self, @selector(hd_hasManuallySetStatusBarStyle), @(hd_hasManuallySetStatusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hd_hasManuallySetStatusBarStyle {
    id hidden = objc_getAssociatedObject(self, _cmd);
    return (hidden != nil) ? [hidden boolValue] : NO;
}

- (void)setHd_statusBarStyle:(UIStatusBarStyle)hd_statusBarStyle {
    objc_setAssociatedObject(self, @selector(hd_statusBarStyle), @(hd_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_hasManuallySetStatusBarStyle = true;
    [UIApplication sharedApplication].statusBarStyle = [self hd_fixedStatusBarStyle:hd_statusBarStyle];
}

- (UIStatusBarStyle)hd_statusBarStyle {
    id style = objc_getAssociatedObject(self, _cmd);
    return (style != nil) ? [style integerValue] : HDNavConfigure.statusBarStyle;
}

- (void)setHd_backButtonImage:(UIImage *)hd_backButtonImage {

    objc_setAssociatedObject(self, @selector(hd_backButtonImage), hd_backButtonImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!self.presentingViewController && (self.navigationController.childViewControllers.count <= 1 && !self.shouldAddLeftNavItemOnFirstOfNavChildVCS)) return;

    if (self.hd_backButtonImage != nil && !self.hd_navigationItem.hidesBackButton) {
        if (self.hd_NavBarInit) {
            self.hd_navigationItem.leftBarButtonItem = [UIBarButtonItem hd_itemWithImage:self.hd_backButtonImage target:self action:@selector(hd_backItemClick:)];
        }
    } else {
        self.hd_navigationItem.leftBarButtonItem = nil;
    }
}

- (UIImage *)hd_backButtonImage {
    id image = objc_getAssociatedObject(self, _cmd);
    return (image != nil) ? image : HDNavConfigure.backButtonImage;
}

- (void)setHd_pushDelegate:(id<HDViewControllerPushDelegate>)hd_pushDelegate {
    objc_setAssociatedObject(self, @selector(hd_pushDelegate), hd_pushDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<HDViewControllerPushDelegate>)hd_pushDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_popDelegate:(id<HDViewControllerPopDelegate>)hd_popDelegate {
    objc_setAssociatedObject(self, @selector(hd_popDelegate), hd_popDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<HDViewControllerPopDelegate>)hd_popDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Private Methods
// 发送属性改变通知
- (void)postPropertyChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:HDViewControllerPropertyChangedNotification object:@{@"viewController": self}];
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    if (self.presentingViewController) {
        if (self.presentingViewController.presentedViewController == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // 判断有没有导航控制器
            UINavigationController *navigationController = self.navigationController;
            if (navigationController) {
                // 判断是不是只有一个
                if (navigationController.viewControllers.count <= 1) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [navigationController popViewControllerAnimated:YES];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - public methods
- (UIStatusBarStyle)hd_fixedStatusBarStyle:(UIStatusBarStyle)style {
    if (@available(iOS 13.0, *)) {
        if (style == UIStatusBarStyleDefault) {
            style = UIStatusBarStyleDarkContent;
        }
    }
    return style;
}

@end

@implementation UIViewController (HDNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray<NSString *> *oriSels = @[@"viewWillAppear:",
                                         @"viewDidAppear:",
                                         @"viewWillDisappear:",
                                         @"viewWillLayoutSubviews"];

        [oriSels enumerateObjectsUsingBlock:^(NSString *_Nonnull oriSel, NSUInteger idx, BOOL *_Nonnull stop) {
            hd_swizzled_instanceMethod(self, oriSel, self);
        }];
    });
}

- (void)hd_viewWillAppear:(BOOL)animated {
    if (self.hd_NavBarInit) {
        // 隐藏系统导航栏
        [self.navigationController setNavigationBarHidden:YES];

        // 将自定义导航栏放置顶层
        if (self.hd_navigationBar && !self.hd_navigationBar.hidden) {
            [self.view bringSubviewToFront:self.hd_navigationBar];
        }

        if (self.hd_navItemLeftSpace == HDNavigationBarItemSpace) {
            self.hd_navItemLeftSpace = HDNavConfigure.hd_navItemLeftSpace;
        }

        if (self.hd_navItemRightSpace == HDNavigationBarItemSpace) {
            self.hd_navItemRightSpace = HDNavConfigure.hd_navItemRightSpace;
        }

        if (self.hd_backButtonImage == nil) {
            self.hd_backButtonImage = HDNavConfigure.backButtonImage;
        }

        // 重置navItem_space
        [HDNavConfigure updateConfigure:^(HDNavigationBarConfigure *_Nonnull configure) {
            configure.hd_navItemLeftSpace = self.hd_navItemLeftSpace;
            configure.hd_navItemRightSpace = self.hd_navItemRightSpace;
        }];

        // 状态栏是否隐藏
        self.hd_navigationBar.hd_statusBarHidden = self.hd_statusBarHidden;
    }

    [self hd_viewWillAppear:animated];
}

- (void)hd_viewDidAppear:(BOOL)animated {
    // 每次视图出现是重新设置当前控制器的手势
    [[NSNotificationCenter defaultCenter] postNotificationName:HDViewControllerPropertyChangedNotification object:@{@"viewController": self}];

    [self hd_viewDidAppear:animated];
}

- (void)hd_viewWillDisappear:(BOOL)animated {
    [HDNavConfigure updateConfigure:^(HDNavigationBarConfigure *_Nonnull configure) {
        configure.hd_navItemLeftSpace = configure.navItemLeftSpace;
        configure.hd_navItemRightSpace = configure.navItemRightSpace;
    }];

    [self hd_viewWillDisappear:animated];
}

- (void)hd_viewWillLayoutSubviews {
    if (self.hd_NavBarInit) {
        [self setupNavBarFrame];
    }
    [self hd_viewWillLayoutSubviews];
}

#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden {
    return self.hd_statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.hd_statusBarStyle;
}

#pragma mark - 添加自定义导航栏
- (void)setHd_navigationBar:(HDCustomNavigationBar *)hd_navigationBar {
    objc_setAssociatedObject(self, @selector(hd_navigationBar), hd_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self setupNavBarFrame];
}

- (HDCustomNavigationBar *)hd_navigationBar {
    HDCustomNavigationBar *navigationBar = objc_getAssociatedObject(self, _cmd);
    if (!navigationBar) {
        navigationBar = [[HDCustomNavigationBar alloc] init];
        [self.view addSubview:navigationBar];

        self.hd_NavBarInit = YES;
        self.hd_navigationBar = navigationBar;

        // 设置默认导航栏间距
        self.hd_navItemLeftSpace = HDNavigationBarItemSpace;
        self.hd_navItemRightSpace = HDNavigationBarItemSpace;
    }
    return navigationBar;
}

- (void)setHd_navigationItem:(UINavigationItem *)hd_navigationItem {
    objc_setAssociatedObject(self, @selector(hd_navigationItem), hd_navigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationBar.items = @[hd_navigationItem];
}

- (UINavigationItem *)hd_navigationItem {
    UINavigationItem *navigationItem = objc_getAssociatedObject(self, _cmd);
    if (!navigationItem) {
        navigationItem = [[UINavigationItem alloc] init];
        self.hd_navigationItem = navigationItem;
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_NavBarInit:(BOOL)hd_NavBarInit {
    objc_setAssociatedObject(self, @selector(hd_NavBarInit), @(hd_NavBarInit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hd_NavBarInit {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (CGFloat)navigationBarHeight {
    return 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

#pragma mark - 常用属性快速设置
- (void)setHd_navBackgroundColor:(UIColor *)hd_navBackgroundColor {
    objc_setAssociatedObject(self, @selector(hd_navBackgroundColor), hd_navBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self.hd_navigationBar setBackgroundImage:[UIImage hd_imagePiexOneWithColor:hd_navBackgroundColor] forBarMetrics:UIBarMetricsDefault];
}

- (UIColor *)hd_navBackgroundColor {
    id objc = objc_getAssociatedObject(self, _cmd);
    return (objc != nil) ? objc : HDNavConfigure.backgroundColor;
}

- (void)setHd_navBackgroundImage:(UIImage *)hd_navBackgroundImage {
    objc_setAssociatedObject(self, @selector(hd_navBackgroundImage), hd_navBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self.hd_navigationBar setBackgroundImage:hd_navBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)hd_navBackgroundImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_navShadowColor:(UIColor *)hd_navShadowColor {
    objc_setAssociatedObject(self, @selector(hd_navShadowColor), hd_navShadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationBar.shadowImage = [UIImage hd_changeImage:[UIImage hd_imagePiexOneWithColor:UIColor.whiteColor] color:hd_navShadowColor];
}

- (UIColor *)hd_navShadowColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_navShadowImage:(UIImage *)hd_navShadowImage {
    objc_setAssociatedObject(self, @selector(hd_navShadowImage), hd_navShadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationBar.shadowImage = hd_navShadowImage;
}

- (UIImage *)hd_navShadowImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_navLineHidden:(BOOL)hd_navLineHidden {
    objc_setAssociatedObject(self, @selector(hd_navLineHidden), @(hd_navLineHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationBar.hd_navLineHidden = hd_navLineHidden;

    if (HDNavigationBarDeviceVersion >= 11.0f) {
        self.hd_navShadowImage = hd_navLineHidden ? [UIImage new] : self.hd_navShadowImage;
    }
    [self.hd_navigationBar layoutSubviews];
}

- (BOOL)hd_navLineHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHd_navTitleView:(UIView *)hd_navTitleView {
    objc_setAssociatedObject(self, @selector(hd_navTitleView), hd_navTitleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationItem.titleView = hd_navTitleView;
}

- (UIView *)hd_navTitleView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_navTitleColor:(UIColor *)hd_navTitleColor {
    objc_setAssociatedObject(self, @selector(hd_navTitleColor), hd_navTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: hd_navTitleColor, NSFontAttributeName: self.hd_navTitleFont};
}

- (UIColor *)hd_navTitleColor {
    id objc = objc_getAssociatedObject(self, _cmd);
    return (objc != nil) ? objc : HDNavConfigure.titleColor;
}

- (void)setHd_navTitleFont:(UIFont *)hd_navTitleFont {
    objc_setAssociatedObject(self, @selector(hd_navTitleFont), hd_navTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: self.hd_navTitleColor, NSFontAttributeName: hd_navTitleFont};
}

- (UIFont *)hd_navTitleFont {
    id objc = objc_getAssociatedObject(self, _cmd);
    return (objc != nil) ? objc : HDNavConfigure.titleFont;
}

- (void)setHd_navLeftBarButtonItem:(UIBarButtonItem *)hd_navLeftBarButtonItem {
    objc_setAssociatedObject(self, @selector(hd_navLeftBarButtonItem), hd_navLeftBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationItem.leftBarButtonItem = hd_navLeftBarButtonItem;
}

- (UIBarButtonItem *)hd_navLeftBarButtonItem {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_navLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)hd_navLeftBarButtonItems {
    objc_setAssociatedObject(self, @selector(hd_navLeftBarButtonItems), hd_navLeftBarButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationItem.leftBarButtonItems = hd_navLeftBarButtonItems;
}

- (NSArray<UIBarButtonItem *> *)hd_navLeftBarButtonItems {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_navRightBarButtonItem:(UIBarButtonItem *)hd_navRightBarButtonItem {
    objc_setAssociatedObject(self, @selector(hd_navRightBarButtonItem), hd_navRightBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationItem.rightBarButtonItem = hd_navRightBarButtonItem;
}

- (UIBarButtonItem *)hd_navRightBarButtonItem {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_navRightBarButtonItems:(NSArray<UIBarButtonItem *> *)hd_navRightBarButtonItems {
    objc_setAssociatedObject(self, @selector(hd_navRightBarButtonItems), hd_navRightBarButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.hd_navigationItem.rightBarButtonItems = hd_navRightBarButtonItems;
}

- (NSArray<UIBarButtonItem *> *)hd_navRightBarButtonItems {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_navItemLeftSpace:(CGFloat)hd_navItemLeftSpace {
    objc_setAssociatedObject(self, @selector(hd_navItemLeftSpace), @(hd_navItemLeftSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (hd_navItemLeftSpace == HDNavigationBarItemSpace) return;

    [HDNavConfigure updateConfigure:^(HDNavigationBarConfigure *_Nonnull configure) {
        configure.hd_navItemLeftSpace = hd_navItemLeftSpace;
    }];
}

- (CGFloat)hd_navItemLeftSpace {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setHd_navItemRightSpace:(CGFloat)hd_navItemRightSpace {
    objc_setAssociatedObject(self, @selector(hd_navItemRightSpace), @(hd_navItemRightSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (hd_navItemRightSpace == HDNavigationBarItemSpace) return;

    [HDNavConfigure updateConfigure:^(HDNavigationBarConfigure *_Nonnull configure) {
        configure.hd_navItemRightSpace = hd_navItemRightSpace;
    }];
}

- (CGFloat)hd_navItemRightSpace {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setShouldAddLeftNavItemOnFirstOfNavChildVCS:(BOOL)shouldAddLeftNavItemOnFirstOfNavChildVCS {
    objc_setAssociatedObject(self, @selector(shouldAddLeftNavItemOnFirstOfNavChildVCS), @(shouldAddLeftNavItemOnFirstOfNavChildVCS), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldAddLeftNavItemOnFirstOfNavChildVCS {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - Public Methods
- (void)showNavLine {
    self.hd_navLineHidden = NO;
}

- (void)hideNavLine {
    self.hd_navLineHidden = YES;
}

- (void)refreshNavBarFrame {
    [self setupNavBarFrame];
}

- (UIViewController *)hd_visibleViewControllerIfExist {
    if (self.presentedViewController) {
        return [self.presentedViewController hd_visibleViewControllerIfExist];
    }

    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController hd_visibleViewControllerIfExist];
    }

    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController hd_visibleViewControllerIfExist];
    }

    if (self.isViewLoaded && self.view.window) {
        return self;
    } else {
        NSLog(@"找不到可见的控制器，viewController.self = %@，self.view.window = %@", self, self.view.window);
        return nil;
    }
}

#pragma mark - Private Methods
- (void)setupNavBarFrame {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    CGFloat navBarH = 0.0f;
    if (width > height) {  // 横屏
        if (HDNavigationBarIsNotchedScreen) {
            navBarH = HDNavigationBarNavBarHeight;
        } else {
            if (width == 736.0f && height == 414.0f) {  // plus横屏
                navBarH = self.hd_statusBarHidden ? HDNavigationBarNavBarHeight : HD_STATUSBAR_NAVBAR_HEIGHT;
            } else {  // 其他机型横屏
                navBarH = self.hd_statusBarHidden ? 32.0f : 52.0f;
            }
        }
    } else {  // 竖屏
        navBarH = self.hd_statusBarHidden ? (HDNavigationBarSafeAreaTop + HDNavigationBarNavBarHeight) : HD_STATUSBAR_NAVBAR_HEIGHT;
    }
    self.hd_navigationBar.frame = CGRectMake(0, 0, width, navBarH);
    self.hd_navigationBar.hd_statusBarHidden = self.hd_statusBarHidden;

    [self.hd_navigationBar setNeedsLayout];
    [self.hd_navigationBar layoutIfNeeded];
}

@end
