//
//  HDCyclePagerViewLayout.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HDCyclePagerTransformLayoutType) {
    HDCyclePagerTransformLayoutNormal,
    HDCyclePagerTransformLayoutLinear,
    HDCyclePagerTransformLayoutCoverflow,
};

@class HDCyclePagerTransformLayout;
@protocol HDCyclePagerTransformLayoutDelegate <NSObject>

/** 初始化布局属性 */
- (void)pagerViewTransformLayout:(HDCyclePagerTransformLayout *)pagerViewTransformLayout initializeTransformAttributes:(UICollectionViewLayoutAttributes *)attributes;

/** 应用布局属性 */
- (void)pagerViewTransformLayout:(HDCyclePagerTransformLayout *)pagerViewTransformLayout applyTransformToAttributes:(UICollectionViewLayoutAttributes *)attributes;

@end

@interface HDCyclePagerViewLayout : NSObject

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) HDCyclePagerTransformLayoutType layoutType;
/** 默认 0.8 */
@property (nonatomic, assign) CGFloat minimumScale;
/** 默认 1.0 */
@property (nonatomic, assign) CGFloat minimumAlpha;
/** 默认 0.2 */
@property (nonatomic, assign) CGFloat maximumAngle;
/** 是否无限滚动 */
@property (nonatomic, assign) BOOL isInfiniteLoop;
/** 缩放角度改变的速率 */
@property (nonatomic, assign) CGFloat rateOfChange;
@property (nonatomic, assign) BOOL adjustSpacingWhenScroling;
/** cell 是否垂直居中 */
@property (nonatomic, assign) BOOL itemVerticalCenter;
/** 当无限滚动关闭时，第一个和最后一个是否水平居中 */
@property (nonatomic, assign) BOOL itemHorizontalCenter;

// sectionInset
@property (nonatomic, assign, readonly) UIEdgeInsets onlyOneSectionInset;
@property (nonatomic, assign, readonly) UIEdgeInsets firstSectionInset;
@property (nonatomic, assign, readonly) UIEdgeInsets lastSectionInset;
@property (nonatomic, assign, readonly) UIEdgeInsets middleSectionInset;

@end

@interface HDCyclePagerTransformLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) HDCyclePagerViewLayout *layout;

@property (nonatomic, weak, nullable) id<HDCyclePagerTransformLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
