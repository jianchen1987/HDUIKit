//
//  HDPageControl.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDPageControl : UIControl
/** 页数，默认 0 */
@property (nonatomic, assign) NSInteger numberOfPages;
/** 当前索引，默认为0 */
@property (nonatomic, assign) NSInteger currentPage;
/** 只有一页时是否隐藏，默认否 */
@property (nonatomic, assign) BOOL hidesForSinglePage;
/** 间距 */
@property (nonatomic, assign) CGFloat pageIndicatorSpaing;
/** 内容内边距，居中时不生效 */
@property (nonatomic, assign) UIEdgeInsets contentInset;
/** 返回真实的内容大小 */
@property (nonatomic, assign, readonly) CGSize contentSize;
/** 主题色 */
@property (nullable, nonatomic, strong) UIColor *pageIndicatorTintColor;
/** 当前索引的 dot 颜色 */
@property (nullable, nonatomic, strong) UIColor *currentPageIndicatorTintColor;
/** 设置 dot 图片 */
@property (nullable, nonatomic, strong) UIImage *pageIndicatorImage;
/** 设置当前的 dot 图片 */
@property (nullable, nonatomic, strong) UIImage *currentPageIndicatorImage;
/** 内容模式，默认居中 */
@property (nonatomic, assign) UIViewContentMode indicatorImageContentMode;
/** 默认 dot 尺寸 */
@property (nonatomic, assign) CGSize pageIndicatorSize;
/** 激活的 dot 尺寸 */
@property (nonatomic, assign) CGSize currentPageIndicatorSize;
/** 动画时间，默认3 */
@property (nonatomic, assign) CGFloat animateDuring;

/// 设置当前页数
/// @param currentPage 目标页
/// @param animate 是否动画
- (void)setCurrentPage:(NSInteger)currentPage animate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
