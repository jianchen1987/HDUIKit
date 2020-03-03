//
//  UIImage+HDNavigationBar.h
//  HDUIKit
//
//  Created by VanJay on 2019/11/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HDNavigationBar)

/// 根据颜色生成size为(1, 1)的纯色图片
/// @param color 图片颜色
+ (UIImage *)hd_imageWithColor:(UIColor *)color;

/// 根据颜色生成指定size的纯色图片
/// @param color 图片颜色
/// @param size 图片大小
+ (UIImage *)hd_imageWithColor:(UIColor *)color size:(CGSize)size;

/// 修改指定图片颜色生成新的图片
/// @param image 原图片
/// @param color 图片颜色
+ (UIImage *)hd_changeImage:(UIImage *)image color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
