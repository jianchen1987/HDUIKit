//
//  HDCategoryTitleExampleViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDCategoryTitleExampleViewController.h"
#import "HDCategoryContentViewController.h"
#import "HDOrderListChildViewControllerConfig.h"

@interface HDCategoryTitleExampleViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryIconTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 所有标题
@property (nonatomic, copy) NSArray<HDOrderListChildViewControllerConfig *> *configList;
@end

@implementation HDCategoryTitleExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.categoryTitleView];
}

- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(85);
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    HDCategoryContentViewController *listVC = self.configList[index].vc;
    return listVC;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
}

#pragma mark - lazy load
- (HDCategoryIconTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryIconTitleView.new;
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(HDOrderListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];

        _categoryTitleView.icons = [self.configList mapObjectsUsingBlock:^id _Nonnull(id _Nonnull obj, NSUInteger idx) {
            return @"https://www.baidu.com";
        }];

        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
//        _categoryTitleView.titleLabelAnchorPointStyle = HDCategoryTitleLabelAnchorPointStyleBottom;
        _categoryTitleView.titleLabelZoomEnabled = YES;
        _categoryTitleView.titleNumberOfLines = 2;
        _categoryTitleView.titleLabelVerticalOffset = 22;
        _categoryTitleView.relativePosition = HDCategoryIconRelativePositionTop;
        _categoryTitleView.iconSize = CGSizeMake(44, 44);
        _categoryTitleView.backgroundColor = UIColor.whiteColor;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        _categoryTitleView.indicators = @[lineView];
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}

- (NSArray<HDOrderListChildViewControllerConfig *> *)configList {
    if (!_configList) {
        NSMutableArray<HDOrderListChildViewControllerConfig *> *configList = [NSMutableArray arrayWithCapacity:4];
        HDCategoryContentViewController *vc = HDCategoryContentViewController.new;
        vc.orderState = 1;
        HDOrderListChildViewControllerConfig *config = [HDOrderListChildViewControllerConfig configWithTitle:@"所有订单" vc:vc];
        [configList addObject:config];

        vc = HDCategoryContentViewController.new;
        vc.orderState = 2;
        config = [HDOrderListChildViewControllerConfig configWithTitle:@"处理中处理中处理中" vc:vc];
        [configList addObject:config];

        vc = HDCategoryContentViewController.new;
        vc.orderState = 3;
        config = [HDOrderListChildViewControllerConfig configWithTitle:@"Welcome to china hahahah" vc:vc];
        [configList addObject:config];

        vc = HDCategoryContentViewController.new;
        vc.orderState = 4;
        config = [HDOrderListChildViewControllerConfig configWithTitle:@"退款中" vc:vc];
        [configList addObject:config];

        _configList = configList;
    }
    return _configList;
}
@end
