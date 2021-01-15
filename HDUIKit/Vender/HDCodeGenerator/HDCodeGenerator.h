//
//  HDCodeGenerator.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *HDInputCorrectionLevel NS_STRING_ENUM;

FOUNDATION_EXPORT HDInputCorrectionLevel const HDInputCorrectionLevelL; //!< L: 7%
FOUNDATION_EXPORT HDInputCorrectionLevel const HDInputCorrectionLevelM; //!< M: 15%
FOUNDATION_EXPORT HDInputCorrectionLevel const HDInputCorrectionLevelQ; //!< Q: 25%
FOUNDATION_EXPORT HDInputCorrectionLevel const HDInputCorrectionLevelH; //!< H: 30%

@interface HDCodeGenerator : NSObject

/// 生成条形码
/// @param code 条形码内容
/// @param size 条形码尺寸
+ (UIImage *)barCodeImageForStr:(NSString *)code size:(CGSize)size;

/// 生成二维码
/// @param code 二维码内容
/// @param size 二维码尺寸
+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size;

/// 生成二维码
/// @param code 二维码内容
/// @param size 二维码尺寸
/// @param level 容错率
+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size level:(HDInputCorrectionLevel)level;

/// 生成带 logo 的二维码
/// @param code 二维码内容
/// @param size 二维码尺寸
/// @param logo logo
+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size logoImage:(UIImage *)logo;

/// 生成带 logo 的二维码
/// @param code 二维码内容
/// @param size 二维码尺寸
/// @param logo logo
/// @param logoSize logo尺寸
+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size logoImage:(UIImage *)logo logoSize:(CGSize)logoSize;

/// 生成带 logo 的二维码
/// @param code 二维码内容
/// @param size 二维码尺寸
/// @param logo logo
/// @param logoSize logo尺寸
/// @param logoMargin logo 外围的间距
+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size logoImage:(UIImage *)logo logoSize:(CGSize)logoSize logoMargin:(CGFloat)logoMargin;

/// 生成带 logo 的二维码
/// @param code 二维码内容
/// @param size 二维码尺寸
/// @param logo logo
/// @param logoSize logo尺寸
/// @param logoMargin logo 外围的间距
/// @param level 容错率
+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size logoImage:(UIImage *)logo logoSize:(CGSize)logoSize logoMargin:(CGFloat)logoMargin level:(HDInputCorrectionLevel)level;

@end
