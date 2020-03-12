//
//  HDUIKit.h
//  HDUIKit
//
//  Created by VanJay on 2020/2/26.
//  Copyright © 2020 VanJay. All rights reserved.
//  This file is generated automatically.

#ifndef HDUIKit_h
#define HDUIKit_h

#import <UIKit/UIKit.h>

/// 版本号
static NSString *const HDUIKit_VERSION = @"0.5.0";

#if __has_include("HDDispatchMainQueueSafe.h")
#import "HDDispatchMainQueueSafe.h"
#endif

#if __has_include("HDHelperFunction.h")
#import "HDHelperFunction.h"
#endif

#if __has_include("HDCommonDefines.h")
#import "HDCommonDefines.h"
#endif

#if __has_include("HDHelper.h")
#import "HDHelper.h"
#endif

#if __has_include("HDAssociatedObjectHelper.h")
#import "HDAssociatedObjectHelper.h"
#endif

#if __has_include("HDUIHelperDefines.h")
#import "HDUIHelperDefines.h"
#endif

#if __has_include("HDRunTime.h")
#import "HDRunTime.h"
#endif

#if __has_include("WJFunctionThrottle.h")
#import "WJFunctionThrottle.h"
#endif

#if __has_include("UIView+WJFrameLayout.h")
#import "UIView+WJFrameLayout.h"
#endif

#if __has_include("WJFrameLayout.h")
#import "WJFrameLayout.h"
#endif

#if __has_include("WJFrameLayoutUtils.h")
#import "WJFrameLayoutUtils.h"
#endif

#if __has_include("WJFrameLayoutMaker.h")
#import "WJFrameLayoutMaker.h"
#endif

#if __has_include("CALayer+WJFrameLayout.h")
#import "CALayer+WJFrameLayout.h"
#endif

#if __has_include("HDUIButton.h")
#import "HDUIButton.h"
#endif

#if __has_include("HDUIGhostButton.h")
#import "HDUIGhostButton.h"
#endif

#if __has_include("HDToastBackgroundView.h")
#import "HDToastBackgroundView.h"
#endif

#if __has_include("HDToastContentView.h")
#import "HDToastContentView.h"
#endif

#if __has_include("HDToastAnimator.h")
#import "HDToastAnimator.h"
#endif

#if __has_include("HDToastView.h")
#import "HDToastView.h"
#endif

#if __has_include("HDWeakObjectContainer.h")
#import "HDWeakObjectContainer.h"
#endif

#if __has_include("HDTextView.h")
#import "HDTextView.h"
#endif

#if __has_include("NSObject+HDMultipleDelegates.h")
#import "NSObject+HDMultipleDelegates.h"
#endif

#if __has_include("HDMultipleDelegates.h")
#import "HDMultipleDelegates.h"
#endif

#if __has_include("HDTips.h")
#import "HDTips.h"
#endif

#if __has_include("NAT.h")
#import "NAT.h"
#endif

#if __has_include("HDActionAlertView.h")
#import "HDActionAlertView.h"
#endif

#if __has_include("UIWindow+HDUtils.h")
#import "UIWindow+HDUtils.h"
#endif

#if __has_include("HDActionAlertViewController.h")
#import "HDActionAlertViewController.h"
#endif

#if __has_include("HDAlertViewConfig.h")
#import "HDAlertViewConfig.h"
#endif

#if __has_include("HDAlertView.h")
#import "HDAlertView.h"
#endif

#if __has_include("HDAlertViewButton.h")
#import "HDAlertViewButton.h"
#endif

#if __has_include("HDGridView.h")
#import "HDGridView.h"
#endif

#if __has_include("HDStarView.h")
#import "HDStarView.h"
#endif

#if __has_include("HDRatingStarView.h")
#import "HDRatingStarView.h"
#endif

#if __has_include("HDCountDownButton.h")
#import "HDCountDownButton.h"
#endif

#if __has_include("HDKeyBoard.h")
#import "HDKeyBoard.h"
#endif

#if __has_include("HDKeyBoardTheme.h")
#import "HDKeyBoardTheme.h"
#endif

#if __has_include("HDFloatLayoutView.h")
#import "HDFloatLayoutView.h"
#endif

#if __has_include("HDUISlider.h")
#import "HDUISlider.h"
#endif

#if __has_include("HDVisualEffectView.h")
#import "HDVisualEffectView.h"
#endif

#if __has_include("HDLogItem.h")
#import "HDLogItem.h"
#endif

#if __has_include("HDLogNameManager.h")
#import "HDLogNameManager.h"
#endif

#if __has_include("HDLogger.h")
#import "HDLogger.h"
#endif

#if __has_include("HDLog.h")
#import "HDLog.h"
#endif

#if __has_include("HDPieProgressView.h")
#import "HDPieProgressView.h"
#endif

#if __has_include("HDRectangleProgressView.h")
#import "HDRectangleProgressView.h"
#endif

#if __has_include("HDCyclePagerTransformLayout.h")
#import "HDCyclePagerTransformLayout.h"
#endif

#if __has_include("HDPageControl.h")
#import "HDPageControl.h"
#endif

#if __has_include("HDCyclePagerView.h")
#import "HDCyclePagerView.h"
#endif

#if __has_include("HDUITextField.h")
#import "HDUITextField.h"
#endif

#if __has_include("HDUITextFieldConfig.h")
#import "HDUITextFieldConfig.h"
#endif

#if __has_include("HDAppTheme.h")
#import "HDAppTheme.h"
#endif

#if __has_include("HDCommonViewController+NAT.h")
#import "HDCommonViewController+NAT.h"
#endif

