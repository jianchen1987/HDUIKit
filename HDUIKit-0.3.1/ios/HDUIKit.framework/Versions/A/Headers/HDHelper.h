//
//  HDHelper.h
//  HDUIKit
//
//  Created by VanJay on 2019/9/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDHelper : NSObject
+ (instancetype _Nonnull)sharedInstance;
@end

@interface HDHelper (AudioSession)

/**
 *  听筒和扬声器的切换
 *
 *  @param speaker   是否转为扬声器，NO则听筒
 *  @param temporary 决定使用kAudioSessionProperty_OverrideAudioRoute还是kAudioSessionProperty_OverrideCategoryDefaultToSpeaker，两者的区别请查看本组的博客文章:http://km.oa.com/group/gyui/articles/show/235957
 */
+ (void)redirectAudioRouteWithSpeaker:(BOOL)speaker temporary:(BOOL)temporary;

/**
 *  设置category
 *
 *  @param category 使用iOS7的category，iOS6的会自动适配
 */
+ (void)setAudioSessionCategory:(nullable NSString *)category;
@end

@interface HDHelper (UIGraphic)

/// 获取一像素的大小
+ (CGFloat)pixelOne;

/// 判断size是否超出范围
+ (void)inspectContextSize:(CGSize)size;

/// context是否合法
+ (void)inspectContextIfInvalidatedInDebugMode:(CGContextRef _Nonnull)context;
+ (BOOL)inspectContextIfInvalidatedInReleaseMode:(CGContextRef _Nonnull)context;
@end

@interface HDHelper (Device)

+ (nonnull NSString *)deviceModel;

+ (BOOL)isIPad;
+ (BOOL)isIPod;
+ (BOOL)isIPhone;
+ (BOOL)isSimulator;

/// 带物理凹槽的刘海屏或者使用 Home Indicator 类型的设备
+ (BOOL)isNotchedScreen;

/// 将屏幕分为普通和紧凑两种，这个方法用于判断普通屏幕
+ (BOOL)isRegularScreen;

/// iPhone XS Max
+ (BOOL)is65InchScreen;

/// iPhone XR
+ (BOOL)is61InchScreen;

/// iPhone X/XS
+ (BOOL)is58InchScreen;

/// iPhone 8 Plus
+ (BOOL)is55InchScreen;

/// iPhone 8
+ (BOOL)is47InchScreen;

/// iPhone 5
+ (BOOL)is40InchScreen;

/// iPhone 4
+ (BOOL)is35InchScreen;

+ (CGSize)screenSizeFor65Inch;
+ (CGSize)screenSizeFor61Inch;
+ (CGSize)screenSizeFor58Inch;
+ (CGSize)screenSizeFor55Inch;
+ (CGSize)screenSizeFor47Inch;
+ (CGSize)screenSizeFor40Inch;
+ (CGSize)screenSizeFor35Inch;

+ (CGFloat)preferredLayoutAsSimilarScreenWidthForIPad;

// 用于获取 isNotchedScreen 设备的 insets，注意对于 iPad Pro 11-inch 这种无刘海凹槽但却有使用 Home Indicator 的设备，它的 top 返回0，bottom 返回 safeAreaInsets.bottom 的值
+ (UIEdgeInsets)safeAreaInsetsForDeviceWithNotch;

/// 判断当前设备是否高性能设备，只会判断一次，以后都直接读取结果，所以没有性能问题
+ (BOOL)isHighPerformanceDevice;

/// 系统设置里是否开启了“放大显示-试图-放大”，支持放大模式的 iPhone 设备可在官方文档中查询 https://support.apple.com/zh-cn/guide/iphone/iphd6804774e/ios
+ (BOOL)isZoomedMode;

/**
 在 iPad 分屏模式下可获得实际运行区域的窗口大小，如需适配 iPad 分屏，建议用这个方法来代替 [UIScreen mainScreen].bounds.size
 @return 应用运行的窗口大小
 */
+ (CGSize)applicationSize;

@end

@interface HDHelper (SystemVersion)
+ (NSInteger)numbericOSVersion;
+ (NSComparisonResult)compareSystemVersion:(nonnull NSString *)currentVersion toVersion:(nonnull NSString *)targetVersion;
+ (BOOL)isCurrentSystemAtLeastVersion:(nonnull NSString *)targetVersion;
+ (BOOL)isCurrentSystemLowerThanVersion:(nonnull NSString *)targetVersion;
@end

@interface HDHelper (Image)

/// 合成一张带 logo 的占位图，默认 logo 居中，有特殊场景可增加绘制 logo 起点参数
/// @param bgColor 背景色
/// @param radius 背景圆角，默认 5
/// @param size 背景大小
/// @param logoImage logo 图，为空将使用默认的白色 HDUIKit logo
/// @param logoSize logo 大小，如果为空有默认大小
+ (UIImage *)placeholderImageWithBgColor:(UIColor *__nullable)bgColor cornerRadius:(CGFloat)radius size:(CGSize)size logoImage:(UIImage *__nullable)logoImage logoSize:(CGSize)logoSize;
+ (UIImage *)placeholderImageWithBgColor:(UIColor *__nullable)bgColor cornerRadius:(CGFloat)radius size:(CGSize)size;
+ (UIImage *)placeholderImageWithCornerRadius:(CGFloat)radius size:(CGSize)size logoWidth:(CGFloat)logoWidth;
+ (UIImage *)placeholderImageWithCornerRadius:(CGFloat)radius size:(CGSize)size logoSize:(CGSize)logoSize;
+ (UIImage *)placeholderImageWithCornerRadius:(CGFloat)radius size:(CGSize)size;
+ (UIImage *)placeholderImageWithSize:(CGSize)size;
+ (UIImage *)circlePlaceholderImage;
+ (UIImage *)placeholderImage;
@end

@interface HDHelper (Font)
+ (__kindof NSString *)narrowestFontName;
@end

NS_ASSUME_NONNULL_END
