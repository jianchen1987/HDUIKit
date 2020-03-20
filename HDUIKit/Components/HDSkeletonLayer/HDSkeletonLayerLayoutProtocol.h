//
//  HDSkeletonLayerLayoutProtocol.h
//  HDUIKit
//
//  Created by VanJay on 2019/5/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#ifndef HDSkeletonLayerLayoutProtocol_h
#define HDSkeletonLayerLayoutProtocol_h

@class HDSkeletonLayer;

/**
 遵守协议，如果不实现将默认使用一个 HDSkeletonLayer 填充自身
 */
@protocol HDSkeletonLayerLayoutProtocol <NSObject>

@optional

/**
 返回你需要添加的占位 HDSkeletonLayer 数组
 */
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews;

/**
 骨架占位的背景颜色
 */
- (UIColor *)skeletonContainerViewBackgroundColor;

@end

#endif /* HDSkeletonLayerLayoutProtocol_h */
