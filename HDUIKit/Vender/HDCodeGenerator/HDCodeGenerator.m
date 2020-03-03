//
//  HDCodeGenerator.m
//  ViPay
//
//  Created by VanJay on 2019/8/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCodeGenerator.h"
#import "qrencode.h"

static NSString *const QiInputCorrectionLevelL = @"L";  //!< L: 7%
static NSString *const QiInputCorrectionLevelM = @"M";  //!< M: 15%
static NSString *const QiInputCorrectionLevelQ = @"Q";  //!< Q: 25%
static NSString *const QiInputCorrectionLevelH = @"H";  //!< H: 30%

@implementation HDCodeGenerator

+ (UIImage *)qrCodeImageForStr:(NSString *)string size:(CGSize)size logoImage:(UIImage *)logo {
    UIImage *qrcode = [self qrCodeImageForStr:string size:size];
    UIImage *image = [self combinateCodeImage:qrcode withLogo:logo];
    return image;
}

+ (UIImage *)barCodeImageForStr:(NSString *)code size:(CGSize)size {

    NSData *codeData = [code dataUsingEncoding:NSUTF8StringEncoding];
    //  使用CICode128BarcodeGenerator创建filter
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"
                            withInputParameters:@{@"inputMessage": codeData,
                                                  @"inputQuietSpace": @.0}];
    // 由filter.outputImage直接转成的UIImage不太清楚，需要做高清处理
    UIImage *codeImage = [self scaleImage:filter.outputImage toSize:size];

    return codeImage;
}

+ (UIImage *)qrCodeImageForStr:(NSString *)code size:(CGSize)size {

    NSData *codeData = [code dataUsingEncoding:NSUTF8StringEncoding];
    //  使用CIQRCodeGenerator创建filter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"
                            withInputParameters:@{@"inputMessage": codeData,
                                                  @"inputCorrectionLevel": QiInputCorrectionLevelH}];
    // 由filter.outputImage直接转成的UIImage不太清楚，需要做高清处理
    UIImage *codeImage = [self scaleImage:filter.outputImage toSize:size];

    return codeImage;
}

#pragma mark - private methods
+ (UIImage *)combinateCodeImage:(UIImage *)qrcode withLogo:(UIImage *)badge {
    // logo大小为二维码的1/4
    CGSize sizeTmp;
    sizeTmp.height = qrcode.size.height * 0.25f;
    sizeTmp.width = qrcode.size.width * 0.25f;

    UIGraphicsBeginImageContextWithOptions(qrcode.size, NO, qrcode.scale);
    [qrcode drawInRect:CGRectMake(0, 0, qrcode.size.width, qrcode.size.height)];
    if (badge) {
        [badge drawInRect:CGRectMake((qrcode.size.width - sizeTmp.width) * 0.5f,
                                     (qrcode.size.height - sizeTmp.height) * 0.5f,
                                     sizeTmp.width,
                                     sizeTmp.height)];
    }

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

// 缩放图片(生成高质量图片）
+ (UIImage *)scaleImage:(CIImage *)image toSize:(CGSize)size {

    //! 将CIImage转成CGImageRef
    CGRect integralRect = image.extent;  // CGRectIntegral(image.extent);// 将rect取整后返回，origin取舍，size取入
    CGImageRef imageRef = [[CIContext context] createCGImage:image fromRect:integralRect];

    //! 创建上下文
    CGFloat sideScale = fminf(size.width / integralRect.size.width, size.width / integralRect.size.height) * [UIScreen mainScreen].scale;  // 计算需要缩放的比例
    size_t contextRefWidth = ceilf(integralRect.size.width * sideScale);
    size_t contextRefHeight = ceilf(integralRect.size.height * sideScale);
    CGContextRef contextRef = CGBitmapContextCreate(nil, contextRefWidth, contextRefHeight, 8, 0, CGColorSpaceCreateDeviceGray(), (CGBitmapInfo)kCGImageAlphaNone);  // 灰度、不透明
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);                                                                                              // 设置上下文无插值
    CGContextScaleCTM(contextRef, sideScale, sideScale);                                                                                                             // 设置上下文缩放
    CGContextDrawImage(contextRef, integralRect, imageRef);                                                                                                          // 在上下文中的integralRect中绘制imageRef

    //! 从上下文中获取CGImageRef
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(contextRef);

    CGContextRelease(contextRef);
    CGImageRelease(imageRef);

    //! 将CGImageRefc转成UIImage
    UIImage *scaledImage = [UIImage imageWithCGImage:scaledImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];

    return scaledImage;
}
@end
