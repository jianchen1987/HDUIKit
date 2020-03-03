//
//  HDCustomNavigationBar.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCustomNavigationBar.h"
#import "HDNavigationBarDefine.h"

@implementation HDCustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translucent = NO;
        self.hd_navBarBackgroundAlpha = 1.0f;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // 适配iOS11，遍历所有子控件，向下移动状态栏高度
    if (HDNavigationBarDeviceVersion >= 11.0f) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                CGRect frame = obj.frame;
                frame.size.height = self.frame.size.height;
                obj.frame = frame;
            } else {
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                CGFloat height = [UIScreen mainScreen].bounds.size.height;

                CGFloat y = 0;
                if (width > height) {
                    if (HDNavigationBarIsNotchedScreen) {
                        y = 0;
                    } else {
                        y = self.hd_statusBarHidden ? 0 : HDNavigationBarStatusBarHeight;
                    }
                } else {
                    y = self.hd_statusBarHidden ? HDNavigationBarSafeAreaTop : HDNavigationBarStatusBarHeight;
                }
                CGRect frame = obj.frame;
                frame.origin.y = y;
                obj.frame = frame;
            }
        }];
    }

    // 重新设置透明度
    self.hd_navBarBackgroundAlpha = self.hd_navBarBackgroundAlpha;

    // 分割线
    [self hd_navLineHideOrShow];
}

- (void)hd_navLineHideOrShow {
    UIView *backgroundView = self.subviews.firstObject;

    for (UIView *view in backgroundView.subviews) {
        if (view.frame.size.height > 0 && view.frame.size.height <= 1.0f) {
            view.hidden = self.hd_navLineHidden;
        }
    }
}

- (void)setHd_navBarBackgroundAlpha:(CGFloat)hd_navBarBackgroundAlpha {
    _hd_navBarBackgroundAlpha = hd_navBarBackgroundAlpha;

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (HDNavigationBarDeviceVersion >= 10.0f && [obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (obj.alpha != hd_navBarBackgroundAlpha) {
                    obj.alpha = hd_navBarBackgroundAlpha;
                }
            });
        } else if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (obj.alpha != hd_navBarBackgroundAlpha) {
                    obj.alpha = hd_navBarBackgroundAlpha;
                }
            });
        }
    }];

    BOOL isClipsToBounds = (hd_navBarBackgroundAlpha == 0.0f);
    if (self.clipsToBounds != isClipsToBounds) {
        self.clipsToBounds = isClipsToBounds;
    }
}

@end
