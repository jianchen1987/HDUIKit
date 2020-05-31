//
//  HDCategoryViewDefines.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat HDCategoryViewAutomaticDimension = -1;

typedef void (^HDCategoryCellSelectedAnimationBlock)(CGFloat percent);

typedef NS_ENUM(NSUInteger, HDCategoryComponentPosition) {
    HDCategoryComponentPosition_Bottom = 0,
    HDCategoryComponentPosition_Top,
};

// cell被选中的类型
typedef NS_ENUM(NSUInteger, HDCategoryCellSelectedType) {
    HDCategoryCellSelectedTypeUnknown = 0,  ///< 未知，不是选中（cellForRow方法里面、两个cell过渡时）
    HDCategoryCellSelectedTypeClick,        ///< 点击选中
    HDCategoryCellSelectedTypeCode,         ///< 调用方法`- (void)selectItemAtIndex:(NSInteger)index`选中
    HDCategoryCellSelectedTypeScroll        ///< 通过滚动到某个cell选中
};

/// 锚点位置
typedef NS_ENUM(NSUInteger, HDCategoryTitleLabelAnchorPointStyle) {
    HDCategoryTitleLabelAnchorPointStyleCenter = 0,
    HDCategoryTitleLabelAnchorPointStyleTop,
    HDCategoryTitleLabelAnchorPointStyleBottom,
};

/// 指示器滚动样式
typedef NS_ENUM(NSUInteger, HDCategoryIndicatorScrollStyle) {
    HDCategoryIndicatorScrollStyleSimple = 0,        ///< 简单滚动，即从当前位置过渡到目标位置
    HDCategoryIndicatorScrollStyleSameAsUserScroll,  ///< 和用户左右滚动列表时的效果一样
};

#define HDCategoryViewDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)
