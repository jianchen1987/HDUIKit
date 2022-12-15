//
//  HDFloatLayoutView.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDFloatLayoutViewDelegate <NSObject>

@optional
/// 更新UI是的回调，需要自行刷新view
- (void)floatLayoutViewFrameDidChanged;

@end



/// 用于属性 maximumItemSize，是它的默认值。表示 item 的最大宽高会自动根据当前 floatLayoutView 的内容大小来调整，从而避免 item 内容过多时可能溢出 floatLayoutView。
extern const CGSize HDFloatLayoutViewAutomaticalMaximumItemSize;

/**
 *  做类似 CSS 里的 float:left 的布局，自行使用 addSubview: 将子 View 添加进来即可。
 *
 *  支持通过 `contentMode` 属性修改子 View 的对齐方式，目前仅支持 `UIViewContentModeLeft` 和 `UIViewContentModeRight`，默认为 `UIViewContentModeLeft`。
 */
@interface HDFloatLayoutView : UIView

/**
 *  HDFloatLayoutView 内部的间距，默认为 UIEdgeInsetsZero
 */
@property (nonatomic, assign) UIEdgeInsets padding;

/**
 *  item 的最小宽高，默认为 CGSizeZero，也即不限制。
 */
@property (nonatomic, assign) IBInspectable CGSize minimumItemSize;

/**
 *  item 的最大宽高，默认为 HDFloatLayoutViewAutomaticalMaximumItemSize，也即不超过 floatLayoutView 自身最大内容宽高。
 */
@property (nonatomic, assign) IBInspectable CGSize maximumItemSize;

/**
 *  item 之间的间距，默认为 UIEdgeInsetsZero。
 *
 *  @warning 上、下、左、右四个边缘的 item 布局时不会考虑 itemMargins.left/bottom/left/right。
 */
@property (nonatomic, assign) UIEdgeInsets itemMargins;

/** 最大行数，多余的不会添加 */
@property (nonatomic, assign) NSUInteger maxRowCount;  ///< 最大行数，默认0，不限制

/// 全部子View布局时的行数
/// @param maxSize 最大尺寸，用于计算行数
- (NSUInteger)fowardingTotalRowCountWithMaxSize:(CGSize)maxSize;

/// 自定义搜索更多按钮
/// @param moreView 展开按钮
- (void)setCustomMoreView:(UIButton *)moreView;
/// 通过代理回调刷新布局
@property (nonatomic, weak) id<HDFloatLayoutViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
