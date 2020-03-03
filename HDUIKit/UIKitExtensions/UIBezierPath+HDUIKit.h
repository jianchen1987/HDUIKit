//
//  UIBezierPath+Extension.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/29.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (HDUIKit)
/**
 * 创建一条支持四个角的圆角值不相同的路径
 * @param rect 路径的rect
 * @param cornerRadius 圆角大小的数字，长度必须为4，顺序分别为[左上角、左下角、右下角、右上角]
 * @param lineWidth 描边的大小，如果不需要描边（例如path是用于fill而不是用于stroke），则填0
 */
+ (UIBezierPath *)hd_bezierPathWithRoundedRect:(CGRect)rect cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius lineWidth:(CGFloat)lineWidth;
@end

NS_ASSUME_NONNULL_END
