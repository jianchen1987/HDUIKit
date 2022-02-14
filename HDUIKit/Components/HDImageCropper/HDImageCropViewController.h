//
//  HDImageCropViewController.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDImageCropViewControllerDataSource;
@protocol HDImageCropViewControllerDelegate;

typedef NS_ENUM(NSUInteger, HDImageCropMode) {
    HDImageCropModeCircle,  ///< 圆形
    HDImageCropModeSquare,  ///< 正方形
    HDImageCropModeCustom   ///< 自定义
};

@interface HDImageCropViewController : UIViewController

/// 指定构造器
/// @param originalImage 要裁剪的图片
- (instancetype)initWithImage:(UIImage *)originalImage;

/// 指定构造器
/// @param originalImage 要裁剪的图片
/// @param cropMode 类型
- (instancetype)initWithImage:(UIImage *)originalImage cropMode:(HDImageCropMode)cropMode;

/// 缩放到指定 rect
/// @param rect 指定 rect
/// @param animated 是否动画
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;
/// 代理
@property (weak, nonatomic, nullable) id<HDImageCropViewControllerDelegate> delegate;
/// 数据源
@property (weak, nonatomic, nullable) id<HDImageCropViewControllerDataSource> dataSource;

/// 原始图片
@property (strong, nonatomic) UIImage *originalImage;
/// 遮罩层颜色
@property (copy, nonatomic) UIColor *maskLayerColor;
/// 遮罩层边线宽，默认 1
@property (assign, nonatomic) CGFloat maskLayerLineWidth;
/// 遮罩空白区域填充色，默认 nil
@property (copy, nonatomic, nullable) UIColor *maskLayerStrokeColor;
/// 裁剪区域 rect
@property (assign, readonly, nonatomic) CGRect maskRect;
/// 遮罩层的贝塞尔曲线
@property (copy, readonly, nonatomic) UIBezierPath *maskPath;
/// 模式
@property (assign, nonatomic) HDImageCropMode cropMode;
/// 裁剪区域
@property (readonly, nonatomic) CGRect cropRect;
/// 旋转角度
@property (readonly, nonatomic) CGFloat rotationAngle;
/// 当前缩放系数
@property (readonly, nonatomic) CGFloat zoomScale;
/// 是否避免空白区域围绕图片
@property (assign, nonatomic) BOOL avoidEmptySpaceAroundImage;
/// 是否水平缩放
@property (assign, nonatomic) BOOL alwaysBounceHorizontal;
/// 是否垂直缩放
@property (assign, nonatomic) BOOL alwaysBounceVertical;
/// 裁剪后是否应用 mask 到裁剪后的图片
@property (assign, nonatomic) BOOL applyMaskToCroppedImage;
/// 是否支持旋转，如果裁剪模式是 custom，必须实现 imageCropViewControllerCustomMovementRect:
@property (assign, getter=isRotationEnabled, nonatomic) BOOL rotationEnabled;
/// 取消按钮
@property (strong, nonatomic, readonly) UIButton *cancelButton;
/// 选择按钮
@property (strong, nonatomic, readonly) UIButton *chooseButton;
/// 是否竖屏
- (BOOL)isPortraitInterfaceOrientation;
/// 竖屏模式下的圆形遮罩层外框离屏幕边缘距离，默认 15
@property (assign, nonatomic) CGFloat portraitCircleMaskRectInnerEdgeInset;
/// 竖屏模式下的方形遮罩层外框离屏幕边缘距离，默认 20
@property (assign, nonatomic) CGFloat portraitSquareMaskRectInnerEdgeInset;
/// 横屏模式下的圆形遮罩层外框离屏幕边缘距离，默认 45
@property (assign, nonatomic) CGFloat landscapeCircleMaskRectInnerEdgeInset;
/// 横屏模式下的方形遮罩层外框离屏幕边缘距离，默认 45
@property (assign, nonatomic) CGFloat landscapeSquareMaskRectInnerEdgeInset;
@end

/// 数据源
@protocol HDImageCropViewControllerDataSource <NSObject>

/// 自定义 rect
- (CGRect)imageCropViewControllerCustomMaskRect:(HDImageCropViewController *)controller;

/// 指定贝塞尔曲线
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(HDImageCropViewController *)controller;

/// 可移动区域
- (CGRect)imageCropViewControllerCustomMovementRect:(HDImageCropViewController *)controller;

@end

@protocol HDImageCropViewControllerDelegate <NSObject>

/// 用户取消
- (void)imageCropViewControllerDidCancelCrop:(HDImageCropViewController *)controller;

/// 裁剪完成
/// @param controller 控制器
/// @param croppedImage 图片
/// @param cropRect 裁剪范围
/// @param rotationAngle 旋转角度
- (void)imageCropViewController:(HDImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle;

@optional

/// 显示图片
- (void)imageCropViewControllerDidDisplayImage:(HDImageCropViewController *)controller;

/// 图片将要被裁剪
- (void)imageCropViewController:(HDImageCropViewController *)controller willCropImage:(UIImage *)originalImage;

- (NSString *)localizedTitleForChooseButton;
- (NSString *)localizedTitleForCancelButton;

@end

NS_ASSUME_NONNULL_END
