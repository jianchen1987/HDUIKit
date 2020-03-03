//
//  HDRectangleProgressView.h
//  HDUIKit
//
//  Created by VanJay on 2020/1/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 饼状进度条控件
 *
 * 使用 `tintColor` 更改进度条部分和边框部分的颜色
 *
 * 使用 `backgroundColor` 更改圆形背景色
 *
 * 通过 `UIControlEventValueChanged` 来监听进度变化
 */

NS_ASSUME_NONNULL_BEGIN

@interface HDRectangleProgressView : UIControl

/**
 进度动画的时长，默认为 0.5
 */
@property (nonatomic, assign) IBInspectable CFTimeInterval progressAnimationDuration;

/**
 当前进度值，默认为 0.0。调用 `setProgress:` 相当于调用 `setProgress:animated:NO`
 */
@property (nonatomic, assign) IBInspectable float progress;

/**
 外边框的大小，默认为 1。
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 外边框与内部扇形之间的间隙，默认为 0。
 */
@property (nonatomic, assign) IBInspectable CGFloat borderInset;

/**
 线宽，用于环形绘制，默认为 5。
 */
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;

/**
 修改当前的进度，会触发 UIControlEventValueChanged 事件

 @param progress 当前的进度，取值范围 [0.0-1.0]
 @param animated 是否以动画来表现
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
