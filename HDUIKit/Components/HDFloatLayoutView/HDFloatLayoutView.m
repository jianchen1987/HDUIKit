//
//  HDFloatLayoutView.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDFloatLayoutView.h"
#import "HDCommonDefines.h"

#define ValueSwitchAlignLeftOrRight(valueLeft, valueRight) ([self shouldAlignRight] ? valueRight : valueLeft)

const CGSize HDFloatLayoutViewAutomaticalMaximumItemSize = {-1, -1};

typedef struct {
    CGSize size;
    NSUInteger fowardingTotalRowCount;
} HDFloatLayoutViewLayoutGinseng;

@implementation HDFloatLayoutView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialized];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized {
    self.contentMode = UIViewContentModeLeft;
    self.minimumItemSize = CGSizeZero;
    self.maxRowCount = 0;
    self.maximumItemSize = HDFloatLayoutViewAutomaticalMaximumItemSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self layoutSubviewsWithSize:size shouldLayout:NO].size;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self layoutSubviewsWithSize:self.bounds.size shouldLayout:YES];
}

- (HDFloatLayoutViewLayoutGinseng)layoutSubviewsWithSize:(CGSize)size shouldLayout:(BOOL)shouldLayout {
    NSArray<UIView *> *visibleItemViews = [self visibleSubviews];

    // 出参
    HDFloatLayoutViewLayoutGinseng layoutGinseng = {.size = CGSizeZero, .fowardingTotalRowCount = 0};

    if (visibleItemViews.count == 0) {
        layoutGinseng.size = CGSizeMake(UIEdgeInsetsGetHorizontalValue(self.padding), UIEdgeInsetsGetVerticalValue(self.padding));
        return layoutGinseng;
    }

    // 如果是左对齐，则代表 item 左上角的坐标，如果是右对齐，则代表 item 右上角的坐标
    CGPoint itemViewOrigin = CGPointMake(ValueSwitchAlignLeftOrRight(self.padding.left, size.width - self.padding.right), self.padding.top);
    CGFloat currentRowMaxY = itemViewOrigin.y;
    CGSize maximumItemSize = CGSizeEqualToSize(self.maximumItemSize, HDFloatLayoutViewAutomaticalMaximumItemSize) ? CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.padding), size.height - UIEdgeInsetsGetVerticalValue(self.padding)) : self.maximumItemSize;

    NSUInteger currentRow = 0;
    for (NSInteger i = 0; i < visibleItemViews.count; i++) {
        UIView *itemView = visibleItemViews[i];

        CGRect itemViewFrame = CGRectZero;
        CGSize itemViewSize = [itemView sizeThatFits:maximumItemSize];
        itemViewSize.width = MIN(maximumItemSize.width, MAX(self.minimumItemSize.width, itemViewSize.width));
        itemViewSize.height = MIN(maximumItemSize.height, MAX(self.minimumItemSize.height, itemViewSize.height));

        BOOL shouldBreakline = i == 0 ? YES : ValueSwitchAlignLeftOrRight(itemViewOrigin.x + self.itemMargins.left + itemViewSize.width + self.padding.right > size.width, itemViewOrigin.x - self.itemMargins.right - itemViewSize.width - self.padding.left < 0);
        if (shouldBreakline) {
            currentRow++;
            if (self.maxRowCount <= 0 || currentRow <= self.maxRowCount) {
                currentRowMaxY += (currentRow > 1 ? self.itemMargins.top : 0);
            }
            // 换行，每一行第一个 item 是不考虑 itemMargins 的
            itemViewFrame = CGRectMake(ValueSwitchAlignLeftOrRight(self.padding.left, size.width - self.padding.right - itemViewSize.width), currentRowMaxY, itemViewSize.width, itemViewSize.height);
            itemViewOrigin.y = CGRectGetMinY(itemViewFrame);
        } else {
            // 当前行放得下
            itemViewFrame = CGRectMake(ValueSwitchAlignLeftOrRight(itemViewOrigin.x + self.itemMargins.left, itemViewOrigin.x - self.itemMargins.right - itemViewSize.width), itemViewOrigin.y, itemViewSize.width, itemViewSize.height);
        }

        itemViewOrigin.x = ValueSwitchAlignLeftOrRight(CGRectGetMaxX(itemViewFrame) + self.itemMargins.right, CGRectGetMinX(itemViewFrame) - self.itemMargins.left);
        if (self.maxRowCount <= 0 || currentRow <= self.maxRowCount) {
            currentRowMaxY = MAX(currentRowMaxY, CGRectGetMaxY(itemViewFrame) + self.itemMargins.bottom);
        }

        if (shouldLayout) {
            itemView.frame = itemViewFrame;

            if (self.maxRowCount > 0) {
                if (currentRow > self.maxRowCount) {
                    [itemView removeFromSuperview];
                    continue;
                }
            }
        }
    }

    // 最后一行不需要考虑 itemMarins.bottom，所以这里减掉
    currentRowMaxY -= self.itemMargins.bottom;

    CGSize resultSize = CGSizeMake(size.width, currentRowMaxY + self.padding.bottom);
    // 最后一个的行数就是最大行数
    layoutGinseng.fowardingTotalRowCount = currentRow;
    layoutGinseng.size = resultSize;
    return layoutGinseng;
}

- (NSUInteger)fowardingTotalRowCountWithMaxSize:(CGSize)maxSize {
    HDFloatLayoutViewLayoutGinseng layoutGinseng = [self layoutSubviewsWithSize:maxSize shouldLayout:false];
    return layoutGinseng.fowardingTotalRowCount;
}

- (NSArray<UIView *> *)visibleSubviews {
    NSMutableArray<UIView *> *visibleItemViews = [[NSMutableArray alloc] init];

    for (NSInteger i = 0, l = self.subviews.count; i < l; i++) {
        UIView *itemView = self.subviews[i];
        if (!itemView.hidden) {
            [visibleItemViews addObject:itemView];
        }
    }

    return visibleItemViews;
}

- (BOOL)shouldAlignRight {
    return self.contentMode == UIViewContentModeRight;
}
@end
