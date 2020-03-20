//
//  HDSkeletonLayer.h
//  HDUIKit
//
//  Created by VanJay on 2019/5/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDSkeletonLayerAnimationStyle) {
    HDSkeletonLayerAnimationStyleSolid = 0,
    HDSkeletonLayerAnimationStyleGradientLeftToRight,
    HDSkeletonLayerAnimationStyleGradientRightToLeft,
    HDSkeletonLayerAnimationStyleGradientTopToBottom,
    HDSkeletonLayerAnimationStyleGradientBottomToTop
};

/**
 骨架 loading 图层
 */
@interface HDSkeletonLayer : CALayer
@property (nonatomic, assign) NSTimeInterval animationDuration;              ///< 动画时长
@property (nonatomic, strong) UIColor *layerColor;                           ///< 图层颜色
@property (nonatomic, assign) HDSkeletonLayerAnimationStyle animationStyle;  ///< 动画风格
@property (nonatomic, strong) UIColor *gradientLayerColor;                   // 渐变图层颜色
@property (nonatomic, assign) CGFloat skeletonCornerRadius;                  ///< 圆角，默认5，请在设置 frame 之后设置，否则不生效

- (void)performAnimation;

@end
