//
//  HDScrollNavBar.h
//  HDUIKit
//
//  Created by VanJay on 2020/1/3.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDScrollTitleBarViewButton.h"
#import <UIKit/UIKit.h>

@interface HDScrollNavBar : UIView
/** 当前选中索引，默认 0 */
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, weak) UIScrollView *contentScrollView;
/** 默认颜色 */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** 选中颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 当前按钮 */
@property (nonatomic, weak, readonly) HDScrollTitleBarViewButton *currentButton;
/** 上一个按钮 */
@property (nonatomic, weak, readonly) HDScrollTitleBarViewButton *preButton;
/** 数据源 */
@property (nonatomic, copy) NSArray<HDScrollTitleBarViewCellModel *> *dataSource;
/** 默认字体大小，默认 15 */
@property (nonatomic, assign) CGFloat normalFontSize;
/** 选中字体大小，默认 15 */
@property (nonatomic, assign) CGFloat selectedFontSize;
/** 两边留空间距 */
@property (nonatomic, assign) CGFloat sideMargin;
/** 按钮间距 */
@property (nonatomic, assign) CGFloat btnMargin;
/** 标题是否等宽 */
@property (nonatomic, assign) BOOL isBtnEqualWidth;
/** 指示线高度 */
@property (nonatomic, assign) CGFloat indicateLineHeight;
/** 指示线宽度（固定宽度） */
@property (nonatomic, assign) CGFloat indicateLineWidth;
/** 指示线颜色 */
@property (nonatomic, strong) UIColor *indicateLineColor;
/** 指示器和整个按钮等宽，默认 NO，即和按钮标题等宽 */
@property (nonatomic, assign) BOOL isIndicateLineWidthEqualToFullButton;
/** 指示线和底部间距 */
@property (nonatomic, assign) CGFloat marginBottomToIndicateLine;
/** 底部线高度，默认0，即不显示，可设置 PixelOne，即一条线高度 */
@property (nonatomic, assign) CGFloat bottomLineHeight;
/** 底部线颜色 */
@property (nonatomic, strong) UIColor *bottomLineColor;
/** 完全展开的宽度 */
@property (nonatomic, assign, readonly) CGFloat fullExpandedWidth;
/** titleLabelZoomEnabled 为 YES 生效，选中时放大系数，默认 1.2 */
@property (nonatomic, assign) CGFloat titleLabelZoomScale;
/** 标题选中放大效果，默认开启，开启后选中字体大小失效 */
@property (nonatomic, assign) BOOL isTitleLabelZoomEnabled;
/** 手势滚动中，颜色是否要渐变，默认开启 */
@property (nonatomic, assign) BOOL isTitleLabelColorGradientChangeEnabled;
/** 指示器是否需要动画，默认开启 */
@property (nonatomic, assign) BOOL isIndicateLineAnimationEnabled;
/** 按钮宽度相同，把容器宽度均分 */
@property (nonatomic, assign) BOOL isBtnWidthEqualAndExpandFullWidth;
/** 不触发回调 */
@property (nonatomic, assign) BOOL forbiddenInvokeHandler;
/** 按钮文字内边距 */
@property (nonatomic, assign) UIEdgeInsets buttonTitleEdgeInsets;

@property (nonatomic, copy) void (^selectedBtnHandler)(NSUInteger btnIndex);  ///< 点击了标题按钮的回调

/** 选中第几个位置 */
- (void)selectBtnAtIndex:(NSUInteger)btnIndex;

/// 设置数据源
/// @param dataSource 数据源
/// @param invokeHandler 触发默认索引时机回调
- (void)setDataSource:(NSArray<HDScrollTitleBarViewCellModel *> *)dataSource invokeHandler:(void (^)(void))invokeHandler;
@end
