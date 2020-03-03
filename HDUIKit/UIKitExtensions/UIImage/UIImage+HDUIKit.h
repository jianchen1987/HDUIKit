//
//  UIImage+Extension.h
//  HDUIKit
//
//  Created by VanJay on 2019/6/17.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDUIImageResizingMode) {
    HDUIImageResizingModeScaleToFill = 0,       // 将图片缩放到给定的大小，不考虑宽高比例
    HDUIImageResizingModeScaleAspectFit = 10,   // 默认的缩放方式，将图片保持宽高比例不变的情况下缩放到不超过给定的大小（但缩放后的大小不一定与给定大小相等），不会产生空白也不会产生裁剪
    HDUIImageResizingModeScaleAspectFill = 20,  // 将图片保持宽高比例不变的情况下缩放到不超过给定的大小（但缩放后的大小不一定与给定大小相等），若有内容超出则会被裁剪。若裁剪则上下居中裁剪。
    HDUIImageResizingModeScaleAspectFillTop,    // 将图片保持宽高比例不变的情况下缩放到不超过给定的大小（但缩放后的大小不一定与给定大小相等），若有内容超出则会被裁剪。若裁剪则水平居中、垂直居上裁剪。
    HDUIImageResizingModeScaleAspectFillBottom  // 将图片保持宽高比例不变的情况下缩放到不超过给定的大小（但缩放后的大小不一定与给定大小相等），若有内容超出则会被裁剪。若裁剪则水平居中、垂直居下裁剪。
};

@interface UIImage (Bundle)

/// 加载 HDUIKit.bundle 里的图片
/// @param name 图片名
+ (nullable UIImage *)hd_imageNamed:(nonnull NSString *)name;
@end

@interface UIImage (Color)
/**
 *  创建一个size为(4, 4)的纯色的UIImage
 *
 *  @param color 图片的颜色
 *
 *  @return 纯色的UIImage
 */
+ (nullable UIImage *)hd_imageWithColor:(nullable UIColor *)color;

/**
 *  创建一个纯色的UIImage
 *
 *  @param  color           图片的颜色
 *  @param  size            图片的大小
 *  @param  cornerRadius    图片的圆角
 *
 * @return 纯色的UIImage
 */
+ (nullable UIImage *)hd_imageWithColor:(nullable UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)hd_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)hd_coloredRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpa:(CGFloat)alpa size:(CGSize)size;
- (UIImage *)hd_coloredRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpa:(CGFloat)alpa;
- (UIColor *)hd_colorAtPixel:(CGPoint)point;

/**
 *  设置一张图片的透明度
 *
 *  @param alpha 要用于渲染透明度
 *
 *  @return 设置了透明度之后的图片
 */
- (nullable UIImage *)hd_imageWithAlpha:(CGFloat)alpha;

/**
 *  保持当前图片的形状不变，使用指定的颜色去重新渲染它，生成一张新图片并返回
 *
 *  @param tintColor 要用于渲染的新颜色
 *
 *  @return 与当前图片形状一致但颜色与参数tintColor相同的新图片
 */
- (nullable UIImage *)hd_imageWithTintColor:(nullable UIColor *)tintColor;
@end

@interface UIImage (Size)
- (UIImage *)clipWithImageRect:(CGRect)clipRect;
// 压缩成指定大小代码
- (UIImage *)scaleToSize:(CGSize)size;
// 等比例压缩
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
// 等比例压缩
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

- (UIImage *)imageScaledToSize:(CGSize)newSize;
- (UIImage *)fixOrientation;

/**
 *  从图片中按指定的位置大小截取图片的一部分
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
- (UIImage *)hd_imageWithClippedRect:(CGRect)rect;

/**
 *  将原图以 HDUIImageResizingModeScaleAspectFit 的策略缩放，使其缩放后的大小不超过指定的大小，并返回缩放后的图片。缩放后的图片的倍数保持与原图一致。
 *  @param size 在这个约束的 size 内进行缩放后的大小，处理后返回的图片的 size 会根据 resizingMode 不同而不同，但必定不会超过 size。
 *
 *  @return 处理完的图片
 *  @see hd_imageResizedInLimitedSize:resizingMode:scale:
 */
- (nullable UIImage *)hd_imageResizedInLimitedSize:(CGSize)size;

/**
* 将原图以 HDUIImageResizingModeScaleAspectFit 的策略缩放，使其缩放后的大小不超过指定的大小，并返回缩放后的图片。缩放后的图片的倍数保持与原图一致。scale   跟随当前屏幕
*  @param size 在这个约束的 size 内进行缩放后的大小，处理后返回的图片的 size 会根据 resizingMode 不同而不同，但必定不会超过 size。

*  @return 处理完的图片
*  @see hd_imageResizedInLimitedSize:resizingMode:scale:
*/
- (UIImage *)hd_imageResizedWithScreenScaleInLimitedSize:(CGSize)size;

/**
 *  将原图按指定的 HDUIImageResizingMode 缩放，使其缩放后的大小不超过指定的大小，并返回缩放后的图片，缩放后的图片的倍数保持与原图一致。
 *  @param size 在这个约束的 size 内进行缩放后的大小，处理后返回的图片的 size 会根据 resizingMode 不同而不同，但必定不会超过 size。
 *  @param resizingMode 希望使用的缩放模式
 *
 *  @return 处理完的图片
 *  @see hd_imageResizedInLimitedSize:resizingMode:scale:
 */
