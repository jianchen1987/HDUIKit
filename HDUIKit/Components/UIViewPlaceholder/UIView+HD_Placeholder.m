//
//  UIView+HD_Placeholder.m
//  HDUIKit
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDPlaceholderView.h"
#import "UIView+HD_Placeholder.h"
#import "UIViewPlaceholderViewModel.h"
#import <HDKitCore/HDAssociatedObjectHelper.h>

@interface UIView ()
@property (nonatomic, strong) HDPlaceholderView *hd_placeholderView;  ///< 占位控件
@end

@implementation UIView (hd_Placeholder)

- (void)hd_showPlaceholderViewWithModel:(UIViewPlaceholderViewModel *__nullable)model {

    model = model ?: [[UIViewPlaceholderViewModel alloc] init];

    if (!self.hd_placeholderView) {
        self.hd_placeholderView = [[HDPlaceholderView alloc] init];

        if (self.superview) {
            if ([self isKindOfClass:UITableView.class]) {
                UITableView *tableView = (UITableView *)self;
                if (tableView.backgroundView) {
                    [tableView.backgroundView addSubview:self.hd_placeholderView];
                } else {
                    tableView.backgroundView = self.hd_placeholderView;
                }
            } else if ([self isKindOfClass:UICollectionView.class]) {
                UICollectionView *collectionView = (UICollectionView *)self;
                if (collectionView.backgroundView) {
                    [collectionView.backgroundView addSubview:self.hd_placeholderView];
                } else {
                    collectionView.backgroundView = self.hd_placeholderView;
                }
            } else {
                // 父视图为_UIParallaxDimmingView时，说明正在执行页面跳转动画
                // 不能加到_UIParallaxDimmingView视图上，否则动画结束后，添加的hd_placeholderView就会被移除
                if ([NSStringFromClass(self.superview.class) isEqualToString:@"_UIParallaxDimmingView"]) {
                    [self addSubview:self.hd_placeholderView];
                } else {
                    [self.superview insertSubview:self.hd_placeholderView aboveSubview:self];
                }
            }
        } else {
            [self addSubview:self.hd_placeholderView];
        }
    }

    self.hd_placeholderView.backgroundColor = [self.backgroundColor isEqual:UIColor.clearColor] ? UIColor.whiteColor : self.backgroundColor;
    __weak __typeof(self) weakSelf = self;
    self.hd_placeholderView.tappedRefreshBtnHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hd_removePlaceholderView];
        !strongSelf.hd_tappedRefreshBtnHandler ?: strongSelf.hd_tappedRefreshBtnHandler();
    };
    self.hd_placeholderView.hidden = false;

    [self hd_addPlaceholderViewConstraintsWithModel:model];
}

- (void)hd_addPlaceholderViewConstraintsWithModel:(UIViewPlaceholderViewModel *)model {

    if ([self isKindOfClass:UITableView.class]) {
        UITableView *tableView = (UITableView *)self;
        UIView *headerView = tableView.tableHeaderView;
        UIView *footView = tableView.tableFooterView;

        self.hd_placeholderView.frame = CGRectMake(0, headerView.bounds.size.height, tableView.bounds.size.width, tableView.bounds.size.height - headerView.bounds.size.height - footView.bounds.size.height);
    } else if ([self isKindOfClass:UICollectionView.class]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        self.hd_placeholderView.frame = collectionView.bounds;
    } else {
        self.hd_placeholderView.frame = self.frame;
    }

    if (!self.hd_placeholderView) return;

    self.hd_placeholderView.model = model;
}

- (void)hd_removePlaceholderView {

    if ([self isKindOfClass:UITableView.class]) {
        UITableView *tableView = (UITableView *)self;
        if (tableView.backgroundView != self.hd_placeholderView) {
            [self.hd_placeholderView removeFromSuperview];
            self.hd_placeholderView = nil;
        } else {
            self.hd_placeholderView.hidden = true;
        }
    } else if ([self isKindOfClass:UICollectionView.class]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        if (collectionView.backgroundView != self.hd_placeholderView) {
            [self.hd_placeholderView removeFromSuperview];
            self.hd_placeholderView = nil;
        } else {
            self.hd_placeholderView.hidden = true;
        }
    } else {
        if (self.hd_placeholderView) {
            [self.hd_placeholderView removeFromSuperview];
            self.hd_placeholderView = nil;
        }
    }
}

- (void)updatePl_currentPlaceholderViewModel:(UIViewPlaceholderViewModel *)model {
    [self hd_showPlaceholderViewWithModel:model];
}

#pragma mark - getters and setters
HDSynthesizeIdStrongProperty(hd_placeholderView, setHd_placeholderView);
HDSynthesizeIdCopyProperty(hd_tappedRefreshBtnHandler, setHd_tappedRefreshBtnHandler);
@end
