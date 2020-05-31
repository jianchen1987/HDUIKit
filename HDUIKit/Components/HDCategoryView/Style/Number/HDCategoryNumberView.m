//
//  HDCategoryNumberView.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryNumberView.h"

@implementation HDCategoryNumberView

- (void)dealloc {
    self.numberStringFormatterBlock = nil;
}

- (void)initializeData {
    [super initializeData];

    self.cellSpacing = 25;
    _numberTitleColor = [UIColor whiteColor];
    _numberBackgroundColor = [UIColor colorWithRed:241 / 255.0 green:147 / 255.0 blue:95 / 255.0 alpha:1];
    _numberLabelHeight = 14;
    _numberLabelWidthIncrement = 10;
    _numberLabelFont = [UIFont systemFontOfSize:11];
}

- (Class)preferredCellClass {
    return [HDCategoryNumberCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        HDCategoryNumberCellModel *cellModel = [[HDCategoryNumberCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(HDCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    HDCategoryNumberCellModel *myCellModel = (HDCategoryNumberCellModel *)cellModel;
    myCellModel.count = [self.counts[index] integerValue];
    if (self.numberStringFormatterBlock != nil) {
        myCellModel.numberString = self.numberStringFormatterBlock(myCellModel.count);
    } else {
        myCellModel.numberString = [NSString stringWithFormat:@"%ld", (long)myCellModel.count];
    }
    myCellModel.numberBackgroundColor = self.numberBackgroundColor;
    myCellModel.numberTitleColor = self.numberTitleColor;
    myCellModel.numberLabelHeight = self.numberLabelHeight;
    myCellModel.numberLabelOffset = self.numberLabelOffset;
    myCellModel.numberLabelWidthIncrement = self.numberLabelWidthIncrement;
    myCellModel.numberLabelFont = self.numberLabelFont;
}

@end
