//
//  HDSkeletonLayerDataSourceProvider.m
//  HDUIKit
//
//  Created by VanJay on 2019/5/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSkeletonLayerDataSourceProvider.h"
#import "UIView+HDSkeleton.h"

@interface HDSkeletonLayerDataSourceProvider ()
@property (nonatomic, copy) HDSkeletonTableViewCellBlock tableViewCellBlock;  ///< cell block
@property (nonatomic, copy) HDSkeletonTableViewCellHeightBlock heightBlock;   ///< cell height block
@property (nonatomic, copy) NSString *reuseIdentifier;                        ///< 重用标志
@end

@implementation HDSkeletonLayerDataSourceProvider
- (instancetype)initWithCellReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super init]) {
        _reuseIdentifier = reuseIdentifier;
        _numberOfRowsInSection = 20;
    }
    return self;
}

+ (instancetype)dataSourceProviderWithCellReuseIdentifier:(NSString *)reuseIdentifier {
    return [[[self class] alloc] initWithCellReuseIdentifier:reuseIdentifier];
}

- (instancetype)initWithTableViewCellBlock:(HDSkeletonTableViewCellBlock)block heightBlock:(HDSkeletonTableViewCellHeightBlock)heightBlock {
    if (self = [super init]) {
        _tableViewCellBlock = block;
        _heightBlock = heightBlock;
        _numberOfRowsInSection = 20;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_reuseIdentifier) {
        return tableView.rowHeight;
    } else {
        return _heightBlock(tableView, indexPath);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_reuseIdentifier) {
        return [tableView dequeueReusableCellWithIdentifier:_reuseIdentifier forIndexPath:indexPath];
    } else {
        return _tableViewCellBlock(tableView, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_beginSkeletonAnimation];
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _numberOfRowsInSection;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_beginSkeletonAnimation];
}
@end
