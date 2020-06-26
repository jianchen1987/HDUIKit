//
//  NSBundle+HDKitCore.h
//  HDKitCore
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

/// HDUIKitKeyboardResources
+ (NSBundle *)hd_UIKitKeyboardResources;

/// HDUIKitSearchBarResources
+ (NSBundle *)hd_UIKitSearchBarResources;

/// HDUIKITCitySelectResources
+ (NSBundle *)hd_UIKITCitySelectResources;

/// HDUIKitImageBrowserResources
+ (NSBundle *)hd_UIKITImageBrowserResources;

/// HDUIKitTopToastResources
+ (NSBundle *)hd_UIKITTopToastResources;
@end

NS_ASSUME_NONNULL_END
