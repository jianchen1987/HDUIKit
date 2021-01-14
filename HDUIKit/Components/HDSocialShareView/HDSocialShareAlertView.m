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

#define kCollectionViewMargin 5
#define kCollectionCellCol 4.5

@interface HDSocialShareAlertView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;       ///< iPhoneX 系列底部填充
@property (nonatomic, strong) UILabel *titleLB;                             ///< 标题
@property (nonatomic, strong) UIView *titleLeftLine;                        ///< 标题左边线
@property (nonatomic, strong) UIView *titleRightLine;                       ///< 标题右边线
@property (nonatomic, strong) UICollectionView *shareCollectionView;        ///< 分享渠道容器
@property (nonatomic, strong) UICollectionView *functionCollectionView;     ///< 功能按钮容器
@property (nonatomic, strong) UIButton *cancelButton;                       ///< 取消按钮

@property (nonatomic, strong) HDSocialShareAlertViewConfig *config;             ///< 配置
@property (nonatomic, copy) NSString *title;                                    ///< 标题
@property (nonatomic, copy) NSString *cancelTitle;                              ///< 取消标题
@property (nonatomic, copy) NSArray<HDSocialShareCellModel *> *shareData;       ///< 分享渠道数据源
@property (nonatomic, copy) NSArray<HDSocialShareCellModel *> *functionData;    ///< 功能按钮数据源
@end

@implementation HDSocialShareAlertView
+ (instancetype)alertViewWithTitle:(NSString *__nullable)title cancelTitle:(NSString *__nullable)cancelTitle shareData:(NSArray<HDSocialShareCellModel *> *__nullable)shareData functionData:(NSArray<HDSocialShareCellModel *> *__nullable)functionData config:(HDSocialShareAlertViewConfig *__nullable)config {
    
    return [[self alloc] initWithTitle:title cancelTitle:cancelTitle shareData:shareData functionData:functionData config:config];
}

