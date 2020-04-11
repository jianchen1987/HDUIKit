//
//  HDImageBrowserToolViewHandler.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDImageBrowserToolViewHandler.h"
#import "NSBundle+HDUIKit.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/HDFrameLayout.h>
#import <HDKitCore/UIImage+HDKitCore.h>
#import <HDUIKit/HDAppTheme.h>
#import <HDUIKit/HDUIButton.h>
#import <SDWebImage/SDWebImage.h>
#import <YBImageBrowser/YBImageBrowser.h>

@interface HDImageBrowserToolViewHandler ()
@property (nonatomic, strong) UIView *bottomToolBarView;    ///< 下方工具栏容器
@property (nonatomic, strong) HDUIButton *closeButton;      ///< 关闭按钮
@property (nonatomic, strong) HDUIButton *pageIndexButton;  ///< 页数按钮
@property (nonatomic, strong) UILabel *descLabel;           ///< 描述
@property (nonatomic, strong) HDUIButton *downloadButton;   ///< 下载按钮
@end

@implementation HDImageBrowserToolViewHandler

@synthesize yb_containerView = _yb_containerView;
@synthesize yb_currentData = _yb_currentData;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentOrientation = _yb_currentOrientation;

- (void)yb_containerViewIsReadied {
    [self.yb_containerView addSubview:self.closeButton];
    [self.yb_containerView addSubview:self.pageIndexButton];
    [self.yb_containerView addSubview:self.bottomToolBarView];
    [self.yb_containerView addSubview:self.descLabel];
    [self.yb_containerView addSubview:self.downloadButton];

    CGSize size = self.yb_containerSize(self.yb_currentOrientation());

    [self.closeButton hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(kRealWidth(5));
        make.top.hd_equalTo(kStatusBarH + kRealWidth(10));
    }];

    [self updatePageIndexButtonFrame];

    [self.downloadButton hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.bottom.hd_equalTo(size.height - 5 - kiPhoneXSeriesSafeBottomHeight);
        make.right.hd_equalTo(size.width - kRealWidth(5));
    }];

    [self updateDescLabelFrame];

    [self updateBottomToolBarViewFrame];
}

- (void)yb_hide:(BOOL)hide {
    self.closeButton.hidden = hide;
    YBImageBrowser *browser = (YBImageBrowser *)self.yb_containerView.superview;
    if (browser.dataSourceArray.count > 1) {
        self.pageIndexButton.hidden = hide;
    }
    self.bottomToolBarView.hidden = hide;
    self.descLabel.hidden = hide;
    self.downloadButton.hidden = hide;
}

- (void)yb_pageChanged {
    YBIBImageData *data = self.yb_currentData();
    self.descLabel.text = data.extraData;

    [self updateDescLabelFrame];
    [self updateBottomToolBarViewFrame];

    YBImageBrowser *browser = (YBImageBrowser *)self.yb_containerView.superview;
    if ([browser isKindOfClass:YBImageBrowser.class]) {
        [self setPage:browser.currentPage totalPage:browser.dataSourceArray.count];
    }
}

#pragma mark - private methods
- (void)setPage:(NSInteger)page totalPage:(NSInteger)totalPage {
    if (totalPage <= 1) {
        self.pageIndexButton.hidden = YES;
    } else {
        self.pageIndexButton.hidden = NO;

        NSAttributedString *currentIndexStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd", page + (NSInteger)1] attributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: HDAppTheme.font.standard2}];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:currentIndexStr];
        NSAttributedString *totalStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%zd", totalPage] attributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: HDAppTheme.font.standard4}];
        [attrStr appendAttributedString:totalStr];

        // 有原图就显示按钮
        [self.pageIndexButton setAttributedTitle:attrStr forState:UIControlStateNormal];

        [self updatePageIndexButtonFrame];
    }

    !self.willChangeToIndexBlock ?: self.willChangeToIndexBlock(page);

    // 更新投影 View
    YBImageBrowser *browser = (YBImageBrowser *)self.yb_containerView.superview;
    if ([browser isKindOfClass:YBImageBrowser.class]) {
        NSArray<YBIBImageData *> *array = browser.dataSourceArray;
        YBIBImageData *data = array[page];

        if (self.sourceView) {
            if (self.updateProjectiveViewBlock) {
                data.projectiveView = self.updateProjectiveViewBlock(page);
            }
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    !self.saveImageResultBlock ?: self.saveImageResultBlock(image, error);
}

- (void)updatePageIndexButtonFrame {
    const CGSize size = self.yb_containerSize(self.yb_currentOrientation());

    [self.pageIndexButton hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.centerX.hd_equalTo(size.width * 0.5);
        make.centerY.hd_equalTo(self.closeButton.centerY);
    }];
    self.pageIndexButton.layer.cornerRadius = CGRectGetHeight(self.pageIndexButton.frame) * 0.5;
}

- (void)updateDescLabelFrame {
    const CGSize size = self.yb_containerSize(self.yb_currentOrientation());

    const CGFloat descLabelLeft = kRealWidth(15), marginToRight = kRealWidth(10);
    const CGFloat maxWidth = self.downloadButton.left - descLabelLeft - marginToRight;
    [self.descLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(descLabelLeft);
        make.size.hd_equalTo([self.descLabel sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)]);
        make.bottom.hd_equalTo(size.height - 15 - kiPhoneXSeriesSafeBottomHeight);
    }];
}

