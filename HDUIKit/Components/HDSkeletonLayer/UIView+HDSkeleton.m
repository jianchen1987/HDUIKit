//
//  UIView+HDSkeleton.m
//  HDUIKit
//
//  Created by VanJay on 2019/5/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSkeletonDefines.h"
#import "HDSkeletonLayer.h"
#import "HDSkeletonLayerLayoutProtocol.h"
#import "UIView+HDSkeleton.h"
#import <objc/runtime.h>

static void *kHDSkeletonContainerKey = &kHDSkeletonContainerKey;

@implementation UIView (HDSkeleton)

- (void)setSkeletonContainer:(CALayer *)skeletonContainer {
    skeletonContainer.frame = self.bounds;

    // 默认容器背景，无色
    UIColor *color = UIColor.clearColor;

    if ([self respondsToSelector:@selector(skeletonContainerViewBackgroundColor)]) {
        color = [(UIView<HDSkeletonLayerLayoutProtocol> *)self skeletonContainerViewBackgroundColor];
    }

    skeletonContainer.backgroundColor = color.CGColor;

    [self.layer addSublayer:skeletonContainer];

    [self willChangeValueForKey:@"skeletonContainer"];
    objc_setAssociatedObject(self, kHDSkeletonContainerKey, skeletonContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"skeletonContainer"];
}

- (CALayer *)skeletonContainer {
    return objc_getAssociatedObject(self, kHDSkeletonContainerKey);
}

- (void)hd_beginSkeletonAnimation {

    [self hd_endSkeletonAnimation];

    self.userInteractionEnabled = NO;

    [self buildContainer];

    [self setNeedsLayout];
    [self layoutIfNeeded];

    [self buildSkeletonSubViews];
}

- (void)buildContainer {
    [self dismissSkeleton];
    self.skeletonContainer = [[CALayer alloc] init];
}

- (void)buildSkeletonSubViews {
    // 实现了协议方法，自定义
    if ([self respondsToSelector:@selector(skeletonLayoutViews)]) {
        NSArray<HDSkeletonLayer *> *skeletonViews = [(UIView<HDSkeletonLayerLayoutProtocol> *)self skeletonLayoutViews];

        for (HDSkeletonLayer *layer in skeletonViews) {
            [self.skeletonContainer addSublayer:layer];
            [layer performAnimation];
        }
    } else {  // 默认填充自身
        HDSkeletonLayer *layer = [[HDSkeletonLayer alloc] init];
        [self.skeletonContainer addSublayer:layer];
        layer.frame = self.skeletonContainer.bounds;
        [layer performAnimation];
    }
}

- (void)hd_endSkeletonAnimation {
    if (!self.skeletonContainer) {
        return;
    }
    self.userInteractionEnabled = YES;
    [self dismissSkeleton];
}

- (void)dismissSkeleton {
    [self.skeletonContainer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.skeletonContainer removeFromSuperlayer];
    self.skeletonContainer = nil;
}

@end
