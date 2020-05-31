//
//  HDCategoryTitleView.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorView.h"
#import "HDCategoryTitleCell.h"
#import "HDCategoryTitleCellModel.h"
#import "HDCategoryViewDefines.h"

@class HDCategoryTitleView;

@protocol HDCategoryTitleViewDataSource <NSObject>

@optional

/// 如果将HDCategoryTitleView嵌套进UITableView的cell，每次重用的时候，HDCategoryTitleView进行reloadData时，会重新计算所有的title宽度。
/// 所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该代理方法返回给HDCategoryTitleView。
/// 如果实现了该方法就以该方法返回的宽度为准，不触发内部默认的文字宽度计算。
- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title;
@end

@interface HDCategoryTitleView : HDCategoryIndicatorView
/// 数据源
@property (nonatomic, weak) id<HDCategoryTitleViewDataSource> titleDataSource;
/// 标题
@property (nonatomic, copy) NSArray<NSString *> *titles;
/// 标题行数，默认1
@property (nonatomic, assign) NSInteger titleNumberOfLines;
/// 默认状态颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 选中颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;  //默认：[UIColor redColor]
/// 默认字体
@property (nonatomic, strong) UIFont *titleFont;  //默认：[UIFont systemFontOfSize:15]
/// 选中字体，默认：与 titleFont 一样
@property (nonatomic, strong) UIFont *titleSelectedFont;  //文字被选中的字体。默认：与titleFont一样
/// 文字颜色是否渐变过渡，默认 YES
@property (nonatomic, assign, getter=isTitleColorGradientEnabled) BOOL titleColorGradientEnabled;
/// 默认：NO，titleLabel是否遮罩过滤
@property (nonatomic, assign, getter=isTitleLabelMaskEnabled) BOOL titleLabelMaskEnabled;
/// 默认为NO。为YES时titleSelectedFont失效，以titleFont为准
@property (nonatomic, assign, getter=isTitleLabelZoomEnabled) BOOL titleLabelZoomEnabled;
/// 手势滚动中，是否需要更新状态。默认为YES
@property (nonatomic, assign, getter=isTitleLabelZoomScrollGradientEnabled) BOOL titleLabelZoomScrollGradientEnabled;
/// 默认1.2，titleLabelZoomEnabled为YES才生效。是对字号的缩放，比如titleFont的pointSize为10，放大之后字号就是10*1.2=12。
@property (nonatomic, assign) CGFloat titleLabelZoomScale;
/// titleLabelZoomEnabled设置为YES，会对titleLabel进行transform缩放，当titleLabelZoomScale过大时（比如设置为2），选中的文本被放大之后底部会有很大的空白，从视觉上看就跟其他未选中的文本不在一个水平线上。这个时候就可以用这个值进行调整。
@property (nonatomic, assign) CGFloat titleLabelZoomSelectedVerticalOffset;
/// 默认：NO
@property (nonatomic, assign, getter=isTitleLabelStrokeWidthEnabled) BOOL titleLabelStrokeWidthEnabled;
/// 默认：-3，用于控制字体的粗细（底层通过NSStrokeWidthAttributeName实现）。使用该属性，务必让titleFont和titleSelectedFont设置为一样的！！！
@property (nonatomic, assign) CGFloat titleLabelSelectedStrokeWidth;

/*---------------------- titleLabel 锚点和 y 方向偏移 -----------------------*/
/// titleLabel锚点垂直方向的位置偏移，数值越大越偏离中心，默认为：0
@property (nonatomic, assign) CGFloat titleLabelVerticalOffset;
/// titleLabel锚点位置，用于调整titleLabel缩放时的基准位置。默认为：HDCategoryTitleLabelAnchorPointStyleCenter
@property (nonatomic, assign) HDCategoryTitleLabelAnchorPointStyle titleLabelAnchorPointStyle;
@end
