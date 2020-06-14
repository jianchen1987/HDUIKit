

//
//  HDCommonViewController.m
//  HDUIKit
//
//  Created by VanJay on 2020/3/3.
//

#import "HDCommonViewController.h"
#import "HDAppTheme.h"
#import "NSBundle+HDUIKit.h"
#import <HDKitCore/HDLog.h>

@interface HDCommonViewController ()
@end

@implementation HDCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self baseSetupUI];

    // 监听转屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_deviceOrientationDidChangedNotification) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];

    HDLog(@"%@ - dealloc", NSStringFromClass(self.class));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupNavigationBarStyle];

    // 滑动返回正在进行就不着急改状态栏样式，放在 viewDidAppear 中改
    UIGestureRecognizerState state = self.navigationController.panGesture.state;
    if (state != UIGestureRecognizerStateBegan && state != UIGestureRecognizerStateChanged) {
        [self updateStatusBarStyle];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateStatusBarStyle];
}

- (void)baseSetupUI {
    self.view.backgroundColor = HDAppTheme.color.G5;
}

#pragma mark - private methods
- (void)setupNavigationBarStyle {

    // 父控制器不是导航控制器或者 tabbar 控制器，不处理，可能是作为 childViewController 被使用，此时应跟随父控制器
    BOOL shouldSetupNavigationBarStyle = self.presentingViewController || [self.parentViewController isKindOfClass:UINavigationController.class] || [self.parentViewController isKindOfClass:UITabBarController.class];

    if (shouldSetupNavigationBarStyle) {
        HDViewControllerNavigationBarStyle style = self.hd_preferredNavigationBarStyle;
        NSBundle *bundle = [NSBundle hd_UIKitMainFrameResourcesBundle];

        UIImage *image;
        if (HDViewControllerNavigationBarStyleWhite == style) {
            self.hd_navBackgroundColor = UIColor.whiteColor;
            self.hd_navTitleColor = HDAppTheme.color.G1;
            image = [UIImage imageNamed:@"ic-return-red" inBundle:bundle compatibleWithTraitCollection:nil];
        } else if (HDViewControllerNavigationBarStyleTheme == style) {
            self.hd_navBackgroundColor = HDAppTheme.color.C1;
            self.hd_navTitleColor = UIColor.whiteColor;
            image = [UIImage imageNamed:@"ic-return-white" inBundle:bundle compatibleWithTraitCollection:nil];
        } else if (HDViewControllerNavigationBarStyleHidden == style) {
            self.hd_navigationBar.hidden = true;
        } else if (HDViewControllerNavigationBarStyleOther == style) {
            self.hd_navBackgroundColor = HDAppTheme.color.C1;
            self.hd_navTitleColor = UIColor.whiteColor;
            image = [UIImage imageNamed:@"ic-return-white" inBundle:bundle compatibleWithTraitCollection:nil];
        } else if (HDViewControllerNavigationBarStyleTransparent == style) {
            self.hd_navBarAlpha = 0;
            self.hd_navTitleColor = UIColor.whiteColor;
            image = [UIImage imageNamed:@"ic-return-white" inBundle:bundle compatibleWithTraitCollection:nil];
        }
        if (image) {
            self.hd_backButtonImage = image;
        }
        self.hd_navLineHidden = self.hd_shouldHideNavigationBarBottomLine;

        [self updateNavigationBarShadow];
    } else {
        self.hd_navigationBar.hidden = true;
        self.hd_navLineHidden = true;
    }
}

- (void)updateNavigationBarShadow {
    HDViewControllerNavigationBarStyle style = self.hd_preferredNavigationBarStyle;
    if (HDViewControllerNavigationBarStyleTransparent != style && !self.hd_shouldHideNavigationBarBottomShadow) {
        self.hd_navigationBar.layer.shadowColor = [UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.50].CGColor;
        self.hd_navigationBar.layer.shadowOffset = CGSizeMake(0, 3);
        self.hd_navigationBar.layer.shadowOpacity = 1;
        self.hd_navigationBar.layer.shadowRadius = 3;
        self.hd_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.hd_navigationBar.bounds].CGPath;
    }
}

- (void)updateStatusBarStyle {
    // 父控制器不是导航控制器或者 tabbar 控制器，不处理，可能是作为 childViewController 被使用，此时应跟随父控制器
    BOOL shouldUpdateStatusBarStyle = self.presentingViewController || [self.parentViewController isKindOfClass:UINavigationController.class] || [self.parentViewController isKindOfClass:UITabBarController.class];
    if (!shouldUpdateStatusBarStyle) return;

    if (self.hd_hasManuallySetStatusBarStyle) {
        [UIApplication sharedApplication].statusBarStyle = [self hd_fixedStatusBarStyle:self.hd_statusBarStyle];
    } else {
        UIStatusBarStyle darkStyle = UIStatusBarStyleDefault;
        if (@available(iOS 13.0, *)) {
            darkStyle = UIStatusBarStyleDarkContent;
        }
        UIStatusBarStyle style = darkStyle;
        HDViewControllerNavigationBarStyle navStyle = self.hd_preferredNavigationBarStyle;
        if (HDViewControllerNavigationBarStyleWhite == navStyle) {
            style = darkStyle;
        } else if (HDViewControllerNavigationBarStyleTheme == navStyle) {
            style = UIStatusBarStyleLightContent;
        } else if (HDViewControllerNavigationBarStyleHidden == navStyle) {
            style = UIStatusBarStyleLightContent;
        } else if (HDViewControllerNavigationBarStyleOther == navStyle) {
            style = darkStyle;
        } else if (HDViewControllerNavigationBarStyleTransparent == navStyle) {
            style = UIStatusBarStyleLightContent;
        }
        self.hd_statusBarStyle = style;
    }
}

#pragma mark - Notification
- (void)_deviceOrientationDidChangedNotification {
    [self updateNavigationBarShadow];
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTheme;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}
@end