#if __has_include("HDCommonViewController.h")
#import "HDCommonViewController.h"
#endif

#if __has_include("HDNavigationBar.h")
#import "HDNavigationBar.h"
#endif

#if __has_include("UIScrollView+HDNavigationBar.h")
#import "UIScrollView+HDNavigationBar.h"
#endif

#if __has_include("UINavigationController+HDNavigationBar.h")
#import "UINavigationController+HDNavigationBar.h"
#endif

#if __has_include("UIViewController+HDNavigationBar.h")
#import "UIViewController+HDNavigationBar.h"
#endif

#if __has_include("UINavigationItem+HDNavigationBar.h")
#import "UINavigationItem+HDNavigationBar.h"
#endif

#if __has_include("HDCustomNavigationBar.h")
#import "HDCustomNavigationBar.h"
#endif

#if __has_include("HDNavigationBarCategory.h")
#import "HDNavigationBarCategory.h"
#endif

#if __has_include("UIImage+HDNavigationBar.h")
#import "UIImage+HDNavigationBar.h"
#endif

#if __has_include("UIBarButtonItem+HDNavigationBar.h")
#import "UIBarButtonItem+HDNavigationBar.h"
#endif

#if __has_include("HDNavigationBarDefine.h")
#import "HDNavigationBarDefine.h"
#endif

#if __has_include("HDNavigationBarConfigure.h")
#import "HDNavigationBarConfigure.h"
#endif

#if __has_include("HDNavigationBarTransitionDelegateHandler.h")
#import "HDNavigationBarTransitionDelegateHandler.h"
#endif

#if __has_include("HDNavigationBarBaseAnimatedTransition.h")
#import "HDNavigationBarBaseAnimatedTransition.h"
#endif

#if __has_include("HDNavigationBarPopAnimatedTransition.h")
#import "HDNavigationBarPopAnimatedTransition.h"
#endif

#if __has_include("HDNavigationBarPushAnimatedTransition.h")
#import "HDNavigationBarPushAnimatedTransition.h"
#endif

#if __has_include("NSArray+HDUIKit.h")
#import "NSArray+HDUIKit.h"
#endif

#if __has_include("UITableView+HDUIKit.h")
#import "UITableView+HDUIKit.h"
#endif

#if __has_include("UINavigationController+HDUIKit.h")
#import "UINavigationController+HDUIKit.h"
#endif

#if __has_include("UITextField+HDUIKit.h")
#import "UITextField+HDUIKit.h"
#endif

#if __has_include("NSParagraphStyle+HDUIKit.h")
#import "NSParagraphStyle+HDUIKit.h"
#endif

#if __has_include("UICollectionView+HDUIKit.h")
#import "UICollectionView+HDUIKit.h"
#endif

#if __has_include("NSPointerArray+HDUIKit.h")
#import "NSPointerArray+HDUIKit.h"
#endif

#if __has_include("UITextView+HDUIKit.h")
#import "UITextView+HDUIKit.h"
#endif

#if __has_include("UIBezierPath+HDUIKit.h")
#import "UIBezierPath+HDUIKit.h"
#endif

#if __has_include("NSNumber+HDUIKit.h")
#import "NSNumber+HDUIKit.h"
#endif

#if __has_include("CALayer+HDUIKit.h")
#import "CALayer+HDUIKit.h"
#endif

#if __has_include("CAAnimation+HDUIKit.h")
#import "CAAnimation+HDUIKit.h"
#endif

#if __has_include("UIInterface+HDUIKit.h")
#import "UIInterface+HDUIKit.h"
#endif

#if __has_include("UIViewController+HDUIKit.h")
#import "UIViewController+HDUIKit.h"
#endif

#if __has_include("NSBundle+HDUIKit.h")
#import "NSBundle+HDUIKit.h"
#endif

#if __has_include("NSMethodSignature+HDUIKit.h")
#import "NSMethodSignature+HDUIKit.h"
#endif

#if __has_include("NSCharacterSet+HDUIKit.h")
#import "NSCharacterSet+HDUIKit.h"
#endif

#if __has_include("UIImage+HD_GIF.h")
#import "UIImage+HD_GIF.h"
#endif

#if __has_include("UIImage+HDUIKit.h")
#import "UIImage+HDUIKit.h"
#endif

#if __has_include("UIButton+EnlargeEdge.h")
#import "UIButton+EnlargeEdge.h"
#endif

#if __has_include("UIButton+EventInterval.h")
#import "UIButton+EventInterval.h"
#endif

#if __has_include("UIButton+sizeToFit.h")
#import "UIButton+sizeToFit.h"
#endif

#if __has_include("UIButton+Block.h")
#import "UIButton+Block.h"
#endif

#if __has_include("UIColor+HDUIKit.h")
#import "UIColor+HDUIKit.h"
#endif

#if __has_include("UIView+HD_Extension.h")
#import "UIView+HD_Extension.h"
#endif

#if __has_include("UIView+HDUIKit.h")
#import "UIView+HDUIKit.h"
#endif

#if __has_include("NSString+HDUIKit.h")
#import "NSString+HDUIKit.h"
#endif

#if __has_include("NSString+HD_Size.h")
#import "NSString+HD_Size.h"
#endif

#if __has_include("NSString+HD_Util.h")
#import "NSString+HD_Util.h"
#endif

#if __has_include("NSObject+HDUIKit.h")
#import "NSObject+HDUIKit.h"
#endif

#if __has_include("NSObject+HD_Swizzle.h")
#import "NSObject+HD_Swizzle.h"
#endif

#if __has_include("HDCodeGenerator.h")
#import "HDCodeGenerator.h"
#endif

#endif /* HDUIKit_h */