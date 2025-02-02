//
//  HDImageCropViewController.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDImageCropViewController.h"
#import "CGGeometry+HDImageCropper.h"
#import "HDImageCropperTouchView.h"
#import "HDImageScrollView.h"
#import "UIImage+HDImageCropper.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDAppTheme.h>
#import <Masonry/Masonry.h>

static const CGFloat kResetAnimationDuration = 0.4;
static const CGFloat kLayoutImageScrollViewAnimationDuration = 0.25;

@interface HDImageCropViewController () <UIGestureRecognizerDelegate>
@property (assign, nonatomic) BOOL originalNavigationControllerNavigationBarHidden;
@property (strong, nonatomic) UIImage *originalNavigationControllerNavigationBarShadowImage;
@property (copy, nonatomic) UIColor *originalNavigationControllerViewBackgroundColor;
@property (assign, nonatomic) BOOL originalStatusBarHidden;

@property (strong, nonatomic) HDImageScrollView *imageScrollView;
@property (strong, nonatomic) HDImageCropperTouchView *overlayView;
@property (strong, nonatomic) CAShapeLayer *maskLayer;

@property (assign, nonatomic) CGRect maskRect;
@property (copy, nonatomic) UIBezierPath *maskPath;

@property (readonly, nonatomic) CGRect rectForMaskPath;
@property (readonly, nonatomic) CGRect rectForClipPath;

@property (readonly, nonatomic) CGRect imageRect;

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *chooseButton;

@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationGestureRecognizer;
@end

@implementation HDImageCropViewController

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _avoidEmptySpaceAroundImage = NO;
        _alwaysBounceVertical = NO;
        _alwaysBounceHorizontal = NO;
        _applyMaskToCroppedImage = NO;
        _maskLayerLineWidth = 1.0;
        _rotationEnabled = NO;
        _cropMode = HDImageCropModeCircle;

        _portraitCircleMaskRectInnerEdgeInset = 15.0f;
        _portraitSquareMaskRectInnerEdgeInset = 20.0f;
        _landscapeCircleMaskRectInnerEdgeInset = 45.0f;
        _landscapeSquareMaskRectInnerEdgeInset = 45.0f;

        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)originalImage {
    self = [self init];
    if (self) {
        _originalImage = originalImage;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)originalImage cropMode:(HDImageCropMode)cropMode {
    self = [self initWithImage:originalImage];
    if (self) {
        _cropMode = cropMode;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    if (@available(iOS 11.0, *)) {
        self.imageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;

    if (self.delegate && [self.delegate respondsToSelector:@selector(localizedTitleForChooseButton)]) {
        [self.chooseButton setTitle:[self.delegate localizedTitleForChooseButton] forState:UIControlStateNormal];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(localizedTitleForCancelButton)]) {
        [self.cancelButton setTitle:[self.delegate localizedTitleForCancelButton] forState:UIControlStateNormal];
    }

    [self.view addSubview:self.imageScrollView];
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.chooseButton];

    [self.view addGestureRecognizer:self.doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:self.rotationGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([self respondsToSelector:@selector(prefersStatusBarHidden)] == NO) {
        UIApplication *application = [UIApplication sharedApplication];
        if (application) {
            self.originalStatusBarHidden = application.statusBarHidden;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [application setStatusBarHidden:YES];
#pragma clang diagnostic pop
        }
    }

    if (!self.presentingViewController) {
        self.originalNavigationControllerNavigationBarHidden = self.navigationController.navigationBarHidden;
        [self.navigationController setNavigationBarHidden:YES animated:NO];

        self.originalNavigationControllerNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
        self.navigationController.navigationBar.shadowImage = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.presentingViewController) {
        self.originalNavigationControllerViewBackgroundColor = self.navigationController.view.backgroundColor;
        self.navigationController.view.backgroundColor = [UIColor blackColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if ([self respondsToSelector:@selector(prefersStatusBarHidden)] == NO) {
        UIApplication *application = [UIApplication sharedApplication];
        if (application) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [application setStatusBarHidden:self.originalStatusBarHidden];
#pragma clang diagnostic pop
        }
    }

    if (!self.presentingViewController) {
        [self.navigationController setNavigationBarHidden:self.originalNavigationControllerNavigationBarHidden animated:animated];
        self.navigationController.navigationBar.shadowImage = self.originalNavigationControllerNavigationBarShadowImage;
        self.navigationController.view.backgroundColor = self.originalNavigationControllerViewBackgroundColor;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [self updateMaskRect];
    [self layoutImageScrollView];
    [self layoutOverlayView];
    [self updateMaskPath];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (!self.imageScrollView.zoomView) {
        [self displayImage];
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.cancelButton sizeToFit];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.isPortraitInterfaceOrientation) {
            make.left.equalTo(self.view).offset(HDAppTheme.value.padding.left);
            make.bottom.equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
        } else {
            make.left.equalTo(self.view).offset(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20));
            make.bottom.equalTo(self.view).offset(-kRealWidth(20));
        }
    }];

    [self.chooseButton sizeToFit];
    [self.chooseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.isPortraitInterfaceOrientation) {
            make.right.equalTo(self.view).offset(-HDAppTheme.value.padding.right);
            make.bottom.equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
        } else {
            make.right.equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
            make.bottom.equalTo(self.view).offset(-kRealWidth(20));
        }
    }];
}

