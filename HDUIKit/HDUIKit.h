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
static NSString *const HDUIKit_VERSION = @"1.3.2";

#if __has_include("HDKeyboardManager.h")
#import "HDKeyboardManager.h"
#endif

#if __has_include("HDKeyboardManagerDefines.h")
#import "HDKeyboardManagerDefines.h"
#endif

#if __has_include("HDKeyboardManager+Helper.h")
#import "HDKeyboardManager+Helper.h"
#endif

#if __has_include("NSBundle+HDUIKit.h")
#import "NSBundle+HDUIKit.h"
#endif

#if __has_include("HDTableHeaderFootView.h")
#import "HDTableHeaderFootView.h"
#endif

#if __has_include("HDTableHeaderFootViewModel.h")
#import "HDTableHeaderFootViewModel.h"
#endif

#if __has_include("HDTableViewSectionModel.h")
#import "HDTableViewSectionModel.h"
#endif

#if __has_include("HDSearchBar.h")
#import "HDSearchBar.h"
#endif

#if __has_include("HDUIButton.h")
#import "HDUIButton.h"
#endif

#if __has_include("HDUIGhostButton.h")
#import "HDUIGhostButton.h"
#endif

#if __has_include("HDShareImageAlertView.h")
#import "HDShareImageAlertView.h"
#endif

#if __has_include("HDLabel.h")
#import "HDLabel.h"
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

#if __has_include("HDUnitTextFieldTextPosition.h")
#import "HDUnitTextFieldTextPosition.h"
#endif

#if __has_include("HDUnitTextField.h")
#import "HDUnitTextField.h"
#endif

#if __has_include("HDUnitTextFieldTextRange.h")
#import "HDUnitTextFieldTextRange.h"
#endif

#if __has_include("HDCitySelectViewController.h")
#import "HDCitySelectViewController.h"
#endif

#if __has_include("HDCitySearchViewController.h")
#import "HDCitySearchViewController.h"
#endif

#if __has_include("HDCityGroupsModel.h")
#import "HDCityGroupsModel.h"
#endif

#if __has_include("HDCityModel.h")
#import "HDCityModel.h"
#endif

#if __has_include("HDCitySelectSearchBar.h")
#import "HDCitySelectSearchBar.h"
#endif

#if __has_include("HDSelectCityTableViewCell.h")
#import "HDSelectCityTableViewCell.h"
#endif

#if __has_include("UIView+KeyboardMoveRespond.h")
#import "UIView+KeyboardMoveRespond.h"
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

#if __has_include("HDImageUploadAddImageView.h")
#import "HDImageUploadAddImageView.h"
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

#if __has_include("HDImageBrowserToolViewHandler.h")
#import "HDImageBrowserToolViewHandler.h"
#endif

#if __has_include("HDActionSheetView.h")
#import "HDActionSheetView.h"
#endif

#if __has_include("HDActionSheetViewConfig.h")
#import "HDActionSheetViewConfig.h"
#endif

#if __has_include("HDActionSheetViewButton.h")
#import "HDActionSheetViewButton.h"
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

#if __has_include("HDCustomViewActionView.h")
#import "HDCustomViewActionView.h"
#endif

#if __has_include("HDCustomViewActionViewConfig.h")
#import "HDCustomViewActionViewConfig.h"
#endif

#if __has_include("HDFloatLayoutView.h")
#import "HDFloatLayoutView.h"
#endif

#if __has_include("HDCategoryView.h")
#import "HDCategoryView.h"
#endif

#if __has_include("HDCategoryIndicatorView.h")
#import "HDCategoryIndicatorView.h"
#endif

#if __has_include("HDCategoryIndicatorCell.h")
#import "HDCategoryIndicatorCell.h"
#endif

#if __has_include("HDCategoryIndicatorCellModel.h")
#import "HDCategoryIndicatorCellModel.h"
#endif

#if __has_include("HDCategoryIndicatorLineView.h")
#import "HDCategoryIndicatorLineView.h"
#endif

#if __has_include("HDCategoryIndicatorBackgroundView.h")
#import "HDCategoryIndicatorBackgroundView.h"
#endif

#if __has_include("HDCategoryIndicatorComponentView.h")
#import "HDCategoryIndicatorComponentView.h"
#endif

#if __has_include("HDCategoryDotCell.h")
#import "HDCategoryDotCell.h"
#endif

#if __has_include("HDCategoryDotView.h")
#import "HDCategoryDotView.h"
#endif

#if __has_include("HDCategoryDotCellModel.h")
#import "HDCategoryDotCellModel.h"
#endif

