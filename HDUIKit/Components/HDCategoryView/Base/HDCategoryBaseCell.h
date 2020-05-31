//
//  HDCategoryBaseCell.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryBaseCellModel.h"
#import "HDCategoryViewAnimator.h"
#import "HDCategoryViewDefines.h"
#import <UIKit/UIKit.h>

@interface HDCategoryBaseCell : UICollectionViewCell

@property (nonatomic, strong, readonly) HDCategoryBaseCellModel *cellModel;
@property (nonatomic, strong, readonly) HDCategoryViewAnimator *animator;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData:(HDCategoryBaseCellModel *)cellModel NS_REQUIRES_SUPER;

- (BOOL)checkCanStartSelectedAnimation:(HDCategoryBaseCellModel *)cellModel;

- (void)addSelectedAnimationBlock:(HDCategoryCellSelectedAnimationBlock)block;

- (void)startSelectedAnimationIfNeeded:(HDCategoryBaseCellModel *)cellModel;
@end
