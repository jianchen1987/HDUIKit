

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self udpateStatusBarStyle];
}

- (void)baseSetupUI {
    self.view.backgroundColor = HDAppTheme.color.G5;
}

#pragma mark - private methods
- (void)setupNavigationBarStyle {
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
}

- (void)updateNavigationBarShadow {
    HDViewControllerNavigationBarStyle style = self.hd_preferredNavigationBarStyle;
    if (HDViewControllerNavigationBarStyleTransparent != style && !self.hd_shouldHideNavigationBarBottomShadow) {
        self.hd_navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
        self.hd_navigationBar.layer.shadowOffset = CGSizeMake(0, 10);
        self.hd_navigationBar.layer.shadowOpacity = 0.2;
        self.hd_navigationBar.layer.shadowRadius = 20;
        self.hd_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.hd_navigationBar.bounds].CGPath;
    }
}

- (void)udpateStatusBarStyle {
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