#pragma mark - Custom Accessors

- (HDImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[HDImageScrollView alloc] init];
        _imageScrollView.clipsToBounds = NO;
        _imageScrollView.aspectFill = self.avoidEmptySpaceAroundImage;
        _imageScrollView.alwaysBounceHorizontal = self.alwaysBounceHorizontal;
        _imageScrollView.alwaysBounceVertical = self.alwaysBounceVertical;
    }
    return _imageScrollView;
}

- (HDImageCropperTouchView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[HDImageCropperTouchView alloc] init];
        _overlayView.receiver = self.imageScrollView;
        [_overlayView.layer addSublayer:self.maskLayer];
    }
    return _overlayView;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.fillColor = self.maskLayerColor.CGColor;
        _maskLayer.lineWidth = self.maskLayerLineWidth;
        _maskLayer.strokeColor = self.maskLayerStrokeColor.CGColor;
    }
    return _maskLayer;
}

- (UIColor *)maskLayerColor {
    if (!_maskLayerColor) {
        _maskLayerColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    }
    return _maskLayerColor;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.opaque = NO;
    }
    return _cancelButton;
}

- (UIButton *)chooseButton {
    if (!_chooseButton) {
        _chooseButton = [[UIButton alloc] init];
        _chooseButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_chooseButton setTitle:@"选择" forState:UIControlStateNormal];
        [_chooseButton addTarget:self action:@selector(onChooseButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        _chooseButton.opaque = NO;
    }
    return _chooseButton;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer {
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.delaysTouchesEnded = NO;
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        _doubleTapGestureRecognizer.delegate = self;
    }
    return _doubleTapGestureRecognizer;
}

- (UIRotationGestureRecognizer *)rotationGestureRecognizer {
    if (!_rotationGestureRecognizer) {
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
        _rotationGestureRecognizer.delaysTouchesEnded = NO;
        _rotationGestureRecognizer.delegate = self;
        _rotationGestureRecognizer.enabled = self.isRotationEnabled;
    }
    return _rotationGestureRecognizer;
}

- (CGRect)imageRect {
    float zoomScale = 1.0 / self.imageScrollView.zoomScale;

    CGRect imageRect = CGRectZero;

    imageRect.origin.x = self.imageScrollView.contentOffset.x * zoomScale;
    imageRect.origin.y = self.imageScrollView.contentOffset.y * zoomScale;
    imageRect.size.width = CGRectGetWidth(self.imageScrollView.bounds) * zoomScale;
    imageRect.size.height = CGRectGetHeight(self.imageScrollView.bounds) * zoomScale;

    imageRect = HDRectNormalize(imageRect);

    CGSize imageSize = self.originalImage.size;
    CGFloat x = CGRectGetMinX(imageRect);
    CGFloat y = CGRectGetMinY(imageRect);
    CGFloat width = CGRectGetWidth(imageRect);
    CGFloat height = CGRectGetHeight(imageRect);

    UIImageOrientation imageOrientation = self.originalImage.imageOrientation;
    if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
        imageRect.origin.x = y;
        imageRect.origin.y = floor(imageSize.width - CGRectGetWidth(imageRect) - x);
        imageRect.size.width = height;
        imageRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
        imageRect.origin.x = floor(imageSize.height - CGRectGetHeight(imageRect) - y);
        imageRect.origin.y = x;
        imageRect.size.width = height;
        imageRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
        imageRect.origin.x = floor(imageSize.width - CGRectGetWidth(imageRect) - x);
        imageRect.origin.y = floor(imageSize.height - CGRectGetHeight(imageRect) - y);
    }

    CGFloat imageScale = self.originalImage.scale;
    imageRect = CGRectApplyAffineTransform(imageRect, CGAffineTransformMakeScale(imageScale, imageScale));

    return imageRect;
}

