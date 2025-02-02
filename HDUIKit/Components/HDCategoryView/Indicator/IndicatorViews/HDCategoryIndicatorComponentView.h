//
//  HDCategoryIndicatorComponentView.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorProtocol.h"
#import "HDCategoryViewDefines.h"
#import <UIKit/UIKit.h>

@interface HDCategoryIndicatorComponentView : UIView <HDCategoryIndicatorProtocol>

/**
 指示器的位置。底部或者顶部
 */
@property (nonatomic, assign) HDCategoryComponentPosition componentPosition;

/**
 默认HDCategoryViewAutomaticDimension（与cell的宽度相等）。内部通过`- (CGFloat)indicatorWidthValue:(CGRect)cellFrame`方法获取实际的值
 */
@property (nonatomic, assign) CGFloat indicatorWidth;

/**
 指示器的宽度增量。比如需求是指示器宽度比cell宽度多10 point。就可以将该属性赋值为10。最终指示器的宽度=indicatorWidth+indicatorWidthIncrement
 */
@property (nonatomic, assign) CGFloat indicatorWidthIncrement;

/**
 默认:3。内部通过`- (CGFloat)indicatorHeightValue:(CGRect)cellFrame`方法获取实际的值
 */
@property (nonatomic, assign) CGFloat indicatorHeight;

/**
 默认HDCategoryViewAutomaticDimension （等于indicatorHeight/2）。内部通过`- (CGFloat)indicatorCornerRadiusValue:(CGRect)cellFrame`方法获取实际的值
 */
@property (nonatomic, assign) CGFloat indicatorCornerRadius;

/**
 指示器的颜色
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 垂直方向偏移。数值越大越靠近中心。默认：0。
 */
@property (nonatomic, assign) CGFloat verticalMargin;

/**
 手势滚动、点击切换的时候，是否允许滚动，默认YES
 */
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;

/**
 手势滚动、点击切换的时候，如果允许滚动，分为简单滚动和复杂滚动。默认为：HDCategoryIndicatorScrollStyleSimple
 目前仅HDCategoryIndicatorLineView、HDCategoryIndicatorDotLineView支持，其他子类暂不支持。
 */
@property (nonatomic, assign) HDCategoryIndicatorScrollStyle scrollStyle;

/**
 滚动动画的时间。默认0.25
 */
@property (nonatomic, assign) NSTimeInterval scrollAnimationDuration;

/**
 传入cellFrame获取指示器的最终宽度

 @param cellFrame cellFrame
 @return 指示器的最终宽度
 */
- (CGFloat)indicatorWidthValue:(CGRect)cellFrame;

/**
 传入cellFrame获取指示器的最终高度

 @param cellFrame cellFrame
 @return 指示器的最终高度
 */
- (CGFloat)indicatorHeightValue:(CGRect)cellFrame;

/**
 传入cellFrame获取指示器的最终圆角

 @param cellFrame cellFrame
 @return 指示器的最终圆角
 */
- (CGFloat)indicatorCornerRadiusValue:(CGRect)cellFrame;

@end
