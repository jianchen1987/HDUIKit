//
//  HDImageScrollView.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HDImageScrollView.h"

#pragma mark -

@interface HDImageScrollView () <UIScrollViewDelegate> {
    CGSize _imageSize;
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}

@end

@implementation HDImageScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _aspectFill = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.scrollsToTop = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];

    [self centerZoomView];
}

- (void)setAspectFill:(BOOL)aspectFill {
    if (_aspectFill != aspectFill) {
        _aspectFill = aspectFill;

        if (_zoomView) {
            [self setMaxMinZoomScalesForCurrentBounds];

            if (self.zoomScale < self.minimumZoomScale) {
                self.zoomScale = self.minimumZoomScale;
            }
        }
    }
}

- (void)setFrame:(CGRect)frame {
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);

    if (sizeChanging) {
        [self prepareToResize];
    }

    [super setFrame:frame];

    if (sizeChanging) {
        [self recoverFromResizing];
    }

    [self centerZoomView];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _zoomView;
}

- (void)scrollViewDidZoom:(__unused UIScrollView *)scrollView {
    [self centerZoomView];
}

#pragma mark - 在 scrollView 中居中缩放视图

- (void)centerZoomView {
    // 中心缩放，使其小于屏幕尺寸
    CGFloat top = 0;
    CGFloat left = 0;

    // 垂直居中
    if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
        top = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5f;
    }
    // 水平居中
    if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
        left = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5f;
    }
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

#pragma mark - Configure scrollView to display new image

- (void)displayImage:(UIImage *)image {
    [_zoomView removeFromSuperview];
    _zoomView = nil;

    self.zoomScale = 1.0;

    _zoomView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_zoomView];

    [self configureForImageSize:image.size];
}

- (void)configureForImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setInitialZoomScale];
    [self setInitialContentOffset];
    self.contentInset = UIEdgeInsetsZero;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize = self.bounds.size;

    // 计算最大最小缩放比例
    // 完全适合图像宽度所需的比例
    CGFloat xScale = boundsSize.width / _imageSize.width;
    // 完全适合图像高度所需的比例
    CGFloat yScale = boundsSize.height / _imageSize.height;

    CGFloat minScale;
    if (!self.aspectFill) {
        // 使用小值，使图像完全可见
        minScale = MIN(xScale, yScale);
    } else {
        // 使用大值，使图像充满屏幕
        minScale = MAX(xScale, yScale);
    }

    CGFloat maxScale = MAX(xScale, yScale);

    // 即使图像尺寸较小，图像也必须适合/填满屏幕
    CGFloat xImageScale = maxScale * _imageSize.width / boundsSize.width;
    CGFloat yImageScale = maxScale * _imageSize.height / boundsSize.height;

    CGFloat maxImageScale = MAX(xImageScale, yImageScale);

    maxImageScale = MAX(minScale, maxImageScale);
    maxScale = MAX(maxScale, maxImageScale);

    // 不要让 minScale超过 maxScale（如果图像小于屏幕，不用强制将其缩放）
    if (minScale > maxScale) {
        minScale = maxScale;
    }

    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (void)setInitialZoomScale {
    CGSize boundsSize = self.bounds.size;
    // 完全适合图像宽度所需的比例
    CGFloat xScale = boundsSize.width / _imageSize.width;

    // 完全适合图像高度所需的比例
    CGFloat yScale = boundsSize.height / _imageSize.height;
    CGFloat scale = MAX(xScale, yScale);
    self.zoomScale = scale;
}

- (void)setInitialContentOffset {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.zoomView.frame;

    CGPoint contentOffset;
    if (CGRectGetWidth(frameToCenter) > boundsSize.width) {
        contentOffset.x = (CGRectGetWidth(frameToCenter) - boundsSize.width) * 0.5f;
    } else {
        contentOffset.x = 0;
    }
    if (CGRectGetHeight(frameToCenter) > boundsSize.height) {
        contentOffset.y = (CGRectGetHeight(frameToCenter) - boundsSize.height) * 0.5f;
    } else {
        contentOffset.y = 0;
    }

    [self setContentOffset:contentOffset];
}

#pragma mark - 旋转期间调用的方法，以保留zoomScale和图像的可见部分
#pragma mark - 旋转支持

- (void)prepareToResize {
    if (_zoomView == nil) {
        return;
    }

    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.zoomView];

    _scaleToRestoreAfterResize = self.zoomScale;

    // 如果处于最小缩放比例，返回 0 保留该比例，它将转换为最小缩放比例
    // 恢复后的比例
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing {
    if (_zoomView == nil) {
        return;
    }

    [self setMaxMinZoomScalesForCurrentBounds];

    // 恢复缩放比例，确保它在允许范围内
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);

    // 恢复中心点，确保它在允许范围内

    // 将想要的中心点转换回自己的坐标空间
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:self.zoomView];

    // 计算中心点偏移
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);

    // 恢复偏移量，调整到允许范围内
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];

    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);

    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);

    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset {
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset {
    return CGPointZero;
}

@end