- (CGRect)cropRect {
    CGRect maskRect = self.maskRect;
    CGFloat rotationAngle = self.rotationAngle;
    CGRect rotatedImageScrollViewFrame = self.imageScrollView.frame;
    float zoomScale = 1.0 / self.imageScrollView.zoomScale;

    CGAffineTransform imageScrollViewTransform = self.imageScrollView.transform;
    self.imageScrollView.transform = CGAffineTransformIdentity;

    CGPoint imageScrollViewContentOffset = self.imageScrollView.contentOffset;
    CGRect imageScrollViewFrame = self.imageScrollView.frame;
    self.imageScrollView.frame = self.maskRect;

    CGRect imageFrame = CGRectZero;
    imageFrame.origin.x = CGRectGetMinX(maskRect) - self.imageScrollView.contentOffset.x;
    imageFrame.origin.y = CGRectGetMinY(maskRect) - self.imageScrollView.contentOffset.y;
    imageFrame.size = self.imageScrollView.contentSize;

    CGFloat tx = CGRectGetMinX(imageFrame) + self.imageScrollView.contentOffset.x + CGRectGetWidth(maskRect) * 0.5f;
    CGFloat ty = CGRectGetMinY(imageFrame) + self.imageScrollView.contentOffset.y + CGRectGetHeight(maskRect) * 0.5f;

    CGFloat sx = CGRectGetWidth(rotatedImageScrollViewFrame) / CGRectGetWidth(imageScrollViewFrame);
    CGFloat sy = CGRectGetHeight(rotatedImageScrollViewFrame) / CGRectGetHeight(imageScrollViewFrame);

    CGAffineTransform t1 = CGAffineTransformMakeTranslation(-tx, -ty);
    CGAffineTransform t2 = CGAffineTransformMakeRotation(rotationAngle);
    CGAffineTransform t3 = CGAffineTransformMakeScale(sx, sy);
    CGAffineTransform t4 = CGAffineTransformMakeTranslation(tx, ty);
    CGAffineTransform t1t2 = CGAffineTransformConcat(t1, t2);
    CGAffineTransform t1t2t3 = CGAffineTransformConcat(t1t2, t3);
    CGAffineTransform t1t2t3t4 = CGAffineTransformConcat(t1t2t3, t4);

    imageFrame = CGRectApplyAffineTransform(imageFrame, t1t2t3t4);

    CGRect cropRect = CGRectMake(0.0, 0.0, CGRectGetWidth(maskRect), CGRectGetHeight(maskRect));

    cropRect.origin.x = -CGRectGetMinX(imageFrame) + CGRectGetMinX(maskRect);
    cropRect.origin.y = -CGRectGetMinY(imageFrame) + CGRectGetMinY(maskRect);

    cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(zoomScale, zoomScale));

    cropRect = HDRectNormalize(cropRect);

    CGFloat imageScale = self.originalImage.scale;
    cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(imageScale, imageScale));

    self.imageScrollView.frame = imageScrollViewFrame;
    self.imageScrollView.contentOffset = imageScrollViewContentOffset;
    self.imageScrollView.transform = imageScrollViewTransform;

    return cropRect;
}

- (CGRect)rectForClipPath {
    if (!self.maskLayerStrokeColor) {
        return self.overlayView.frame;
    } else {
        CGFloat maskLayerLineHalfWidth = self.maskLayerLineWidth / 2.0;
        return CGRectInset(self.overlayView.frame, -maskLayerLineHalfWidth, -maskLayerLineHalfWidth);
    }
}

- (CGRect)rectForMaskPath {
    if (!self.maskLayerStrokeColor) {
        return self.maskRect;
    } else {
        CGFloat maskLayerLineHalfWidth = self.maskLayerLineWidth / 2.0;
        return CGRectInset(self.maskRect, maskLayerLineHalfWidth, maskLayerLineHalfWidth);
    }
}