- (void)updateBottomToolBarViewFrame {
    const CGSize size = self.yb_containerSize(self.yb_currentOrientation());

    [self.bottomToolBarView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.bottom.hd_equalTo(size.height);
        make.left.hd_equalTo(0);
        make.width.hd_equalTo(size.width);
        if (HDIsStringEmpty(self.descLabel.text)) {
            make.top.hd_equalTo(self.downloadButton.top).offset(-5);
        } else {
            make.top.hd_equalTo(self.descLabel.top).offset(-15);
        }
    }];
}

#pragma mark - event response
- (void)clickedCloseButtonHandler {
    YBImageBrowser *browser = (YBImageBrowser *)self.yb_containerView.superview;
    if ([browser isKindOfClass:YBImageBrowser.class]) {
        [browser hide];
    }
}

- (void)clickedDownloadButtonHandler {
    YBIBImageData *data = self.yb_currentData();
    NSURL *originURL = data.imageURL;
    SDWebImageDownloaderOptions options = SDWebImageDownloaderLowPriority | SDWebImageDownloaderAvoidDecodeImage;

    void (^completedBlock)(UIImage *_Nullable, NSData *_Nullable, NSError *_Nullable, BOOL) = ^void(UIImage *_Nullable image, NSData *_Nullable imageData, NSError *_Nullable error, BOOL finished) {
        // 仅当下载的 data 是当前显示的 data 时处理 UI
        if (data == self.yb_currentData()) {
            if (error) {
                return;
            }

            // 保存图片
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }

        // 终止处理数据
        [data stopLoading];
        // 清除缓存
        [data clearCache];
        // 清除原图地址
        data.extraData = nil;
        // 清除之前的图片数据
        data.imageURL = nil;
        // 赋值新的数据
        data.imageData = ^NSData *_Nullable {
            return imageData;
        };
        // 重载
        [data loadData];

        !self.downloadImageSuccessBlock ?: self.downloadImageSuccessBlock(image, originURL);
    };

    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:originURL
                                                          options:options
                                                          context:nil
                                                         progress:nil
                                                        completed:completedBlock];
}

#pragma mark - lazy load
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = UILabel.new;
        _descLabel.textColor = UIColor.whiteColor;
        _descLabel.userInteractionEnabled = false;
        _descLabel.font = HDAppTheme.font.standard2;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (HDUIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_downloadButton setImage:[UIImage imageNamed:@"download_icon" inBundle:[NSBundle hd_UIKITImageBrowserResources] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(clickedDownloadButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

- (HDUIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_closeButton setImage:[[UIImage imageNamed:@"ic-button-close" inBundle:[NSBundle hd_UIKITImageBrowserResources] compatibleWithTraitCollection:nil] hd_imageWithTintColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickedCloseButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (HDUIButton *)pageIndexButton {
    if (!_pageIndexButton) {
        _pageIndexButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _pageIndexButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        _pageIndexButton.enabled = false;
        _pageIndexButton.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        [_pageIndexButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _pageIndexButton.titleLabel.font = HDAppTheme.font.standard4;
    }
    return _pageIndexButton;
}

- (UIView *)bottomToolBarView {
    if (!_bottomToolBarView) {
        _bottomToolBarView = UIView.new;
        _bottomToolBarView.userInteractionEnabled = false;
        _bottomToolBarView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    }
    return _bottomToolBarView;
}
@end
