//
//  HDCategoryBaseCell.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryBaseCell.h"

@interface HDCategoryBaseCell ()
@property (nonatomic, strong) HDCategoryBaseCellModel *cellModel;
@property (nonatomic, strong) HDCategoryViewAnimator *animator;
@property (nonatomic, strong) NSMutableArray<HDCategoryCellSelectedAnimationBlock> *animationBlockArray;
@end

@implementation HDCategoryBaseCell

- (void)dealloc {
    [self.animator stop];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.animator stop];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    _animationBlockArray = [NSMutableArray array];
}

- (void)reloadData:(HDCategoryBaseCellModel *)cellModel {
    self.cellModel = cellModel;

    if (cellModel.isSelectedAnimationEnabled) {
        [self.animationBlockArray removeLastObject];
        if ([self checkCanStartSelectedAnimation:cellModel]) {
            _animator = [[HDCategoryViewAnimator alloc] init];
            self.animator.duration = cellModel.selectedAnimationDuration;
        } else {
            [self.animator stop];
        }
    }
}

- (BOOL)checkCanStartSelectedAnimation:(HDCategoryBaseCellModel *)cellModel {
    if (cellModel.selectedType == HDCategoryCellSelectedTypeCode || cellModel.selectedType == HDCategoryCellSelectedTypeClick) {
        return YES;
    }
    return NO;
}

- (void)addSelectedAnimationBlock:(HDCategoryCellSelectedAnimationBlock)block {
    [self.animationBlockArray addObject:block];
}

- (void)startSelectedAnimationIfNeeded:(HDCategoryBaseCellModel *)cellModel {
    if (cellModel.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:cellModel]) {
        //需要更新isTransitionAnimating，用于处理在过滤时，禁止响应点击，避免界面异常。
        cellModel.transitionAnimating = YES;
        __weak typeof(self) weakSelf = self;
        self.animator.progressCallback = ^(CGFloat percent) {
            for (HDCategoryCellSelectedAnimationBlock block in weakSelf.animationBlockArray) {
                block(percent);
            }
        };
        self.animator.completeCallback = ^{
            cellModel.transitionAnimating = NO;
            [weakSelf.animationBlockArray removeAllObjects];
        };
        [self.animator start];
    }
}

@end
