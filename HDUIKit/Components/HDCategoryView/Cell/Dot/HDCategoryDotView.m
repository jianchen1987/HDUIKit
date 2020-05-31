//
//  HDCategoryDotView.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryDotView.h"

@implementation HDCategoryDotView

- (void)initializeData {
    [super initializeData];

    _relativePosition = HDCategoryDotRelativePosition_TopRight;
    _dotSize = CGSizeMake(5, 5);
    _dotCornerRadius = HDCategoryViewAutomaticDimension;
    _dotColor = [UIColor redColor];
    _dotOffset = CGPointZero;
}

- (Class)preferredCellClass {
    return [HDCategoryDotCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        HDCategoryDotCellModel *cellModel = [[HDCategoryDotCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(HDCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    HDCategoryDotCellModel *myCellModel = (HDCategoryDotCellModel *)cellModel;
    myCellModel.dotHidden = [self.dotStates[index] boolValue];
    myCellModel.relativePosition = self.relativePosition;
    myCellModel.dotSize = self.dotSize;
    myCellModel.dotColor = self.dotColor;
    myCellModel.dotOffset = self.dotOffset;
    if (self.dotCornerRadius == HDCategoryViewAutomaticDimension) {
        myCellModel.dotCornerRadius = self.dotSize.height / 2;
    } else {
        myCellModel.dotCornerRadius = self.dotCornerRadius;
    }
}

@end
