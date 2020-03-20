//
//  UIView+HDSkeleton.h
//  HDUIKit
//
//  Created by VanJay on 2019/5/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HDSkeleton)

@property (nonatomic, strong, readonly) CALayer *skeletonContainer;

/**
 开始动画，view 本身被占位图层覆盖
 */
- (void)hd_beginSkeletonAnimation;

/**
 结束骨架动画，从当前 View 移除骨架图层
 */
- (void)hd_endSkeletonAnimation;

@end
