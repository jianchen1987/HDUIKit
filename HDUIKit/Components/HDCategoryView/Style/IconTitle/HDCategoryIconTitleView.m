//
//  HDCategoryIconTitleView.m
//  HDKitCore
//
//  Created by seeu on 2023/11/30.
//

#import "HDCategoryIconTitleView.h"


@implementation HDCategoryIconTitleView

- (void)initializeData {
    [super initializeData];

    _relativePosition = HDCategoryIconRelativePositionTop;
    _iconSize = CGSizeMake(44, 44);
    _iconCornerRadius = HDCategoryViewAutomaticDimension;
    _offset = 5;
}

- (Class)preferredCellClass {
    return [HDCategoryIconTitleCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        HDCategoryIconTitleCellModel *cellModel = [[HDCategoryIconTitleCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(HDCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    HDCategoryIconTitleCellModel *myCellModel = (HDCategoryIconTitleCellModel *)cellModel;
    myCellModel.iconUrl = self.icons[index];
    myCellModel.relativePosition = self.relativePosition;
    myCellModel.iconSize = self.iconSize;
    myCellModel.offset = self.offset;
    if (self.iconCornerRadius == HDCategoryViewAutomaticDimension) {
        myCellModel.iconCornerRadius = self.iconSize.height / 2;
    } else {
        myCellModel.iconCornerRadius = self.iconCornerRadius;
    }
}

@end