#if __has_include("HDCategoryTitleView.h")
#import "HDCategoryTitleView.h"
#endif

#if __has_include("HDCategoryTitleCellModel.h")
#import "HDCategoryTitleCellModel.h"
#endif

#if __has_include("HDCategoryTitleCell.h")
#import "HDCategoryTitleCell.h"
#endif

#if __has_include("HDCategoryNumberView.h")
#import "HDCategoryNumberView.h"
#endif

#if __has_include("HDCategoryNumberCell.h")
#import "HDCategoryNumberCell.h"
#endif

#if __has_include("HDCategoryNumberCellModel.h")
#import "HDCategoryNumberCellModel.h"
#endif

#if __has_include("HDCategoryCollectionView.h")
#import "HDCategoryCollectionView.h"
#endif

#if __has_include("HDCategoryListContainerView.h")
#import "HDCategoryListContainerView.h"
#endif

#if __has_include("HDCategoryFactory.h")
#import "HDCategoryFactory.h"
#endif

#if __has_include("HDCategoryViewAnimator.h")
#import "HDCategoryViewAnimator.h"
#endif

#if __has_include("HDCategoryIndicatorParamsModel.h")
#import "HDCategoryIndicatorParamsModel.h"
#endif

#if __has_include("HDCategoryIndicatorProtocol.h")
#import "HDCategoryIndicatorProtocol.h"
#endif

#if __has_include("HDCategoryViewDefines.h")
#import "HDCategoryViewDefines.h"
#endif

#if __has_include("HDCategoryBaseCellModel.h")
#import "HDCategoryBaseCellModel.h"
#endif

#if __has_include("HDCategoryBaseView.h")
#import "HDCategoryBaseView.h"
#endif

#if __has_include("HDCategoryBaseCell.h")
#import "HDCategoryBaseCell.h"
#endif

#if __has_include("CGGeometry+HDImageCropper.h")
#import "CGGeometry+HDImageCropper.h"
#endif

#if __has_include("HDImageCropViewController.h")
#import "HDImageCropViewController.h"
#endif

#if __has_include("HDImageCropperTouchView.h")
#import "HDImageCropperTouchView.h"
#endif

#if __has_include("HDImageScrollView.h")
#import "HDImageScrollView.h"
#endif

#if __has_include("UIImage+HDImageCropper.h")
#import "UIImage+HDImageCropper.h"
#endif

#if __has_include("HDImageCropper.h")
#import "HDImageCropper.h"
#endif

#if __has_include("HDSocialShareAlertViewConfig.h")
#import "HDSocialShareAlertViewConfig.h"
#endif

#if __has_include("HDSocialShareCellModel.h")
#import "HDSocialShareCellModel.h"
#endif

#if __has_include("HDSocialShareAlertView.h")
#import "HDSocialShareAlertView.h"
#endif

#if __has_include("HDSocialShareCell.h")
#import "HDSocialShareCell.h"
#endif

#if __has_include("UIView+HDSkeleton.h")
#import "UIView+HDSkeleton.h"
#endif

#if __has_include("HDSkeleton.h")
#import "HDSkeleton.h"
#endif

#if __has_include("HDSkeletonDefines.h")
#import "HDSkeletonDefines.h"
#endif

#if __has_include("HDSkeletonLayer.h")
#import "HDSkeletonLayer.h"
#endif

#if __has_include("HDSkeletonLayerDataSourceProvider.h")
#import "HDSkeletonLayerDataSourceProvider.h"
#endif

#if __has_include("HDSkeletonLayerLayoutProtocol.h")
#import "HDSkeletonLayerLayoutProtocol.h"
#endif

#if __has_include("HDUISlider.h")
#import "HDUISlider.h"
#endif

#if __has_include("HDVisualEffectView.h")
#import "HDVisualEffectView.h"
#endif

#if __has_include("UIView+HD_Placeholder.h")
#import "UIView+HD_Placeholder.h"
#endif

#if __has_include("UIViewPlaceholder.h")
#import "UIViewPlaceholder.h"
#endif

#if __has_include("HDPlaceholderView.h")
#import "HDPlaceholderView.h"
#endif

#if __has_include("UIViewPlaceholderViewModel.h")
#import "UIViewPlaceholderViewModel.h"
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

#if __has_include("HDMainFrame.h")
#import "HDMainFrame.h"
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

#if __has_include("HDCodeGenerator.h")
#import "HDCodeGenerator.h"
#endif

#endif /* HDUIKit_h */