- (CGFloat)rotationAngle {
    CGAffineTransform transform = self.imageScrollView.transform;
    CGFloat rotationAngle = atan2(transform.b, transform.a);
    return rotationAngle;
}

- (CGFloat)zoomScale {
    return self.imageScrollView.zoomScale;
}

- (void)setAvoidEmptySpaceAroundImage:(BOOL)avoidEmptySpaceAroundImage {
    if (_avoidEmptySpaceAroundImage != avoidEmptySpaceAroundImage) {
        _avoidEmptySpaceAroundImage = avoidEmptySpaceAroundImage;

        self.imageScrollView.aspectFill = avoidEmptySpaceAroundImage;
    }
}

- (void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical {
    if (_alwaysBounceVertical != alwaysBounceVertical) {
        _alwaysBounceVertical = alwaysBounceVertical;

        self.imageScrollView.alwaysBounceVertical = alwaysBounceVertical;
    }
}

- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal {
    if (_alwaysBounceHorizontal != alwaysBounceHorizontal) {
        _alwaysBounceHorizontal = alwaysBounceHorizontal;

        self.imageScrollView.alwaysBounceHorizontal = alwaysBounceHorizontal;
    }
}

- (void)setCropMode:(HDImageCropMode)cropMode {
    if (_cropMode != cropMode) {
        _cropMode = cropMode;

        if (self.imageScrollView.zoomView) {
            [self reset:NO];
        }
    }
}

- (void)setOriginalImage:(UIImage *)originalImage {
    if (![_originalImage isEqual:originalImage]) {
        _originalImage = originalImage;
        if (self.isViewLoaded && self.view.window) {
            [self displayImage];
        }
    }
}

- (void)setMaskPath:(UIBezierPath *)maskPath {
    if (![_maskPath isEqual:maskPath]) {
        _maskPath = maskPath;

        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.rectForClipPath];
        [clipPath appendPath:maskPath];
        clipPath.usesEvenOddFillRule = YES;

        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = [CATransaction animationDuration];
        pathAnimation.timingFunction = [CATransaction animationTimingFunction];
        [self.maskLayer addAnimation:pathAnimation forKey:@"path"];

        self.maskLayer.path = [clipPath CGPath];
    }
}

- (void)setRotationAngle:(CGFloat)rotationAngle {
    if (self.rotationAngle != rotationAngle) {
        CGFloat rotation = (rotationAngle - self.rotationAngle);
        CGAffineTransform transform = CGAffineTransformRotate(self.imageScrollView.transform, rotation);
        self.imageScrollView.transform = transform;
        [self layoutImageScrollView];
    }
}

- (void)setRotationEnabled:(BOOL)rotationEnabled {
    if (_rotationEnabled != rotationEnabled) {
        _rotationEnabled = rotationEnabled;

        self.rotationGestureRecognizer.enabled = rotationEnabled;
    }
}

- (void)setZoomScale:(CGFloat)zoomScale {
    self.imageScrollView.zoomScale = zoomScale;
}

#pragma mark - Action handling

- (void)onCancelButtonTouch:(UIBarButtonItem *)sender {
    [self cancelCrop];
}

- (void)onChooseButtonTouch:(UIBarButtonItem *)sender {
    [self cropImage];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    [self reset:YES];
}

- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer {
    CGFloat rotation = gestureRecognizer.rotation;
    CGAffineTransform transform = CGAffineTransformRotate(self.imageScrollView.transform, rotation);
    self.imageScrollView.transform = transform;

    gestureRecognizer.rotation = 0;

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:kLayoutImageScrollViewAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self layoutImageScrollView];
                         }
                         completion:nil];
    }
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
    [self.imageScrollView zoomToRect:rect animated:animated];
}

#pragma mark - Public

- (BOOL)isPortraitInterfaceOrientation {
    return CGRectGetHeight(self.view.bounds) > CGRectGetWidth(self.view.bounds);
}

#pragma mark - Private

- (void)reset:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:@"hd_reset" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:kResetAnimationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }

    [self resetRotation];
    [self resetZoomScale];
    [self resetContentOffset];

    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)resetContentOffset {
    CGSize boundsSize = self.imageScrollView.bounds.size;
    CGRect frameToCenter = self.imageScrollView.zoomView.frame;

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

    self.imageScrollView.contentOffset = contentOffset;
}

