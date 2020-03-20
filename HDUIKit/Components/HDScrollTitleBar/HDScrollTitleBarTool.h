//
//  HDScrollTitleBarTool.h
//  HDUIKit
//
//  Created by VanJay on 2020/1/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDScrollTitleBarTool : NSObject

/// 获取从A到B相差百分比的数值
/// @param from 最小值
/// @param to 最大值
/// @param percent 百分比
+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;

/// 获取从颜色1到颜色2的过度色
/// @param fromColor 起始颜色
/// @param toColor 结束颜色
/// @param percent 百分比
+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent;
@end

NS_ASSUME_NONNULL_END
