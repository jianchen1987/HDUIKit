//
//  HDCommonViewController.h
//  HDUIKit
//
//  Created by VanJay on 2020/3/3.
//

#import "HDNavigationBar.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDViewControllerNavigationBarStyle) {
    HDViewControllerNavigationBarStyleWhite = 0,    ///< 白色
    HDViewControllerNavigationBarStyleTheme = 1,        ///< 主题色
    HDViewControllerNavigationBarStyleHidden = 2,       ///< 隐藏
    HDViewControllerNavigationBarStyleTransparent = 3,  ///< 透明的
    HDViewControllerNavigationBarStyleOther = 4,        ///< 其他，可自定义颜色
};

NS_ASSUME_NONNULL_BEGIN

@protocol HDViewControllerNavigationBarStyle <NSObject>

@optional

/// 导航栏风格
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle;

/// 是否隐藏导航栏底部线条
- (BOOL)hd_shouldHideNavigationBarBottomLine;

/// 是否添加导航栏底部阴影
- (BOOL)hd_shouldHideNavigationBarBottomShadow;
@end

@interface HDCommonViewController : UIViewController <HDViewControllerNavigationBarStyle>

// 强制刷新导航栏样式
- (void)forceUpdateNavigationBarStyle;

@end

NS_ASSUME_NONNULL_END
