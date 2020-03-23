
//
//  HDTips.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTips.h"
#import "HDPieProgressView.h"
#import "HDToastAnimator.h"
#import "HDToastBackgroundView.h"
#import "HDToastContentView.h"
#import "NSBundle+HDUIKit.h"
#import "NSString+HDKitCore.h"
#import "UIImage+HD_GIF.h"

const NSInteger HDTipsAutomaticallyHideToastSeconds = -1;

@interface HDTips ()
@property (nonatomic, strong) UIView *contentCustomView;
@property (nonatomic, strong) HDPieProgressView *progressView;  ///< 进度显示控件
@end

@implementation HDTips
#pragma mark - Instance Methods
#pragma mark - Loading
- (void)showLoading {
    [self showLoading:nil hideAfterDelay:0];
}

- (void)showLoadingHideAfterDelay:(NSTimeInterval)delay {
    [self showLoading:nil hideAfterDelay:delay];
}

- (void)showLoading:(NSString *)text {
    [self showLoading:text hideAfterDelay:0];
}

- (void)showLoading:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showLoading:text detailText:nil hideAfterDelay:delay];
}

- (void)showLoading:(NSString *)text detailText:(NSString *)detailText {
    [self showLoading:text detailText:detailText hideAfterDelay:0];
}

- (void)showLoading:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    self.contentCustomView = indicator;
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

#pragma mark - Text
- (void)showWithText:(NSString *)text {
    [self showWithText:text detailText:nil hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showWithText:text detailText:nil hideAfterDelay:delay];
}

- (void)showWithText:(NSString *)text detailText:(NSString *)detailText {
    [self showWithText:text detailText:detailText hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showWithText:(id)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = nil;
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

#pragma mark - Success
- (void)showSuccess:(NSString *)text {
    [self showSuccess:text detailText:nil hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showSuccessNotCreateNew:(nullable id)text {
    [self showSuccess:text detailText:nil hideAfterDelay:HDTipsAutomaticallyHideToastSeconds needShow:false];
}

- (void)showSuccessNotCreateNew:(nullable id)text hideAfterDelay:(NSTimeInterval)delay {
    [self showSuccess:text detailText:nil hideAfterDelay:delay];
}

- (void)showSuccess:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showSuccess:text detailText:nil hideAfterDelay:delay];
}

- (void)showSuccess:(NSString *)text detailText:(NSString *)detailText {
    [self showSuccess:text detailText:detailText hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showSuccess:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    [self showSuccess:text detailText:detailText hideAfterDelay:delay needShow:true];
}

- (void)showSuccess:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay needShow:(BOOL)needShow {
    NSBundle *bundle = [NSBundle hd_UIKitTipsResourcesBundle];
    self.contentCustomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay needShow:needShow];
}

#pragma mark - Error
- (void)showError:(NSString *)text {
    [self showError:text detailText:nil hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showError:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showError:text detailText:nil hideAfterDelay:delay];
}

- (void)showError:(NSString *)text detailText:(NSString *)detailText {
    [self showError:text detailText:detailText hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showError:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    NSBundle *bundle = [NSBundle hd_UIKitTipsResourcesBundle];
    self.contentCustomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

#pragma mark - Info
- (void)showInfo:(NSString *)text {
    [self showInfo:text detailText:nil hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showInfo:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showInfo:text detailText:nil hideAfterDelay:delay];
}

- (void)showInfo:(NSString *)text detailText:(NSString *)detailText {
    [self showInfo:text detailText:detailText hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showInfo:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    NSBundle *bundle = [NSBundle hd_UIKitTipsResourcesBundle];
    self.contentCustomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

#pragma mark - Warning
- (void)showWarning:(NSString *)text {
    [self showWarning:text detailText:nil hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showWarning:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showWarning:text detailText:nil hideAfterDelay:delay];
}

- (void)showWarning:(NSString *)text detailText:(NSString *)detailText {
    [self showWarning:text detailText:detailText hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

- (void)showWarning:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    NSBundle *bundle = [NSBundle hd_UIKitTipsResourcesBundle];
    self.contentCustomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

#pragma mark - Progress
- (void)showProgressViewWithProgress:(CGFloat)progress {
    [self showProgressViewWithProgress:progress text:nil detailText:nil hideAfterDelay:0];
}

- (void)showProgressViewWithProgress:(CGFloat)progress text:(nullable id)text {
    [self showProgressViewWithProgress:progress text:text detailText:nil hideAfterDelay:0];
}

- (void)showProgressViewWithProgress:(CGFloat)progress text:(nullable id)text hideAfterDelay:(NSTimeInterval)delay {
    [self showProgressViewWithProgress:progress text:text detailText:nil hideAfterDelay:delay];
}

- (void)showProgressViewWithProgress:(CGFloat)progress text:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = self.progressView;
    [self.progressView setProgress:progress animated:true];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay needShow:false];
}

#pragma mark - gif
- (void)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    // 使用 SDWebImage 放入gif 图片
    NSString *filePath = [[NSBundle mainBundle] pathForResource:gifImageName ofType:@"gif"];
    UIImage *image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfFile:filePath]];

    // 自定义imageView
    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:image];
    self.contentCustomView = cusImageV;
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

#pragma mark - 旋转的图片

- (void)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    // 自定义imageView
    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.contentCustomView = cusImageV;
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotationAnimation.duration = 0.7f;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = false;
    [self.contentCustomView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)showTipWithText:(id)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay needShow:true];
}

- (void)showTipWithText:(id)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay needShow:(BOOL)needShow {
    HDToastContentView *contentView = (HDToastContentView *)self.contentView;
    contentView.customView = self.contentCustomView;
    if (self.contentCustomView) {
        if (text) {
            if ([text isKindOfClass:NSString.class]) {
                contentView.square = ((NSString *)text).hd_lengthWhenCountingNonASCIICharacterAsTwo <= 10 && detailText.hd_lengthWhenCountingNonASCIICharacterAsTwo <= 10;
            }
        } else {
            contentView.square = detailText.hd_lengthWhenCountingNonASCIICharacterAsTwo <= 10;
        }
    }
    if (text) {
        if ([text isKindOfClass:NSAttributedString.class]) {
            contentView.textLabel.attributedText = (NSAttributedString *)text;
        } else {
            contentView.textLabel.text = text;
        }
    } else {
        contentView.textLabelText = @"";
    }
    contentView.textLabel.textAlignment = NSTextAlignmentCenter;
    contentView.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    contentView.detailTextLabelText = detailText ?: @"";

    self.toastAnimator.animationType = HDToastAnimationTypeZoom;

    if (needShow) {
        [self showAnimated:YES];
    }

    if (delay == HDTipsAutomaticallyHideToastSeconds) {
        [self hideAnimated:YES afterDelay:[HDTips smartDelaySecondsForTipsText:text]];
    } else if (delay > 0) {
        [self hideAnimated:YES afterDelay:delay];
    }
    // 添加双击手势移除
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedHud:)];
    recognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:recognizer];
}