- (void)resetRotation {
    [self setRotationAngle:0.0];
}

- (void)resetZoomScale {
    CGFloat zoomScale;
    if (CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds)) {
        zoomScale = CGRectGetHeight(self.view.bounds) / self.originalImage.size.height;
    } else {
        zoomScale = CGRectGetWidth(self.view.bounds) / self.originalImage.size.width;
    }
    self.imageScrollView.zoomScale = zoomScale;
}

- (NSArray *)intersectionPointsOfLineSegment:(HDLineSegment)lineSegment withRect:(CGRect)rect {
    HDLineSegment top = HDLineSegmentMake(CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)),
                                          CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)));

    HDLineSegment right = HDLineSegmentMake(CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)),
                                            CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)));

    HDLineSegment bottom = HDLineSegmentMake(CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)),
                                             CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)));

    HDLineSegment left = HDLineSegmentMake(CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)),
                                           CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)));

    CGPoint p0 = HDLineSegmentIntersection(top, lineSegment);
    CGPoint p1 = HDLineSegmentIntersection(right, lineSegment);
    CGPoint p2 = HDLineSegmentIntersection(bottom, lineSegment);
    CGPoint p3 = HDLineSegmentIntersection(left, lineSegment);

    NSMutableArray *intersectionPoints = [@[] mutableCopy];
    if (!HDPointIsNull(p0)) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p0]];
    }
    if (!HDPointIsNull(p1)) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p1]];
    }
    if (!HDPointIsNull(p2)) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p2]];
    }
    if (!HDPointIsNull(p3)) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p3]];
    }

    return [intersectionPoints copy];
}

- (void)displayImage {
    if (self.originalImage) {
        [self.imageScrollView displayImage:self.originalImage];
        [self reset:NO];

        if ([self.delegate respondsToSelector:@selector(imageCropViewControllerDidDisplayImage:)]) {
            [self.delegate imageCropViewControllerDidDisplayImage:self];
        }
    }
}

- (void)centerImageScrollViewZoomView {
    // 当 imageScrollView.zoomView 小于屏幕大小时，将其居中

    CGPoint contentOffset = self.imageScrollView.contentOffset;

    // 垂直居中
    if (self.imageScrollView.contentSize.height < CGRectGetHeight(self.imageScrollView.bounds)) {
        contentOffset.y = -(CGRectGetHeight(self.imageScrollView.bounds) - self.imageScrollView.contentSize.height) * 0.5f;
    }

    // 水平居中
    if (self.imageScrollView.contentSize.width < CGRectGetWidth(self.imageScrollView.bounds)) {
        contentOffset.x = -(CGRectGetWidth(self.imageScrollView.bounds) - self.imageScrollView.contentSize.width) * 0.5f;
        ;
    }

    self.imageScrollView.contentOffset = contentOffset;
}

