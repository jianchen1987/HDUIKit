//
//  HDScrollTitleBarViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/20.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDScrollTitleBarViewController.h"

@interface HDScrollTitleBarViewController ()

@property (nonatomic, strong) HDScrollNavBar *navBarView;  ///< 标题栏
@property (nonatomic, strong) UIScrollView *scrollView;    ///< 容器

@end

@implementation HDScrollTitleBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hd_fullScreenPopDisabled = true;

    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.scrollView];

    self.navBarView.contentScrollView = self.scrollView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.navBarView.frame = CGRectMake(0, CGRectGetMaxY(self.hd_navigationBar.frame), CGRectGetWidth(self.view.frame), 44);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navBarView.frame));
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.navBarView.dataSource.count, CGRectGetHeight(self.scrollView.frame));
}

- (HDScrollNavBar *)navBarView {
    if (!_navBarView) {
        _navBarView = [[HDScrollNavBar alloc] init];
        _navBarView.backgroundColor = [UIColor whiteColor];
        _navBarView.buttonTitleEdgeInsets = UIEdgeInsetsMake(0, 0, -15, 0);

        HDScrollTitleBarViewCellModel *model = [[HDScrollTitleBarViewCellModel alloc] init];
        model.title = @"附近";
        model.bubbleImage = [UIImage imageNamed:@"bubble_like"];
        HDScrollTitleBarViewCellModel *model2 = [[HDScrollTitleBarViewCellModel alloc] init];
        model2.title = @"商户代理";
        HDScrollTitleBarViewCellModel *model3 = [[HDScrollTitleBarViewCellModel alloc] init];
        model3.title = @"ViPay自营";
        HDScrollTitleBarViewCellModel *model4 = [[HDScrollTitleBarViewCellModel alloc] init];
        model4.title = @"Paygo";
        _navBarView.dataSource = @[model, model2, model3, model4];
        _navBarView.currentIndex = 0;
        _navBarView.sideMargin = 0;
        _navBarView.btnMargin = 10;
        _navBarView.isBtnWidthEqualAndExpandFullWidth = true;
        _navBarView.indicateLineWidth = 20;
        _navBarView.isIndicateLineAnimationEnabled = false;
        _navBarView.marginBottomToIndicateLine = 5;
    }
    return _navBarView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = UIColor.greenColor;
    }

    return _scrollView;
}
@end
