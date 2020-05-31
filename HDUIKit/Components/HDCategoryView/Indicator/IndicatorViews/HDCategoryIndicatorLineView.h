//
//  HDCategoryIndicatorLineView.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorComponentView.h"

typedef NS_ENUM(NSUInteger, HDCategoryIndicatorLineStyle) {
    HDCategoryIndicatorLineStyle_Normal = 0,
    HDCategoryIndicatorLineStyle_Lengthen = 1,
    HDCategoryIndicatorLineStyle_LengthenOffset = 2,
};

@interface HDCategoryIndicatorLineView : HDCategoryIndicatorComponentView

@property (nonatomic, assign) HDCategoryIndicatorLineStyle lineStyle;

/**
 line滚动时x的偏移量，默认为 10；
 lineStyle 为 HDCategoryIndicatorLineStyle_LengthenOffset 有用
 */
@property (nonatomic, assign) CGFloat lineScrollOffsetX;

@end
