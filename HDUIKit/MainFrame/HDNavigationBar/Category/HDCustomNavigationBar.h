//
//  HDCustomNavigationBar.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCustomNavigationBar : UINavigationBar

// 当前所在的控制器是否隐藏状态栏
@property (nonatomic, assign) BOOL hd_statusBarHidden;

// 导航栏透明度
@property (nonatomic, assign) CGFloat hd_navBarBackgroundAlpha;

// 导航栏分割线是否隐藏
@property (nonatomic, assign) BOOL hd_navLineHidden;

@end

NS_ASSUME_NONNULL_END
