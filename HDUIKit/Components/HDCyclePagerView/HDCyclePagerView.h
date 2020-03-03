//
//  HDCyclePagerView.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCyclePagerTransformLayout.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    NSInteger index;
    NSInteger section;
} HDIndexSection;

/// 滚动方向
typedef NS_ENUM(NSUInteger, HDPagerScrollDirection) {
    HDPagerScrollDirectionLeft,
    HDPagerScrollDirectionRight,
};

@class HDCyclePagerView;
@protocol HDCyclePagerViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView;

- (__kindof UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index;

/** 设置布局，并自动缓存 */
- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView;

@end

@protocol HDCyclePagerViewDelegate <NSObject>

@optional

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index;
- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndexSection:(HDIndexSection)indexSection;
- (void)pagerView:(HDCyclePagerView *)pageView initializeTransformAttributes:(UICollectionViewLayoutAttributes *)attributes;
- (void)pagerView:(HDCyclePagerView *)pageView applyTransformToAttributes:(UICollectionViewLayoutAttributes *)attributes;
- (void)pagerView:(HDCyclePagerView *)pageView willDisplayCell:(__kindof UICollectionViewCell *)cell atIndexSection:(HDIndexSection)indexSection;

// scrollViewDelegate
- (void)pagerViewDidScroll:(HDCyclePagerView *)pageView;
- (void)pagerViewWillBeginDragging:(HDCyclePagerView *)pageView;
- (void)pagerViewDidEndDragging:(HDCyclePagerView *)pageView willDecelerate:(BOOL)decelerate;
- (void)pagerViewWillBeginDecelerating:(HDCyclePagerView *)pageView;
- (void)pagerViewDidEndDecelerating:(HDCyclePagerView *)pageView;
- (void)pagerViewWillBeginScrollingAnimation:(HDCyclePagerView *)pageView;
- (void)pagerViewDidEndScrollingAnimation:(HDCyclePagerView *)pageView;

@end

@interface HDCyclePagerView : UIView

/** 与 pagerView 大小一致，自动 */
@property (nonatomic, strong, nullable) UIView *backgroundView;

@property (nonatomic, weak, nullable) id<HDCyclePagerViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<HDCyclePagerViewDelegate> delegate;

/** 供外部使用，不要覆盖其数据源和代理 */
@property (nonatomic, weak, readonly) UICollectionView *collectionView;
/** 当前布局模式 */
@property (nonatomic, strong, readonly) HDCyclePagerViewLayout *layout;
/** 是否无限滚动 */
@property (nonatomic, assign) BOOL isInfiniteLoop;
/** 自动滚动时间间隔 */
@property (nonatomic, assign) CGFloat autoScrollInterval;

@property (nonatomic, assign) BOOL reloadDataNeedResetIndex;
/** 当前页数 */
@property (nonatomic, assign, readonly) NSInteger curIndex;
@property (nonatomic, assign, readonly) HDIndexSection indexSection;

// scrollView 属性
@property (nonatomic, assign, readonly) CGPoint contentOffset;
@property (nonatomic, assign, readonly) BOOL tracking;
@property (nonatomic, assign, readonly) BOOL dragging;
@property (nonatomic, assign, readonly) BOOL decelerating;

/** 重新加载数据，布局也会重置 */
- (void)reloadData;
/** 只更新数据，布局不刷新 */
- (void)updateData;
/** 只更新布局 */
- (void)setNeedUpdateLayout;
/** 清除当前 layout，重新调用代理的设置布局方法 */
- (void)setNeedClearLayout;
/** 当前 cell */
- (__kindof UICollectionViewCell *_Nullable)curIndexCell;
/** 可见 cell */
- (NSArray<__kindof UICollectionViewCell *> *_Nullable)visibleCells;

- (NSArray *)visibleIndexs;

- (void)scrollToItemAtIndex:(NSInteger)index animate:(BOOL)animate;
- (void)scrollToItemAtIndexSection:(HDIndexSection)indexSection animate:(BOOL)animate;
- (void)scrollToNearlyIndexAtDirection:(HDPagerScrollDirection)direction animate:(BOOL)animate;
- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
