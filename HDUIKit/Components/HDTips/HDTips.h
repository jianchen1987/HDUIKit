//
//  HDTips.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDToastView.h"

NS_ASSUME_NONNULL_BEGIN

// 自动计算秒数的标志符，在 delay 里面赋值 HDTipsAutomaticallyHideToastSeconds 即可通过自动计算 tips 消失的秒数
extern const NSInteger HDTipsAutomaticallyHideToastSeconds;

/// 默认的 parentView
#define DefaultTipsParentView (UIApplication.sharedApplication.delegate.window)

/**
 * 简单封装了 HDToastView，支持弹出纯文本、loading、succeed、error、info 等五种 tips。如果这些接口还满足不了业务的需求，可以通过 HDTips 的分类自行添加接口。
 * 注意用类方法显示 tips 的话，会导致父类的 willShowBlock 无法正常工作，具体请查看 willShowBlock 的注释。
 * @warning 使用类方法，除了 showLoading 系列方法不会自动隐藏外，其他方法如果没有 delay 参数，则会自动隐藏
 * @see [HDToastView willShowBlock]
 */
@interface HDTips : HDToastView

/// 实例方法：需要自己addSubview，hide之后不会自动removeFromSuperView

- (void)showLoading;
- (void)showLoading:(nullable id)text;
- (void)showLoadingHideAfterDelay:(NSTimeInterval)delay;
- (void)showLoading:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showLoading:(nullable id)text detailText:(nullable NSString *)detailText;
- (void)showLoading:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showWithText:(nullable id)text;
- (void)showWithText:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showWithText:(nullable id)text detailText:(nullable NSString *)detailText;
- (void)showWithText:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showSuccess:(nullable id)text;
- (void)showSuccessNotCreateNew:(nullable id)text;
- (void)showSuccessNotCreateNew:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showSuccess:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showSuccess:(nullable id)text detailText:(nullable NSString *)detailText;
- (void)showSuccess:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;
- (void)showSuccess:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay iconImageName:(NSString * _Nullable)imageName;

- (void)showError:(nullable id)text;
- (void)showError:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showError:(nullable id)text detailText:(nullable NSString *)detailText;
- (void)showError:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showInfo:(nullable id)text;
- (void)showInfo:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showInfo:(nullable id)text detailText:(nullable NSString *)detailText;
- (void)showInfo:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showWarning:(nullable id)text;
- (void)showWarning:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showWarning:(nullable id)text detailText:(nullable NSString *)detailText;
- (void)showWarning:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showProgressViewWithProgress:(CGFloat)progress;
- (void)showProgressViewWithProgress:(CGFloat)progress text:(nullable id)text;
- (void)showProgressViewWithProgress:(CGFloat)progress text:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showProgressViewWithProgress:(CGFloat)progress text:(nullable id)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

/// 类方法：主要用在局部一次性使用的场景，hide之后会自动removeFromSuperView

+ (HDTips *)createTipsToView:(UIView *)view;

+ (HDTips *)showLoading;
+ (HDTips *)showLoading:(nullable id)text;
+ (HDTips *)showLoadingInView:(UIView *)view;
+ (HDTips *)showLoading:(nullable id)text inView:(UIView *)view;
+ (HDTips *)showLoadingInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showLoading:(nullable id)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showLoading:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (HDTips *)showLoading:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (HDTips *)showWithText:(nullable id)text;
+ (HDTips *)showWithText:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showWithText:(nullable id)text detailText:(nullable NSString *)detailText;
+ (HDTips *)showWithText:(nullable id)text inView:(UIView *)view;
+ (HDTips *)showWithText:(nullable id)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showWithText:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (HDTips *)showWithText:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (HDTips *)showSuccess:(nullable id)text;
+ (HDTips *)showSuccess:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showSuccess:(nullable id)text hideAfterDelay:(NSTimeInterval)delay iconImageName:(NSString * _Nullable)imageName;
+ (HDTips *)showSuccess:(nullable id)text detailText:(nullable NSString *)detailText;
+ (HDTips *)showSuccess:(nullable id)text inView:(UIView *)view;
+ (HDTips *)showSuccess:(nullable id)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showSuccess:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (HDTips *)showSuccess:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showSuccess:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay iconImageName:(NSString * _Nullable)imageName;

+ (HDTips *)showError:(nullable id)text;
+ (HDTips *)showError:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showError:(nullable id)text detailText:(nullable NSString *)detailText;
+ (HDTips *)showError:(nullable id)text inView:(UIView *)view;
+ (HDTips *)showError:(nullable id)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showError:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (HDTips *)showError:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (HDTips *)showInfo:(nullable id)text;
+ (HDTips *)showInfo:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showInfo:(nullable id)text detailText:(nullable NSString *)detailText;
+ (HDTips *)showInfo:(nullable id)text inView:(UIView *)view;
+ (HDTips *)showInfo:(nullable id)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showInfo:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (HDTips *)showInfo:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (HDTips *)showWarning:(nullable id)text;
+ (HDTips *)showWarning:(nullable id)text hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showWarning:(nullable id)text detailText:(nullable NSString *)detailText;
+ (HDTips *)showWarning:(nullable id)text inView:(UIView *)view;
+ (HDTips *)showWarning:(nullable id)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (HDTips *)showWarning:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (HDTips *)showWarning:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName;
+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName inView:(UIView *)view;
+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text;
+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text inView:(UIView *)view;
+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text detailText:(nullable NSString *)detailText;
+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (HDTips *)showLoadingWithGIF:(NSString *)gifImageName text:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName;
+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName inView:(UIView *)view;
+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text;
+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text inView:(UIView *)view;
+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text detailText:(nullable NSString *)detailText;
+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (HDTips *)showLoadingWithImageInfiniteRotating:(NSString *)imageName text:(nullable id)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

/// 隐藏 tips
+ (void)hideAllTipsInView:(UIView *)view;
+ (void)hideAllTips;

/// 自动隐藏 toast 可以使用这个方法自动计算秒数
+ (NSTimeInterval)smartDelaySecondsForTipsText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