- (void)layoutImageScrollView {
    CGRect frame = CGRectZero;

    switch (self.cropMode) {
        case HDImageCropModeSquare: {
            if (self.rotationAngle == 0.0) {
                frame = self.maskRect;
            } else {
                // 通过`rotationAngle`围绕中心顺时针旋转图像滚动视图的初始矩形的左边缘
                CGRect initialRect = self.maskRect;
                CGFloat rotationAngle = self.rotationAngle;

                CGPoint leftTopPoint = CGPointMake(initialRect.origin.x, initialRect.origin.y);
                CGPoint leftBottomPoint = CGPointMake(initialRect.origin.x, initialRect.origin.y + initialRect.size.height);
                HDLineSegment leftLineSegment = HDLineSegmentMake(leftTopPoint, leftBottomPoint);

                CGPoint pivot = HDRectCenterPoint(initialRect);

                CGFloat alpha = fabs(rotationAngle);
                HDLineSegment rotatedLeftLineSegment = HDLineSegmentRotateAroundPoint(leftLineSegment, pivot, alpha);

                // 求出旋转边与初始矩形的交点
                NSArray *points = [self intersectionPointsOfLineSegment:rotatedLeftLineSegment withRect:initialRect];

                // 如果相交点数不止一个
                // 则旋转的图像滚动视图的边界不会完全填满遮罩区域。
                // 因此，我们需要更新图像滚动视图的框架。
                // 否则，我们可以使用初始rect
                if (points.count > 1) {
                    // 直角三角形

                    // 计算直角三角形的高度
                    if ((alpha > M_PI_2) && (alpha < M_PI)) {
                        alpha = alpha - M_PI_2;
                    } else if ((alpha > (M_PI + M_PI_2)) && (alpha < (M_PI + M_PI))) {
                        alpha = alpha - (M_PI + M_PI_2);
                    }
                    CGFloat sinAlpha = sin(alpha);
                    CGFloat cosAlpha = cos(alpha);
                    CGFloat hypotenuse = HDPointDistance([points[0] CGPointValue], [points[1] CGPointValue]);
                    CGFloat altitude = hypotenuse * sinAlpha * cosAlpha;

                    // 计算目标宽度
                    CGFloat initialWidth = CGRectGetWidth(initialRect);
                    CGFloat targetWidth = initialWidth + altitude * 2;

                    // 计算目标 frame
                    CGFloat scale = targetWidth / initialWidth;
                    CGPoint center = HDRectCenterPoint(initialRect);
                    frame = HDRectScaleAroundPoint(initialRect, center, scale, scale);

                    // 精度修正
                    frame.origin.x = floor(CGRectGetMinX(frame));
                    frame.origin.y = floor(CGRectGetMinY(frame));
                    frame = CGRectIntegral(frame);
                } else {
                    // 使用初始 rect
                    frame = initialRect;
                }
            }
            break;
        }
        case HDImageCropModeCircle: {
            frame = self.maskRect;
            break;
        }
        case HDImageCropModeCustom: {
            frame = [self.dataSource imageCropViewControllerCustomMovementRect:self];
            break;
        }
    }

    CGAffineTransform transform = self.imageScrollView.transform;
    self.imageScrollView.transform = CGAffineTransformIdentity;

    self.imageScrollView.frame = frame;
    [self centerImageScrollViewZoomView];

    self.imageScrollView.transform = transform;
}

- (void)layoutOverlayView {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) * 2, CGRectGetHeight(self.view.bounds) * 2);
    self.overlayView.frame = frame;
}

- (void)updateMaskRect {
    switch (self.cropMode) {
        case HDImageCropModeCircle: {
            CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.bounds);

            CGFloat diameter;
            if ([self isPortraitInterfaceOrientation]) {
                diameter = MIN(viewWidth, viewHeight) - self.portraitCircleMaskRectInnerEdgeInset * 2;
            } else {
                diameter = MIN(viewWidth, viewHeight) - self.landscapeCircleMaskRectInnerEdgeInset * 2;
            }

            CGSize maskSize = CGSizeMake(diameter, diameter);

            self.maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                       (viewHeight - maskSize.height) * 0.5f,
                                       maskSize.width,
                                       maskSize.height);
            break;
        }
        case HDImageCropModeSquare: {
            CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.bounds);

            CGFloat length;
            if ([self isPortraitInterfaceOrientation]) {
                length = MIN(viewWidth, viewHeight) - self.portraitSquareMaskRectInnerEdgeInset * 2;
            } else {
                length = MIN(viewWidth, viewHeight) - self.landscapeSquareMaskRectInnerEdgeInset * 2;
            }

            CGSize maskSize = CGSizeMake(length, length);

            self.maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                       (viewHeight - maskSize.height) * 0.5f,
                                       maskSize.width,
                                       maskSize.height);
            break;
        }
        case HDImageCropModeCustom: {
            self.maskRect = [self.dataSource imageCropViewControllerCustomMaskRect:self];
            break;
        }
    }
}

- (void)updateMaskPath {
    switch (self.cropMode) {
        case HDImageCropModeCircle: {
            self.maskPath = [UIBezierPath bezierPathWithOvalInRect:self.rectForMaskPath];
            break;
        }
        case HDImageCropModeSquare: {
            self.maskPath = [UIBezierPath bezierPathWithRect:self.rectForMaskPath];
            break;
        }
        case HDImageCropModeCustom: {
            self.maskPath = [self.dataSource imageCropViewControllerCustomMaskPath:self];
            break;
        }
    }
}

