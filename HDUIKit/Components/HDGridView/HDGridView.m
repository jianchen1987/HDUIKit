//
//  HDGridView.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDGridView.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"

@interface HDGridView ()
@property (nonatomic, strong) CAShapeLayer *separatorLayer;
@end

@implementation HDGridView

- (instancetype)initWithFrame:(CGRect)frame column:(NSInteger)column rowHeight:(CGFloat)rowHeight {
    if (self = [super initWithFrame:frame]) {
        [self didInitialized];
        self.columnCount = column;
        self.rowHeight = rowHeight;
    }
    return self;
}

- (instancetype)initWithColumn:(NSInteger)column rowHeight:(CGFloat)rowHeight {
    return [self initWithFrame:CGRectZero column:column rowHeight:rowHeight];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame column:0 rowHeight:0];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized {
    self.columnCount = 1;
    self.subViewHMargin = 0;
    self.subViewVMargin = 0;
    self.shouldShowSeparator = false;
    self.separatorWidth = PixelOne;
    self.separatorLineDashPattern = nil;

    self.separatorColor = [HDAppTheme HDColorC1];
    self.separatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    self.separatorLayer = [CAShapeLayer layer];
    [self.separatorLayer removeAllAnimations];
    self.separatorLayer.hidden = !self.shouldShowSeparator;
    self.separatorLayer.lineWidth = self.separatorWidth;
    self.separatorLayer.strokeColor = self.separatorColor.CGColor;
    [self.layer addSublayer:self.separatorLayer];
}

- (void)setShouldShowSeparator:(BOOL)shouldShowSeparator {
    if (_shouldShowSeparator == shouldShowSeparator) return;

    _shouldShowSeparator = shouldShowSeparator;
    self.separatorLayer.hidden = !shouldShowSeparator;
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {

    if (_separatorWidth == separatorWidth) return;
    _separatorWidth = separatorWidth;

    self.separatorLayer.lineWidth = _separatorWidth;
    self.separatorLayer.hidden = _separatorWidth <= 0;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    self.separatorLayer.strokeColor = _separatorColor.CGColor;
}

// 返回最接近平均列宽的值，保证其为整数，因此所有columnWidth加起来可能比总宽度要小
- (CGFloat)stretchColumnWidth {
    return floor((CGRectGetWidth(self.bounds) - (self.edgeInsets.left + self.edgeInsets.right) - self.subViewHMargin * (self.columnCount - 1)) / self.columnCount);
}

// 返回最接近平均高度的值，保证其为整数，因此所有columnHeight加起来可能比总宽度要小
- (CGFloat)stretchColumnHeight {
    return floor((CGRectGetHeight(self.bounds) - (self.edgeInsets.top + self.edgeInsets.bottom) - self.subViewVMargin * (self.rowCount - 1)) / self.rowCount);
}

- (NSInteger)rowCount {
    NSInteger subviewCount = self.subviews.count;
    return subviewCount / self.columnCount + (subviewCount % self.columnCount > 0 ? 1 : 0);
}

- (CGSize)sizeThatFits:(CGSize)size {
    NSInteger rowCount = [self rowCount];
    CGFloat totalHeight = rowCount * self.rowHeight + (rowCount - 1) * self.subViewVMargin;
    size.height = totalHeight;
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSInteger subviewCount = self.subviews.count;
    if (subviewCount == 0) return;

    CGSize size = self.bounds.size;
    if (CGSizeIsEmpty(size)) return;

    CGFloat columnWidth = self.stretchColumnWidth;
    CGFloat rowHeight = self.rowHeight;
    NSInteger rowCount = self.rowCount;

    if (rowHeight <= 0) {
        rowHeight = self.stretchColumnHeight;
    }

    // CGFloat lineOffset = 0;
    UIBezierPath *separatorPath = self.shouldShowSeparator ? UIBezierPath.bezierPath : nil;

    for (NSInteger row = 0; row < rowCount; row++) {
        for (NSInteger column = 0; column < self.columnCount; column++) {
            NSInteger index = row * self.columnCount + column;
            if (index < subviewCount) {
                BOOL isLastColumn = column == self.columnCount - 1;
                BOOL isLastRow = row == rowCount - 1;

                UIView *subview = self.subviews[index];
                CGRect subviewFrame = CGRectMake(self.edgeInsets.left + (columnWidth + self.subViewHMargin) * column, self.edgeInsets.top + (rowHeight + self.subViewVMargin) * row, columnWidth, rowHeight);

                if (isLastColumn) {
                    // 每行最后一个item要占满剩余空间，否则可能因为strecthColumnWidth不精确导致右边漏空白
                    subviewFrame.size.width = size.width - (self.edgeInsets.left + self.edgeInsets.right) - (columnWidth + self.subViewHMargin) * (self.columnCount - 1);
                }
                if (isLastRow && rowCount > 1) {
                    // 最后一行的item要占满剩余空间，避免一些计算偏差
                    subviewFrame.size.height = size.height - (self.edgeInsets.top + self.edgeInsets.bottom) - (rowHeight + self.subViewVMargin) * (rowCount - 1);
                }

                subview.frame = subviewFrame;
                [subview setNeedsLayout];

                if (self.shouldShowSeparator) {
                    // 每个 item 都画右边和下边这两条分隔线
                    CGPoint verticalPointStart = CGPointMake(CGRectGetMaxX(subviewFrame) + self.subViewHMargin * 0.5, CGRectGetMinY(subviewFrame) + self.separatorEdgeInsets.top);
                    CGPoint verticalPointEnd = CGPointMake(verticalPointStart.x - (isLastColumn ? self.subViewHMargin * 0.5 : 0), CGRectGetMaxY(subviewFrame) - self.separatorEdgeInsets.bottom);

                    CGPoint horizontalPointEnd = CGPointMake(verticalPointStart.x - (self.separatorEdgeInsets.right + self.subViewHMargin * 0.5), CGRectGetMaxY(subviewFrame) + (!isLastRow ? self.subViewVMargin * 0.5 : 0));
                    CGPoint horizontalPointStart = CGPointMake(CGRectGetMinX(subviewFrame) + self.separatorEdgeInsets.left, horizontalPointEnd.y);

                    if (!isLastColumn) {
                        [separatorPath moveToPoint:verticalPointStart];
                        [separatorPath addLineToPoint:verticalPointEnd];
                    }
                    if (!isLastRow) {
                        [separatorPath moveToPoint:horizontalPointStart];
                        [separatorPath addLineToPoint:horizontalPointEnd];
                    }
                }
            }
        }
    }

    if (self.shouldShowSeparator) {
        if (self.separatorDashed) {
            self.separatorLayer.lineDashPattern = self.separatorLineDashPattern;
        }
        self.separatorLayer.path = separatorPath.CGPath;
    }
}
@end