- (instancetype)initWithTitle:(NSString *__nullable)title cancelTitle:(NSString *__nullable)cancelTitle shareData:(NSArray<HDSocialShareCellModel *> *__nullable)shareData functionData:(NSArray<HDSocialShareCellModel *> *__nullable)functionData config:(HDSocialShareAlertViewConfig *__nullable)config {
    if (self = [super init]) {

        config = config ?: [[HDSocialShareAlertViewConfig alloc] init];

        _config = config;
        _shareData = shareData;
        _functionData = functionData;
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

    if (_shareData.count > 0 || _functionData.count > 0 || HDIsStringNotEmpty(_title)) {
        containerHeight += self.config.contentViewEdgeInsets.bottom;
    }

    if ((_shareData.count > 0 || _functionData.count > 0) && HDIsStringNotEmpty(_title)) {
        containerHeight += self.config.marginTitleToCollectionView;
    }

    if (_shareData.count > 0) {
        containerHeight += [self collectionViewSize].height;
    }
    
    if (_functionData.count > 0) {
        containerHeight += [self collectionViewSize].height;
    }
    
    if (_functionData.count > 0 && _shareData.count > 0) {
        containerHeight += kCollectionViewMargin;
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
        [self.containerView addSubview:self.titleLeftLine];
        [self.containerView addSubview:self.titleRightLine];
    }

    if (_shareData.count > 0) {
        [self.containerView addSubview:self.shareCollectionView];
    }
    
    if (_functionData.count > 0) {
        [self.containerView addSubview:self.functionCollectionView];
    }

    if (HDIsStringNotEmpty(_cancelTitle)) {
        [self.containerView addSubview:self.cancelButton];
    }

    if (iPhoneXSeries) {
        [self.containerView addSubview:self.iphoneXSeriousSafeAreaFillView];
    }
    
    self.containerView.backgroundColor = [HDAppTheme.color.G5 colorWithAlphaComponent:0.95];
}

/** 设置子视图的frame */
- (void)layoutContainerViewSubViews {

    CGFloat maxY = self.config.contentViewEdgeInsets.top;
    if (_titleLB) {
        self.titleLB.frame = (CGRect){0, maxY, [self titleLBSize]};
        self.titleLB.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.titleLB.frame));
        
        CGFloat titleLeftLineX = self.config.contentViewEdgeInsets.left + 10;
        CGFloat titleLeftLineW = CGRectGetMinX(self.titleLB.frame) - 20 - titleLeftLineX;
        self.titleLeftLine.frame = (CGRect){titleLeftLineX, 0, titleLeftLineW, 1};
        
        CGFloat titleRightLineX = CGRectGetMaxX(self.titleLB.frame) + 20;
        CGFloat titleRightLineW = CGRectGetWidth(self.frame) - titleRightLineX - self.config.contentViewEdgeInsets.right - 10;
        self.titleRightLine.frame = (CGRect){titleRightLineX, 0, titleRightLineW, 1};
        
        self.titleLeftLine.center = CGPointMake(CGRectGetMidX(self.titleLeftLine.frame), CGRectGetMidY(self.titleLB.frame));
        self.titleRightLine.center = CGPointMake(CGRectGetMidX(self.titleRightLine.frame), CGRectGetMidY(self.titleLB.frame));
        
        maxY = CGRectGetMaxY(self.titleLB.frame);
    }

    CGFloat collectionViewMargin = 0;
    if (_shareCollectionView) {
        CGFloat collectionViewY = _titleLB ? maxY + self.config.marginTitleToCollectionView : self.config.contentViewEdgeInsets.top;
        CGRect collectionViewframe = (CGRect){0, collectionViewY, [self collectionViewSize]};

        self.shareCollectionView.frame = collectionViewframe;
        
        maxY = CGRectGetMaxY(self.shareCollectionView.frame);
        collectionViewMargin = kCollectionViewMargin;
    }
    
    if (_functionCollectionView) {
        CGFloat collectionViewY = maxY + collectionViewMargin;
        CGRect collectionViewframe = (CGRect){0, collectionViewY, [self collectionViewSize]};

        self.functionCollectionView.frame = collectionViewframe;
        
        maxY = CGRectGetMaxY(self.functionCollectionView.frame);
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
    if (collectionView == _shareCollectionView) {
        return self.shareData.count;
    }
    return self.functionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDSocialShareCell *cell = [HDSocialShareCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    if (collectionView == _shareCollectionView) {
        cell.model = self.shareData[indexPath.row];
    } else {
        cell.model = self.functionData[indexPath.row];
    }
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
        if (collectionView == _shareCollectionView) {
            !self.clickedShareItemHandler ?: self.clickedShareItemHandler(self, model, indexPath.row);
        } else {
            !self.clickedFunctionItemHandler ?: self.clickedFunctionItemHandler(self, model, indexPath.row);
        }
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
    CGFloat viewWidth = kScreenWidth;

    CGFloat itemW = viewWidth / kCollectionCellCol;
    CGFloat itemH = itemW * self.config.cellHeightToWidthRadio;

    CGFloat viewHeight = itemH;
    return CGSizeMake(viewWidth, viewHeight);
}

- (CGSize)cancelButtonSize {
    if (HDIsStringEmpty(_cancelTitle)) return CGSizeZero;
    return CGSizeMake(CGRectGetWidth(self.containerView.frame), self.config.buttonHeight);
}

- (UICollectionView *)createNewCollectionView {
    const CGSize size = [self collectionViewSize];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置垂直滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置每个cell的尺寸
    const CGFloat itemW = size.width / kCollectionCellCol, itemH = itemW * self.config.cellHeightToWidthRadio;
    layout.itemSize = CGSizeMake(itemW, itemH);
    // cell之间的水平间距  行间距
    layout.minimumLineSpacing = self.config.minimumLineSpacing;
    // cell之间的垂直间距 cell间距
    layout.minimumInteritemSpacing = 0;
    // 设置四周边距
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, 100, 100) collectionViewLayout:layout];
    collectionView.showsVerticalScrollIndicator = false;
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.backgroundColor = UIColor.clearColor;
    [collectionView registerClass:HDSocialShareCell.class forCellWithReuseIdentifier:NSStringFromClass(HDSocialShareCell.class)];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    return collectionView;
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

- (UICollectionView *)shareCollectionView {
    if (!_shareCollectionView) {
        _shareCollectionView = [self createNewCollectionView];
    }
    return _shareCollectionView;
}

- (UICollectionView *)functionCollectionView {
    if (!_functionCollectionView) {
        _functionCollectionView = [self createNewCollectionView];
    }
    return _functionCollectionView;
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

- (UIView *)titleLeftLine {
    if (!_titleLeftLine) {
        _titleLeftLine = UIView.new;
        _titleLeftLine.backgroundColor = HexColor(0xD0D0D0);
    }
    return _titleLeftLine;
}

- (UIView *)titleRightLine {
    if (!_titleRightLine) {
        _titleRightLine = UIView.new;
        _titleRightLine.backgroundColor = HexColor(0xD0D0D0);
    }
    return _titleRightLine;
}

@end
