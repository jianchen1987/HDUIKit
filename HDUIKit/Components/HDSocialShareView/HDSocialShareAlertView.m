//
//  HDSocialShareAlertView.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSocialShareAlertView.h"
#import "HDAppTheme.h"
#import "HDSocialShareCell.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIView+HD_Extension.h>

@interface HDSocialShareAlertView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;  ///< iPhoneX 系列底部填充
@property (nonatomic, strong) UILabel *titleLB;                        ///< 标题
@property (nonatomic, strong) UICollectionView *collectionView;        ///< 容器
@property (nonatomic, strong) UIButton *cancelButton;                  ///< 取消按钮

@property (nonatomic, strong) HDSocialShareAlertViewConfig *config;         ///< 配置
@property (nonatomic, copy) NSString *title;                                ///< 标题
@property (nonatomic, copy) NSArray<HDSocialShareCellModel *> *dataSource;  ///< 数据源
@property (nonatomic, copy) NSString *cancelTitle;                          ///< 取消标题
@end

@implementation HDSocialShareAlertView
+ (instancetype)alertViewWithTitle:(NSString *__nullable)title cancelTitle:(NSString *__nullable)cancelTitle dataSource:(NSArray<HDSocialShareCellModel *> *)dataSource config:(HDSocialShareAlertViewConfig *__nullable)config {
    return [[self alloc] initWithTitle:title cancelTitle:cancelTitle dataSource:dataSource config:config];
}

- (instancetype)initWithTitle:(NSString *__nullable)title cancelTitle:(NSString *__nullable)cancelTitle dataSource:(NSArray<HDSocialShareCellModel *> *)dataSource config:(HDSocialShareAlertViewConfig *__nullable)config {
    if (self = [super init]) {

        config = config ?: [[HDSocialShareAlertViewConfig alloc] init];

        _config = config;
        _dataSource = dataSource;
        _title = title;
        _cancelTitle = cancelTitle;

        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.allowTapBackgroundDismiss = true;
    }
    return self;
}

/** 布局containerview的位置,就是那个看得到的视图 */
- (void)layoutContainerView {

    CGFloat left = 0;
    CGFloat containerHeight = 0;

    if (HDIsStringNotEmpty(_title)) {
        containerHeight += self.config.contentViewEdgeInsets.top;
        containerHeight += [self titleLBSize].height;
    }

    if (HDIsStringNotEmpty(_cancelTitle)) {
        containerHeight += [self cancelButtonSize].height;
    }

    if (_dataSource.count > 0 || HDIsStringNotEmpty(_title)) {
        containerHeight += self.config.contentViewEdgeInsets.bottom;
    }

    if (_dataSource.count && HDIsStringNotEmpty(_title)) {
        containerHeight += self.config.marginTitleToCollectionView;
    }

    if (_dataSource.count > 0) {
        containerHeight += [self collectionViewSize].height;
    }

    containerHeight += kiPhoneXSeriesSafeBottomHeight;

    CGFloat top = kScreenHeight - containerHeight;
    self.containerView.frame = CGRectMake(left, top, kScreenWidth, containerHeight);

    if (!CGSizeEqualToSize(self.containerView.frame.size, CGSizeZero)) {
        [self.containerView setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:self.config.containerCorner];
    }
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
}

/** 给containerview添加子视图 */
- (void)setupContainerSubViews {

    if (HDIsStringNotEmpty(_title)) {
        [self.containerView addSubview:self.titleLB];
    }

    if (_dataSource.count > 0) {
        [self.containerView addSubview:self.collectionView];
    }

    if (HDIsStringNotEmpty(_cancelTitle)) {
        [self.containerView addSubview:self.cancelButton];
    }

    if (iPhoneXSeries) {
        [self.containerView addSubview:self.iphoneXSeriousSafeAreaFillView];
    }
}