- (nullable UIImage *)hd_imageResizedInLimitedSize:(CGSize)size resizingMode:(HDUIImageResizingMode)resizingMode;

/**
 *  将原图按指定的 HDUIImageResizingMode 缩放，使其缩放后的大小不超过指定的大小，并返回缩放后的图片。
 *  @param size 在这个约束的 size 内进行缩放后的大小，处理后返回的图片的 size 会根据 resizingMode 不同而不同，但必定不会超过 size。
 *  @param resizingMode 希望使用的缩放模式
 *  @param scale 用于指定缩放后的图片的倍数
 *
 *  @return 处理完的图片
 */
- (nullable UIImage *)hd_imageResizedInLimitedSize:(CGSize)size resizingMode:(HDUIImageResizingMode)resizingMode scale:(CGFloat)scale;
@end

@interface UIImage (Snapshot)
/**
 对传进来的 `UIView` 截图，生成一个 `UIImage` 并返回。注意这里使用的是 view.layer 来渲染图片内容。

 @param view 要截图的 `UIView`

 @return `UIView` 的截图

 @warning UIView 的 transform 并不会在截图里生效
 */
+ (nullable UIImage *)hd_imageWithView:(UIView *)view;

/**
 对传进来的 `UIView` 截图，生成一个 `UIImage` 并返回。注意这里使用的是 iOS 7的系统截图接口。

 @param view         要截图的 `UIView`
 @param afterUpdates 是否要在界面更新完成后才截图

 @return `UIView` 的截图

 @warning UIView 的 transform 并不会在截图里生效
 */
+ (nullable UIImage *)hd_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates;
@end

@interface UIImage (CornerRadius)

/**
*  切割出在指定圆角的图片
*
*  @param cornerRadius 要切割的圆角值
*
*  @return 切割后的新图片
*/
- (nullable UIImage *)hd_imageWithClippedCornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)hd_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale actions:(void (^)(CGContextRef contextRef))actionBlock;
@end

@interface UIImage (HDUIKit)
/**
 *  判断一张图是否不存在 alpha 通道，注意 “不存在 alpha 通道” 不等价于 “不透明”。一张不透明的图有可能是存在 alpha 通道但 alpha 值为 1。
 */
@property (nonatomic, assign, readonly) BOOL hd_opaque;
/**
 *  获取当前图片的均色，原理是将图片绘制到1px*1px的矩形内，再从当前区域取色，得到图片的均色。
 *
 *  @return 代表图片平均颜色的UIColor对象
 */
@property (nonatomic, strong, readonly) UIColor *hd_averageColor;
/**
 *  将原图进行旋转，只能选择上下左右四个方向
 *
 *  @param  direction 旋转的方向
 *
 *  @return 处理完的图片
 */
- (nullable UIImage *)hd_imageWithOrientation:(UIImageOrientation)direction;

/**
 将 data 转换成 animated UIImage（如果非 animated 则转换成普通 UIImage），image 倍数为 1（与系统的 [UIImage imageWithData:] 接口一致）

 @param data 图片文件的 data
 @return 转换成的 UIImage
 */
+ (nullable UIImage *)hd_animatedImageWithData:(NSData *)data;

/**
 将 data 转换成 animated UIImage（如果非 animated 则转换成普通 UIImage）

 @param data 图片文件的 data
 @param scale 图片的倍数，0 表示获取当前设备的屏幕倍数
 @return 转换成的 UIImage
 @see http://www.jianshu.com/p/767af9c690a3
 @see https://github.com/rs/SDWebImage
 */
+ (nullable UIImage *)hd_animatedImageWithData:(NSData *)data scale:(CGFloat)scale;

/**
 在 mainBundle 里找到对应名字的图片， 注意图片 scale 为 1，与系统的 [UIImage imageWithData:] 接口一致，若需要修改倍数，请使用 -hd_animatedImageNamed:scale:

 @param name 图片名，可指定后缀，若不写后缀，默认为“gif”。不写后缀的情况下会先找“gif”后缀的图片，不存在再找无后缀的文件，仍不存在则返回 nil
 @return  转换成的 UIImage
 */
+ (nullable UIImage *)hd_animatedImageNamed:(NSString *)name;

/**
 在 mainBundle 里找到对应名字的图片

 @param name 图片名，可指定后缀，若不写后缀，默认为“gif”。不写后缀的情况下会先找“gif”后缀的图片，不存在再找无后缀的文件，仍不存在则返回 nil
 @param scale 图片的倍数，0 表示获取当前设备的屏幕倍数
 @return  转换成的 UIImage
 */
+ (nullable UIImage *)hd_animatedImageNamed:(NSString *)name scale:(CGFloat)scale;

/**
 *  在当前图片的基础上叠加一张图片，并指定绘制叠加图片的起始位置
 *
 *  叠加上去的图片将保持原图片的大小不变，不被压缩、拉伸
 *
 *  @param image 要叠加的图片
 *  @param point 所叠加图片的绘制的起始位置
 *
 *  @return 返回一张与原图大小一致的图片，所叠加的图片若超出原图大小，则超出部分被截掉
 */
- (nullable UIImage *)hd_imageWithImageAbove:(UIImage *)image atPoint:(CGPoint)point;
@end
