

//
//  HDNavigationBarConfigure.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarConfigure.h"

@interface HDNavigationBarConfigure ()

@property (nonatomic, assign) CGFloat navItemLeftSpace;
@property (nonatomic, assign) CGFloat navItemRightSpace;

@end

@implementation HDNavigationBarConfigure
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HDNavigationBarConfigure *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        [instance setupDefaultConfigure];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)setupDefaultConfigure {
    self.backgroundColor = [UIColor whiteColor];

    self.titleColor = [UIColor blackColor];
    self.titleFont = [UIFont boldSystemFontOfSize:17.0f];

    self.hd_disableFixSpace = NO;
    self.hd_navItemLeftSpace = 12;
    self.hd_navItemRightSpace = 12;
    self.navItemLeftSpace = 12.f;
    self.navItemRightSpace = 12.f;

    self.statusBarHidden = NO;
    self.statusBarStyle = UIStatusBarStyleDefault;

    self.hd_pushTransitionCriticalValue = 0.3f;
    self.hd_popTransitionCriticalValue = 0.5f;

    self.hd_translationX = 5.0f;
    self.hd_translationY = 5.0f;
    self.hd_scaleX = 0.95f;
    self.hd_scaleY = 0.97f;
}

- (void)setupCustomConfigure:(void (^)(HDNavigationBarConfigure *_Nonnull))block {
    [self setupDefaultConfigure];

    !block ?: block(self);

    self.navItemLeftSpace = self.hd_navItemLeftSpace;
    self.navItemRightSpace = self.hd_navItemRightSpace;
}

- (void)updateConfigure:(void (^)(HDNavigationBarConfigure *_Nonnull))block {
    !block ?: block(self);
}

- (CGFloat)hd_fixedSpace {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return MIN(screenSize.width, screenSize.height) > 375.0f ? 20.0f : 16.0f;
}

@end
