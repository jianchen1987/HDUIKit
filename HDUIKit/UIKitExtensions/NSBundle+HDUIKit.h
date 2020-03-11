//
//  NSBundle+HDUIKit.h
//  HDUIKit
//
//  Created by VanJay on 2020/3/4.
//  Copyright © 2019 chaos network technology. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (HDUIKit)

/// HDUIKitMainFrameResources 资源包
+ (NSBundle *)hd_UIKitMainFrameResourcesBundle;

/// HDUIKitTipsResources
+ (NSBundle *)hd_UIKitTipsResourcesBundle;
@end

NS_ASSUME_NONNULL_END