/** 设置子视图的frame */
- (void)layoutContainerViewSubViews {

    if (_titleLB) {
        self.titleLB.frame = (CGRect){self.config.contentViewEdgeInsets.left, self.config.contentViewEdgeInsets.top, [self titleLBSize]};
    }

    if (_collectionView) {
        CGFloat collectionViewY = _titleLB ? CGRectGetMaxY(self.titleLB.frame) + self.config.marginTitleToCollectionView : self.config.contentViewEdgeInsets.top;
        CGRect collectionViewframe = (CGRect){self.config.contentViewEdgeInsets.left, collectionViewY, [self collectionViewSize]};

        self.collectionView.frame = collectionViewframe;
    }

    if (_iphoneXSeriousSafeAreaFillView) {
        self.iphoneXSeriousSafeAreaFillView.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame) - kiPhoneXSeriesSafeBottomHeight, CGRectGetWidth(self.containerView.frame), kiPhoneXSeriesSafeBottomHeight);
    }

    if (_cancelTitle) {
        CGFloat cancelButtonBottom = _iphoneXSeriousSafeAreaFillView ? CGRectGetMinY(self.iphoneXSeriousSafeAreaFillView.frame) : CGRectGetHeight(self.containerView.frame);
        self.cancelButton.frame = (CGRect){0, cancelButtonBottom - [self cancelButtonSize].height, [self cancelButtonSize]};
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    HDSocialShareCell *cell = [HDSocialShareCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HDSocialShareCell *cell = (HDSocialShareCell *)[collectionView cellForItemAtIndexPath:indexPath];
    HDSocialShareCellModel *model = cell.model;

    // cell 回调优先级更高
    if (model.clickedHandler) {
        model.clickedHandler(model, indexPath.row);
    } else {
        !self.clickedShareItemHandler ?: self.clickedShareItemHandler(self, model, indexPath.row);
    }

    [self dismiss];
}

#pragma mark - private methods
- (CGSize)titleLBSize {
    if (HDIsStringEmpty(_title)) return CGSizeZero;

    const CGFloat maxTitleWidth = CGRectGetWidth(self.containerView.frame) - self.config.contentViewEdgeInsets.left - self.config.contentViewEdgeInsets.right;
    return [self.titleLB sizeThatFits:CGSizeMake(maxTitleWidth, MAXFLOAT)];
}

- (CGSize)collectionViewSize {
    if (_dataSource.count <= 0) return CGSizeZero;

    CGFloat viewWidth = kScreenWidth - self.config.contentViewEdgeInsets.left - self.config.contentViewEdgeInsets.right;

    NSInteger maxColumn = 4;
    NSInteger row = ceil(_dataSource.count / (double)maxColumn);

    // 最多四行
    if (row > 4) {
        row = 4;
    }

    const CGFloat itemHorizontalMargin = 5;

    CGFloat itemW = viewWidth / maxColumn;
    CGFloat itemH = itemW * self.config.cellHeightToWidthRadio;

    CGFloat viewHeight = itemH * row + (row - 1) * itemHorizontalMargin;
    return CGSizeMake(viewWidth, viewHeight);
}

- (CGSize)cancelButtonSize {
    if (HDIsStringEmpty(_cancelTitle)) return CGSizeZero;
    return CGSizeMake(CGRectGetWidth(self.containerView.frame), self.config.buttonHeight);
}

#pragma mark - event response
- (void)cancelBTNDidClicked {
    [self dismiss];
}

#pragma mark - lazy load
- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = self.title;
        _titleLB.textColor = self.config.titleColor;
        _titleLB.numberOfLines = 0;
        _titleLB.font = self.config.titleFont;
    }
    return _titleLB;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        const CGSize size = [self collectionViewSize];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置垂直滚动
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置每个cell的尺寸
        const CGFloat itemW = size.width / self.config.collectionCellCol, itemH = itemW * self.config.cellHeightToWidthRadio;
        layout.itemSize = CGSizeMake(itemW, itemH);
        // cell之间的水平间距  行间距
        layout.minimumLineSpacing = self.config.minimumLineSpacing;
        // cell之间的垂直间距 cell间距
        layout.minimumInteritemSpacing = 0;
        // 设置四周边距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, 100, 100) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:HDSocialShareCell.class forCellWithReuseIdentifier:NSStringFromClass(HDSocialShareCell.class)];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = self.config.cancelTitleFont;
        [_cancelButton setTitleColor:self.config.cancelTitleColor forState:UIControlStateNormal];
        _cancelButton.backgroundColor = self.config.cancelButtonBackgroundColor;
        [_cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelBTNDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)iphoneXSeriousSafeAreaFillView {
    if (!_iphoneXSeriousSafeAreaFillView) {
        _iphoneXSeriousSafeAreaFillView = [[UIView alloc] init];
        _iphoneXSeriousSafeAreaFillView.backgroundColor = self.config.cancelButtonBackgroundColor;
    }
    return _iphoneXSeriousSafeAreaFillView;
}
@end
