//
//  HDCodeGenerator.h
//  ViPay
//
//  Created by VanJay on 2019/8/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDCodeGenerator : NSObject

/** 生成条形码 */
+ (UIImage *)barCodeImageForStr:(NSString *)code size:(CGSize)size;
/** 生成二维码 */
+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size;
/** 生成带 logo 的二维码 */
+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size logoImage:(UIImage *)logo;

@end
