//
//  HDCategoryIndicatorView.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorView.h"
#import "HDCategoryFactory.h"
#import "HDCategoryIndicatorBackgroundView.h"

@interface HDCategoryIndicatorView ()

@end

@implementation HDCategoryIndicatorView

- (void)initializeData {
    [super initializeData];

    _separatorLineShowEnabled = NO;
    _separatorLineColor = [UIColor lightGrayColor];
    _separatorLineSize = CGSizeMake(1 / [UIScreen mainScreen].scale, 20);
    _cellBackgroundColorGradientEnabled = NO;
    _cellBackgroundUnselectedColor = [UIColor whiteColor];
    _cellBackgroundSelectedColor = [UIColor lightGrayColor];
}

- (void)initializeViews {
    [super initializeViews];
}

- (void)setIndicators:(NSArray<UIView<HDCategoryIndicatorProtocol> *> *)indicators {
    _indicators = indicators;

    self.collectionView.indicators = indicators;
}

- (void)refreshState {
    [super refreshState];

    CGRect selectedCellFrame = CGRectZero;
    HDCategoryIndicatorCellModel *selectedCellModel = nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        HDCategoryIndicatorCellModel *cellModel = (HDCategoryIndicatorCellModel *)self.dataSource[i];
        cellModel.sepratorLineShowEnabled = self.isSeparatorLineShowEnabled;
        cellModel.separatorLineColor = self.separatorLineColor;
        cellModel.separatorLineSize = self.separatorLineSize;
        cellModel.backgroundViewMaskFrame = CGRectZero;
        cellModel.cellBackgroundColorGradientEnabled = self.isCellBackgroundColorGradientEnabled;
        cellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        cellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        if (i == self.dataSource.count - 1) {
            cellModel.sepratorLineShowEnabled = NO;
        }
        if (i == self.selectedIndex) {
            selectedCellModel = cellModel;
            selectedCellFrame = [self getTargetCellFrame:i];
        }
    }

    for (UIView<HDCategoryIndicatorProtocol> *indicator in self.indicators) {
        if (self.dataSource.count <= 0) {
            indicator.hidden = YES;
        } else {
            indicator.hidden = NO;
            HDCategoryIndicatorParamsModel *indicatorParamsModel = [[HDCategoryIndicatorParamsModel alloc] init];
            indicatorParamsModel.selectedIndex = self.selectedIndex;
            indicatorParamsModel.selectedCellFrame = selectedCellFrame;
            [indicator hd_refreshState:indicatorParamsModel];

            if ([indicator isKindOfClass:[HDCategoryIndicatorBackgroundView class]]) {
                CGRect maskFrame = indicator.frame;
                maskFrame.origin.x = maskFrame.origin.x - selectedCellFrame.origin.x;
                selectedCellModel.backgroundViewMaskFrame = maskFrame;
            }
        }
    }
}