#pragma mark - event response
- (void)tappedHud:(UITapGestureRecognizer *)recognizer {
    HDTips *hud = (HDTips *)recognizer.view;
    [hud hideAnimated:YES];
}

#pragma mark - private methods
+ (NSTimeInterval)smartDelaySecondsForTipsText:(NSString *)text {
    NSUInteger length = text.hd_lengthWhenCountingNonASCIICharacterAsTwo;
    if (length <= 20) {
        return 1.5;
    } else if (length <= 40) {
        return 2.0;
    } else if (length <= 50) {
        return 2.5;
    } else {
        return 3.0;
    }
}

#pragma mark - Class Methods
#pragma mark - Loading
+ (HDTips *)showLoading {
    return [self showLoading:nil detailText:nil inView:DefaultTipsParentView hideAfterDelay:0];
}

+ (HDTips *)showLoading:(NSString *)text {
    return [self showLoading:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:0];
}

+ (HDTips *)showLoadingInView:(UIView *)view {
    return [self showLoading:nil detailText:nil inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoading:(NSString *)text inView:(UIView *)view {
    return [self showLoading:text detailText:nil inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoadingInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showLoading:nil detailText:nil inView:view hideAfterDelay:delay];
}

+ (HDTips *)showLoading:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showLoading:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (HDTips *)showLoading:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showLoading:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoading:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    HDTips *tips = [self createTipsToView:view];
    [tips showLoading:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

#pragma mark - Text
+ (HDTips *)showWithText:(nullable id)text {
    return [self showWithText:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showWithText:(nullable id)text hideAfterDelay:(NSTimeInterval)delay {
    return [self showWithText:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:delay];
}

+ (HDTips *)showWithText:(nullable id)text detailText:(nullable NSString *)detailText {
    return [self showWithText:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showWithText:(id)text inView:(UIView *)view {
    return [self showWithText:text detailText:nil inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showWithText:(id)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showWithText:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (HDTips *)showWithText:(id)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showWithText:text detailText:detailText inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showWithText:(id)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    HDTips *tips = [self createTipsToView:view];
    [tips showWithText:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

#pragma mark - Success
+ (HDTips *)showSuccess:(nullable id)text {
    return [self showSuccess:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showSuccess:(nullable id)text hideAfterDelay:(NSTimeInterval)delay {
    return [self showSuccess:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:delay];
}

+ (HDTips *)showSuccess:(nullable id)text detailText:(nullable NSString *)detailText {
    return [self showSuccess:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showSuccess:(NSString *)text inView:(UIView *)view {
    return [self showSuccess:text detailText:nil inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showSuccess:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showSuccess:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (HDTips *)showSuccess:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showSuccess:text detailText:detailText inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showSuccess:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    HDTips *tips = [self createTipsToView:view];
    [tips showSuccess:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

#pragma mark - Error
+ (HDTips *)showError:(nullable id)text {
    return [self showError:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showError:(nullable id)text hideAfterDelay:(NSTimeInterval)delay {
    return [self showError:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:delay];
}

+ (HDTips *)showError:(nullable id)text detailText:(nullable NSString *)detailText {
    return [self showError:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showError:(NSString *)text inView:(UIView *)view {
    return [self showError:text detailText:nil inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showError:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showError:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (HDTips *)showError:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showError:text detailText:detailText inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showError:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    HDTips *tips = [self createTipsToView:view];
    [tips showError:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

#pragma mark - Info
+ (HDTips *)showInfo:(nullable id)text {
    return [self showInfo:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showInfo:(nullable id)text hideAfterDelay:(NSTimeInterval)delay {
    return [self showInfo:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:delay];
}

+ (HDTips *)showInfo:(nullable id)text detailText:(nullable NSString *)detailText {
    return [self showInfo:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showInfo:(NSString *)text inView:(UIView *)view {
    return [self showInfo:text detailText:nil inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showInfo:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showInfo:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (HDTips *)showInfo:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showInfo:text detailText:detailText inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showInfo:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    HDTips *tips = [self createTipsToView:view];
    [tips showInfo:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

#pragma mark - Warning
+ (HDTips *)showWarning:(nullable id)text {
    return [self showWarning:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showWarning:(nullable id)text hideAfterDelay:(NSTimeInterval)delay {
    return [self showWarning:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:delay];
}

+ (HDTips *)showWarning:(nullable id)text detailText:(nullable NSString *)detailText {
    return [self showWarning:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showWarning:(NSString *)text inView:(UIView *)view {
    return [self showWarning:text detailText:nil inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showWarning:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showWarning:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (HDTips *)showWarning:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showWarning:text detailText:detailText inView:view hideAfterDelay:HDTipsAutomaticallyHideToastSeconds];
}

+ (HDTips *)showWarning:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    HDTips *tips = [self createTipsToView:view];
    [tips showWarning:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

#pragma mark - 加载 gif

+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName {
    return [self showLoadingWithGIF:gifImageName text:nil detailText:nil inView:DefaultTipsParentView hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName inView:(UIView *)view {
    return [self showLoadingWithGIF:gifImageName text:nil detailText:nil inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text {
    return [self showLoadingWithGIF:gifImageName text:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text inView:(UIView *)view {
    return [self showLoadingWithGIF:gifImageName text:text detailText:nil inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text detailText:(nullable NSString *)detailText {
    return [self showLoadingWithGIF:gifImageName text:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view {
    return [self showLoadingWithGIF:gifImageName text:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    HDTips *tips = [self createTipsToView:view];
    [tips showLoadingWithGIF:gifImageName text:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

#pragma mark - 加载图片且旋转
+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName {
    return [self showLoadingWithImageInfiniteRotating:imageName text:nil detailText:nil inView:DefaultTipsParentView hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName inView:(UIView *)view {
    return [self showLoadingWithImageInfiniteRotating:imageName text:nil detailText:nil inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text {
    return [self showLoadingWithImageInfiniteRotating:imageName text:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text inView:(UIView *)view {
    return [self showLoadingWithImageInfiniteRotating:imageName text:text detailText:nil inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text detailText:(nullable NSString *)detailText {
    return [self showLoadingWithImageInfiniteRotating:imageName text:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view {
    return [self showLoadingWithImageInfiniteRotating:imageName text:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    HDTips *tips = [self createTipsToView:view];
    [tips showLoadingWithImageInfiniteRotating:imageName text:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (HDTips *)createTipsToView:(UIView *)view {
    HDTips *tips = [[HDTips alloc] initWithView:view];
    [view addSubview:tips];
    tips.removeFromSuperViewWhenHide = YES;
    return tips;
}

+ (void)hideAllTipsInView:(UIView *)view {
    [self hideAllToastInView:view animated:NO];
}

+ (void)hideAllTips {
    [self hideAllToastInView:nil animated:NO];
}

#pragma mark - lazy load
- (HDPieProgressView *)progressView {
    if (!_progressView) {
        _progressView = HDPieProgressView.new;
        _progressView.bounds = CGRectMake(0, 0, 50, 50);
    }
    return _progressView;
}
@end
