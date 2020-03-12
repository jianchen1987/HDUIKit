//
//  HDCodeGenerator.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCodeGenerator.h"

static NSString *const HDInputCorrectionLevelL = @"L";  //!< L: 7%
static NSString *const HDInputCorrectionLevelM = @"M";  //!< M: 15%
static NSString *const HDInputCorrectionLevelQ = @"Q";  //!< Q: 25%
static NSString *const HDInputCorrectionLevelH = @"H";  //!< H: 30%

@implementation HDCodeGenerator
+ (UIImage *)barCodeImageForStr:(NSString *)code size:(CGSize)size {

    NSData *codeData = [code dataUsingEncoding:NSUTF8StringEncoding];
    //  使用CICode128BarcodeGenerator创建filter
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"
                            withInputParameters:@{
                                @"inputMessage": codeData,
                                @"inputQuietSpace": @(0),
                            }];
    // 由filter.outputImage直接转成的UIImage不太清楚，需要做高清处理
    UIImage *codeImage = [self scaleImage:filter.outputImage toSize:size];

    return codeImage;
}

+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size {

    NSData *codeData = [code dataUsingEncoding:NSUTF8StringEncoding];
    // 使用CIQRCodeGenerator创建filter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"
                            withInputParameters:@{@"inputMessage": codeData,
                                                  @"inputCorrectionLevel": HDInputCorrectionLevelH}];
    // 由filter.outputImage直接转成的UIImage不太清楚，需要做高清处理
    UIImage *codeImage = [self scaleImage:filter.outputImage toSize:size];

    return codeImage;
}

+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size logoImage:(UIImage *)logo {
    return [self qrCodeImageForStr:code size:size logoImage:logo logoSize:logo.size logoMargin:0];
}

+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size logoImage:(UIImage *)logo logoSize:(CGSize)logoSize {
    return [self qrCodeImageForStr:code size:size logoImage:logo logoSize:logoSize logoMargin:0];
}

+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size logoImage:(UIImage *)logo logoSize:(CGSize)logoSize logoMargin:(CGFloat)logoMargin {
    UIImage *qrcode = [self qrCodeImageForStr:code size:size];
    UIImage *image = [self combinateCodeImage:qrcode withLogo:logo logoSize:logoSize logoMargin:logoMargin];
    return image;
}

#pragma mark - private methods
+ (UIImage *)combinateCodeImage:(UIImage *)qrcode withLogo:(UIImage *)logoImage logoSize:(CGSize)logoSize logoMargin:(CGFloat)logoMargin {

    UIGraphicsBeginImageContextWithOptions(qrcode.size, NO, qrcode.scale);

    CGRect rect = CGRectMake((qrcode.size.width - logoSize.width) * 0.5f,
                             (qrcode.size.height - logoSize.height) * 0.5f,
                             logoSize.width,
                             logoSize.height);

    [qrcode drawInRect:CGRectMake(0, 0, qrcode.size.width, qrcode.size.height)];

    if (logoImage) {
        if (logoMargin > 0) {
            CGContextClearRect(UIGraphicsGetCurrentContext(), (CGRect){rect.origin.x - logoMargin, rect.origin.y - logoMargin, rect.size.width + logoMargin * 2, rect.size.height + logoMargin * 2});
        }
        [logoImage drawInRect:rect];
    }

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

// 缩放图片(生成高质量图片）
+ (UIImage *)scaleImage:(CIImage *)image toSize:(CGSize)size {

    // 将rect取整后返回，origin取舍，size取入
    CGRect integralRect = image.extent;  // CGRectIntegral(image.extent);
    // 将CIImage转成CGImageRef
    CGImageRef imageRef = [[CIContext context] createCGImage:image fromRect:integralRect];

    // 创建上下文
    // 计算需要缩放的比例
    CGFloat sideScale = fminf(size.width / integralRect.size.width, size.width / integralRect.size.height) * [UIScreen mainScreen].scale;
    size_t contextRefWidth = floor(integralRect.size.width * sideScale);
    size_t contextRefHeight = floor(integralRect.size.height * sideScale);
    // 灰度、不透明
    CGContextRef contextRef = CGBitmapContextCreate(nil, contextRefWidth, contextRefHeight, 8, 0, CGColorSpaceCreateDeviceGray(), (CGBitmapInfo)kCGImageAlphaNone);
    // 设置上下文无插值
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
    // 设置上下文缩放
    CGContextScaleCTM(contextRef, sideScale, sideScale);
    // 在上下文中的integralRect中绘制imageRef
    CGContextDrawImage(contextRef, integralRect, imageRef);

    // 从上下文中获取CGImageRef
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(contextRef);

    CGContextRelease(contextRef);
    CGImageRelease(imageRef);

    // 将CGImageRefc转成UIImage
    UIImage *scaledImage = [UIImage imageWithCGImage:scaledImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];

    return scaledImage;
}
@end