- (void)refreshSelectedCellModel:(HDCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(HDCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    HDCategoryIndicatorCellModel *myUnselectedCellModel = (HDCategoryIndicatorCellModel *)unselectedCellModel;
    myUnselectedCellModel.backgroundViewMaskFrame = CGRectZero;
    myUnselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myUnselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;

    HDCategoryIndicatorCellModel *myselectedCellModel = (HDCategoryIndicatorCellModel *)selectedCellModel;
    myselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    [super contentOffsetOfContentScrollViewDidChanged:contentOffset];

    CGFloat ratio = contentOffset.x / self.contentScrollView.bounds.size.width;
    if (ratio > self.dataSource.count - 1 || ratio < 0) {
        // 超过了边界，不需要处理
        return;
    }
    ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    if (baseIndex + 1 >= self.dataSource.count) {
        // 右边越界了，不需要处理
        return;
    }
    CGFloat remainderRatio = ratio - baseIndex;

    CGRect leftCellFrame = [self getTargetCellFrame:baseIndex];
    CGRect rightCellFrame = [self getTargetCellFrame:baseIndex + 1];

    HDCategoryIndicatorParamsModel *indicatorParamsModel = [[HDCategoryIndicatorParamsModel alloc] init];
    indicatorParamsModel.selectedIndex = self.selectedIndex;
    indicatorParamsModel.leftIndex = baseIndex;
    indicatorParamsModel.leftCellFrame = leftCellFrame;
    indicatorParamsModel.rightIndex = baseIndex + 1;
    indicatorParamsModel.rightCellFrame = rightCellFrame;
    indicatorParamsModel.percent = remainderRatio;
    if (remainderRatio == 0) {
        for (UIView<HDCategoryIndicatorProtocol> *indicator in self.indicators) {
            [indicator hd_contentScrollViewDidScroll:indicatorParamsModel];
        }
    } else {
        HDCategoryIndicatorCellModel *leftCellModel = (HDCategoryIndicatorCellModel *)self.dataSource[baseIndex];
        leftCellModel.selectedType = HDCategoryCellSelectedTypeUnknown;
        HDCategoryIndicatorCellModel *rightCellModel = (HDCategoryIndicatorCellModel *)self.dataSource[baseIndex + 1];
        rightCellModel.selectedType = HDCategoryCellSelectedTypeUnknown;
        [self refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:remainderRatio];

        for (UIView<HDCategoryIndicatorProtocol> *indicator in self.indicators) {
            [indicator hd_contentScrollViewDidScroll:indicatorParamsModel];
            if ([indicator isKindOfClass:[HDCategoryIndicatorBackgroundView class]]) {
                CGRect leftMaskFrame = indicator.frame;
                leftMaskFrame.origin.x = leftMaskFrame.origin.x - leftCellFrame.origin.x;
                leftCellModel.backgroundViewMaskFrame = leftMaskFrame;

                CGRect rightMaskFrame = indicator.frame;
                rightMaskFrame.origin.x = rightMaskFrame.origin.x - rightCellFrame.origin.x;
                rightCellModel.backgroundViewMaskFrame = rightMaskFrame;
            }
        }

        HDCategoryBaseCell *leftCell = (HDCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
        [leftCell reloadData:leftCellModel];
        HDCategoryBaseCell *rightCell = (HDCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex + 1 inSection:0]];
        [rightCell reloadData:rightCellModel];
    }
}

- (BOOL)selectCellAtIndex:(NSInteger)index selectedType:(HDCategoryCellSelectedType)selectedType {
    NSInteger lastSelectedIndex = self.selectedIndex;
    BOOL result = [super selectCellAtIndex:index selectedType:selectedType];
    if (!result) {
        return NO;
    }

    CGRect clickedCellFrame = [self getTargetSelectedCellFrame:index selectedType:selectedType];

    HDCategoryIndicatorCellModel *selectedCellModel = (HDCategoryIndicatorCellModel *)self.dataSource[index];
    selectedCellModel.selectedType = selectedType;
    for (UIView<HDCategoryIndicatorProtocol> *indicator in self.indicators) {
        HDCategoryIndicatorParamsModel *indicatorParamsModel = [[HDCategoryIndicatorParamsModel alloc] init];
        indicatorParamsModel.lastSelectedIndex = lastSelectedIndex;
        indicatorParamsModel.selectedIndex = index;
        indicatorParamsModel.selectedCellFrame = clickedCellFrame;
        indicatorParamsModel.selectedType = selectedType;
        [indicator hd_selectedCell:indicatorParamsModel];
        if ([indicator isKindOfClass:[HDCategoryIndicatorBackgroundView class]]) {
            CGRect maskFrame = indicator.frame;
            maskFrame.origin.x = maskFrame.origin.x - clickedCellFrame.origin.x;
            selectedCellModel.backgroundViewMaskFrame = maskFrame;
        }
    }

    HDCategoryIndicatorCell *selectedCell = (HDCategoryIndicatorCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [selectedCell reloadData:selectedCellModel];

    return YES;
}

@end

@implementation HDCategoryIndicatorView (UISubclassingIndicatorHooks)

- (void)refreshLeftCellModel:(HDCategoryBaseCellModel *)leftCellModel rightCellModel:(HDCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    if (self.isCellBackgroundColorGradientEnabled) {
        // 处理cell背景色渐变
        HDCategoryIndicatorCellModel *leftModel = (HDCategoryIndicatorCellModel *)leftCellModel;
        HDCategoryIndicatorCellModel *rightModel = (HDCategoryIndicatorCellModel *)rightCellModel;
        if (leftModel.isSelected) {
            leftModel.cellBackgroundSelectedColor = [HDCategoryFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        } else {
            leftModel.cellBackgroundUnselectedColor = [HDCategoryFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
        if (rightModel.isSelected) {
            rightModel.cellBackgroundSelectedColor = [HDCategoryFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        } else {
            rightModel.cellBackgroundUnselectedColor = [HDCategoryFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
    }
}

@end