- (UIImage *)imageWithImage:(UIImage *)image inRect:(CGRect)rect scale:(CGFloat)scale imageOrientation:(UIImageOrientation)imageOrientation {
    if (!image.images) {
        CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, rect);
        UIImage *image = [UIImage imageWithCGImage:cgImage scale:scale orientation:imageOrientation];
        CGImageRelease(cgImage);
        return image;
    } else {
        UIImage *animatedImage = image;
        NSMutableArray *images = [NSMutableArray array];
        for (UIImage *animatedImageImage in animatedImage.images) {
            UIImage *image = [self imageWithImage:animatedImageImage inRect:rect scale:scale imageOrientation:imageOrientation];
            [images addObject:image];
        }
        return [UIImage animatedImageWithImages:images duration:image.duration];
    }
}

- (UIImage *)croppedImage:(UIImage *)originalImage cropMode:(HDImageCropMode)cropMode cropRect:(CGRect)cropRect imageRect:(CGRect)imageRect rotationAngle:(CGFloat)rotationAngle zoomScale:(CGFloat)zoomScale maskPath:(UIBezierPath *)maskPath applyMaskToCroppedImage:(BOOL)applyMaskToCroppedImage {

    UIImage *image = [self imageWithImage:originalImage inRect:imageRect scale:originalImage.scale imageOrientation:originalImage.imageOrientation];

    image = [image fixOrientation];

    /// 如果是 HDImageCropModeSquare 且原图没有旋转或者遮挡不需要应用到裁剪的图且原图没有旋转
    /// 可以直接返回图片，否则需要更多处理
    if ((cropMode == HDImageCropModeSquare || !applyMaskToCroppedImage) && rotationAngle == 0.0) {

        return image;
    } else {

        CGSize contextSize = cropRect.size;
        UIGraphicsBeginImageContextWithOptions(contextSize, NO, originalImage.scale);

        if (applyMaskToCroppedImage) {

            UIBezierPath *maskPathCopy = [maskPath copy];
            CGFloat scale = 1.0 / zoomScale;
            [maskPathCopy applyTransform:CGAffineTransformMakeScale(scale, scale)];

            CGPoint translation = CGPointMake(-CGRectGetMinX(maskPathCopy.bounds) + (CGRectGetWidth(cropRect) - CGRectGetWidth(maskPathCopy.bounds)) * 0.5f,
                                              -CGRectGetMinY(maskPathCopy.bounds) + (CGRectGetHeight(cropRect) - CGRectGetHeight(maskPathCopy.bounds)) * 0.5f);
            [maskPathCopy applyTransform:CGAffineTransformMakeTranslation(translation.x, translation.y)];

            [maskPathCopy addClip];
        }

        if (rotationAngle != 0) {
            image = [image rotateByAngle:rotationAngle];
        }

        CGPoint point = CGPointMake(floor((contextSize.width - image.size.width) * 0.5f),
                                    floor((contextSize.height - image.size.height) * 0.5f));
        [image drawAtPoint:point];

        UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        croppedImage = [UIImage imageWithCGImage:croppedImage.CGImage scale:originalImage.scale orientation:image.imageOrientation];

        return croppedImage;
    }
}

- (void)cropImage {
    if ([self.delegate respondsToSelector:@selector(imageCropViewController:willCropImage:)]) {
        [self.delegate imageCropViewController:self willCropImage:self.originalImage];
    }

    UIImage *originalImage = self.originalImage;
    HDImageCropMode cropMode = self.cropMode;
    CGRect cropRect = self.cropRect;
    CGRect imageRect = self.imageRect;
    CGFloat rotationAngle = self.rotationAngle;
    CGFloat zoomScale = self.imageScrollView.zoomScale;
    UIBezierPath *maskPath = self.maskPath;
    BOOL applyMaskToCroppedImage = self.applyMaskToCroppedImage;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *croppedImage = [self croppedImage:originalImage cropMode:cropMode cropRect:cropRect imageRect:imageRect rotationAngle:rotationAngle zoomScale:zoomScale maskPath:maskPath applyMaskToCroppedImage:applyMaskToCroppedImage];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate imageCropViewController:self didCropImage:croppedImage usingCropRect:cropRect rotationAngle:rotationAngle];
        });
    });
}

- (void)cancelCrop {
    if ([self.delegate respondsToSelector:@selector(imageCropViewControllerDidCancelCrop:)]) {
        [self.delegate imageCropViewControllerDidCancelCrop:self];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
