

//
//  HDCommonViewController.m
//  HDUIKit
//
//  Created by VanJay on 2020/3/3.
//

#import "HDCommonViewController.h"
#import "HDAppTheme.h"
#import "NSBundle+HDUIKit.h"

@interface HDCommonViewController ()

@end

@implementation HDCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self baseSetupUI];

    [self setupNavigationBarStyle];
}

- (void)baseSetupUI {
    self.view.backgroundColor = [HDAppTheme HDColorG5];
}

#pragma mark - private methods
- (void)setupNavigationBarStyle {
    HDViewControllerNavigationBarStyle style = self.hd_preferredNavigationBarStyle;

    NSBundle *bundle = [NSBundle hd_UIKitMainFrameResourcesBundle];

    UIImage *image;
    if (HDViewControllerNavigationBarStyleWhite == style) {
        self.hd_navBackgroundColor = UIColor.whiteColor;
        self.hd_navTitleColor = [HDAppTheme HDColorC1];
        image = [UIImage imageNamed:@"ic-return-red" inBundle:bundle withConfiguration:nil];
    } else if (HDViewControllerNavigationBarStyleTheme == style) {
        self.hd_navBackgroundColor = [HDAppTheme HDColorC1];
        self.hd_navTitleColor = UIColor.whiteColor;
        image = [UIImage imageNamed:@"ic-return-white" inBundle:bundle withConfiguration:nil];
    } else if (HDViewControllerNavigationBarStyleHidden == style) {
        self.hd_navigationBar.hidden = true;
    } else if (HDViewControllerNavigationBarStyleOther == style) {
        self.hd_navBackgroundColor = [HDAppTheme HDColorC1];
        self.hd_navTitleColor = UIColor.whiteColor;
        image = [UIImage imageNamed:@"ic-return-white" inBundle:bundle withConfiguration:nil];
    }
    if (image) {
        self.hd_backButtonImage = image;
    }
    self.hd_navLineHidden = self.hd_shouldHideNavigationBarBottomLine;

    if (!self.hd_shouldHideNavigationBarBottomShadow) {
        self.hd_navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
        self.hd_navigationBar.layer.shadowOffset = CGSizeMake(0, 10);
        self.hd_navigationBar.layer.shadowOpacity = 0.2;
        self.hd_navigationBar.layer.shadowRadius = 20;
        self.hd_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.hd_navigationBar.bounds].CGPath;
    }
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
