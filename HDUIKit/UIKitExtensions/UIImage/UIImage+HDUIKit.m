//
//  UIImage+Extension.m
//  HDUIKit
//
//  Created by VanJay on 2019/6/17.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonDefines.h"
#import "HDHelper.h"
#import "UIBezierPath+HDUIKit.h"
#import "UIColor+HDUIKit.h"
#import "UIImage+HDUIKit.h"

#define CGContextInspectSize(size) [HDHelper inspectContextSize:size]

#ifdef DEBUG
#define CGContextInspectContext(context) [HDHelper inspectContextIfInvalidatedInDebugMode:context]
#else
#define CGContextInspectContext(context)                                \
    if (![HDHelper inspectContextIfInvalidatedInReleaseMode:context]) { \
        return nil;                                                     \
    }
#endif

CG_INLINE CGSize
CGSizeFlatSpecificScale(CGSize size, float scale) {
    return CGSizeMake(flatSpecificScale(size.width, scale), flatSpecificScale(size.height, scale));
}

@implementation UIImage (Bundle)
+ (nullable UIImage *)hd_imageNamed:(nonnull NSString *)name {
    static NSBundle *resourceBundle = nil;
    if (!resourceBundle) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *resourcePath = [mainBundle pathForResource:@"Frameworks/HDUIKit.framework/HDResources" ofType:@"bundle"];
        if (!resourcePath) {
            resourcePath = [mainBundle pathForResource:@"HDResources" ofType:@"bundle"];
        }
        resourceBundle = [NSBundle bundleWithPath:resourcePath] ?: mainBundle;
    }
    UIImage *image = [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
    return image;
}
@end

@implementation UIImage (Color)

+ (UIImage *)hd_imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self hd_imageWithColor:color size:size cornerRadius:0];
}

+ (UIImage *)hd_coloredRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpa:(CGFloat)alpa size:(CGSize)size {
    CGContextInspectSize(size);
    size = CGSizeIsEmpty(size) ? size : CGSizeMake(4, 4);
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpa];
    UIImage *image = [self hd_imageWithColor:color size:size cornerRadius:0];
    return image;
}

- (UIImage *)hd_coloredRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpa:(CGFloat)alpa {
    return [UIImage hd_coloredRed:red green:green blue:blue alpa:blue size:self.size];
}

+ (UIImage *)hd_imageWithColor:(UIColor *)color {
    return [UIImage hd_imageWithColor:color size:CGSizeMake(4, 4) cornerRadius:0];
}

+ (UIImage *)hd_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    size = CGSizeFlatted(size);
    CGContextInspectSize(size);

    color = color ? color : UIColor.clearColor;
    BOOL opaque = (cornerRadius == 0.0 && [color hd_alpha] == 1.0);
    return [UIImage hd_imageWithSize:size
                              opaque:opaque
                               scale:0
                             actions:^(CGContextRef contextRef) {
                                 CGContextSetFillColorWithColor(contextRef, color.CGColor);

                                 if (cornerRadius > 0) {
                                     UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMakeWithSize(size) cornerRadius:cornerRadius];
                                     [path addClip];
                                     [path fill];
                                 } else {
                                     CGContextFillRect(contextRef, CGRectMakeWithSize(size));
                                 }
                             }];
}

+ (UIImage *)hd_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius {
    size = CGSizeFlatted(size);
    CGContextInspectSize(size);
    color = color ? color : UIColor.whiteColor;
    return [UIImage hd_imageWithSize:size
                              opaque:NO
                               scale:0
                             actions:^(CGContextRef contextRef) {
                                 CGContextSetFillColorWithColor(contextRef, color.CGColor);

                                 UIBezierPath *path = [UIBezierPath hd_bezierPathWithRoundedRect:CGRectMakeWithSize(size) cornerRadiusArray:cornerRadius lineWidth:0];
                                 [path addClip];
                                 [path fill];
                             }];
}

- (UIColor *)hd_colorAtPixel:(CGPoint)point {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }

    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = {0, 0, 0, 0};
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);

    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY - (CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);

    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage *)hd_imageWithAlpha:(CGFloat)alpha {
    return [UIImage hd_imageWithSize:self.size
                              opaque:NO
                               scale:self.scale
                             actions:^(CGContextRef contextRef) {
                                 [self drawInRect:CGRectMakeWithSize(self.size) blendMode:kCGBlendModeNormal alpha:alpha];
                             }];
}

- (UIImage *)hd_imageWithTintColor:(UIColor *)tintColor {
    return [UIImage hd_imageWithSize:self.size
                              opaque:self.hd_opaque
                               scale:self.scale
                             actions:^(CGContextRef contextRef) {
                                 CGContextTranslateCTM(contextRef, 0, self.size.height);
                                 CGContextScaleCTM(contextRef, 1.0, -1.0);
                                 CGContextSetBlendMode(contextRef, kCGBlendModeNormal);
                                 CGContextClipToMask(contextRef, CGRectMakeWithSize(self.size), self.CGImage);
                                 CGContextSetFillColorWithColor(contextRef, tintColor.CGColor);
                                 CGContextFillRect(contextRef, CGRectMakeWithSize(self.size));
                             }];
}
@end

@implementation UIImage (Size)
- (UIImage *)clipWithImageRect:(CGRect)clipRect {

    CGRect cropFrame = clipRect;
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, cropFrame);
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(cropFrame.size, 0, deviceScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, cropFrame.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, cropFrame.size.width, cropFrame.size.height), imgRef);
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    return newImg;
}

// 压缩成指定大小代码
- (UIImage *)scaleToSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

// 等比例压缩
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if (newImage == nil) {
        HDLog(@"scale image fail");
    }

    UIGraphicsEndImageContext();

    return newImage;
}

// 等比例压缩
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        HDLog(@"scale image fail");
    }

    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize {

    CGFloat tempWidth = self.size.width;
    CGFloat tempHeight = self.size.height;

    UIImage *resultImg = nil;

    if (tempWidth <= newSize.width && tempHeight <= newSize.height) {
        resultImg = self;
    } else {
        CGFloat tempRate = (float)newSize.width / tempWidth < (float)newSize.height / tempHeight ? (float)newSize.width / tempWidth : (float)newSize.height / tempHeight;
        CGSize itemSize = CGSizeMake(tempRate * tempWidth, tempRate * tempHeight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [self drawInRect:imageRect];
        resultImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    return resultImg;
}

- (UIImage *)fixOrientation {

    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)hd_imageWithClippedRect:(CGRect)rect {

    CGContextInspectSize(rect.size);
    CGRect imageRect = CGRectMakeWithSize(self.size);
    if (CGRectContainsRect(rect, imageRect)) {
        // 要裁剪的区域比自身大，所以不用裁剪直接返回自身即可
        return self;
    }
    // 由于CGImage是以pixel为单位来计算的，而UIImage是以point为单位，所以这里需要将传进来的point转换为pixel
    CGRect scaledRect = CGRectApplyScale(rect, self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledRect);
    UIImage *imageOut = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return imageOut;
}

- (UIImage *)hd_imageResizedWithScreenScaleInLimitedSize:(CGSize)size {
    return [self hd_imageResizedInLimitedSize:size resizingMode:HDUIImageResizingModeScaleAspectFit scale:UIScreen.mainScreen.scale];
}

- (UIImage *)hd_imageResizedInLimitedSize:(CGSize)size {
    return [self hd_imageResizedInLimitedSize:size resizingMode:HDUIImageResizingModeScaleAspectFit];
}

- (UIImage *)hd_imageResizedInLimitedSize:(CGSize)size resizingMode:(HDUIImageResizingMode)resizingMode {
    return [self hd_imageResizedInLimitedSize:size resizingMode:resizingMode scale:self.scale];
}

- (UIImage *)hd_imageResizedInLimitedSize:(CGSize)size resizingMode:(HDUIImageResizingMode)resizingMode scale:(CGFloat)scale {
    size = CGSizeFlatSpecificScale(size, scale);
    CGSize imageSize = self.size;
    CGRect drawingRect = CGRectZero;  // 图片绘制的 rect
    CGSize contextSize = CGSizeZero;  // 画布的大小

    if (CGSizeEqualToSize(size, imageSize) && scale == self.scale) {
        return self;
    }

    if (resizingMode >= HDUIImageResizingModeScaleAspectFit && resizingMode <= HDUIImageResizingModeScaleAspectFillBottom) {
        CGFloat horizontalRatio = size.width / imageSize.width;
        CGFloat verticalRatio = size.height / imageSize.height;
        CGFloat ratio = 0;
        if (resizingMode >= HDUIImageResizingModeScaleAspectFill && resizingMode < (HDUIImageResizingModeScaleAspectFill + 10)) {
            ratio = MAX(horizontalRatio, verticalRatio);
        } else {
            // 默认按 HDUIImageResizingModeScaleAspectFit
            ratio = MIN(horizontalRatio, verticalRatio);
        }
        CGSize resizedSize = CGSizeMake(flatSpecificScale(imageSize.width * ratio, scale), flatSpecificScale(imageSize.height * ratio, scale));
        contextSize = CGSizeMake(MIN(size.width, resizedSize.width), MIN(size.height, resizedSize.height));
        drawingRect.origin.x = CGFloatGetCenter(contextSize.width, resizedSize.width);

        CGFloat originY = 0;
        if (resizingMode % 10 == 1) {
            // toTop
            originY = 0;
        } else if (resizingMode % 10 == 2) {
            // toBottom
            originY = contextSize.height - resizedSize.height;
        } else {
            // default is Center
            originY = CGFloatGetCenter(contextSize.height, resizedSize.height);
        }
        drawingRect.origin.y = originY;

        drawingRect.size = resizedSize;
    } else {
        // 默认按照 HDUIImageResizingModeScaleToFill
        drawingRect = CGRectMakeWithSize(size);
        contextSize = size;
    }

    return [UIImage hd_imageWithSize:contextSize
                              opaque:self.hd_opaque
                               scale:scale
                             actions:^(CGContextRef contextRef) {
                                 [self drawInRect:drawingRect];
                             }];
}
@end

@implementation UIImage (Snapshot)
+ (UIImage *)hd_imageWithView:(UIView *)view {
    CGContextInspectSize(view.bounds.size);
    return [UIImage hd_imageWithSize:view.bounds.size
                              opaque:NO
                               scale:0
                             actions:^(CGContextRef contextRef) {
                                 [view.layer renderInContext:contextRef];
                             }];
}

+ (UIImage *)hd_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates {
    // iOS 7 截图新方式，性能好会好一点，不过不一定适用，因为这个方法的使用条件是：界面要已经render完，否则截到得图将会是empty。
    CGContextInspectSize(view.bounds.size);
    return [UIImage hd_imageWithSize:view.bounds.size
                              opaque:NO
                               scale:0
                             actions:^(CGContextRef contextRef) {
                                 [view drawViewHierarchyInRect:CGRectMakeWithSize(view.bounds.size) afterScreenUpdates:afterUpdates];
                             }];
}
@end

@implementation UIImage (CornerRadius)
#pragma mark - private methods
+ (UIImage *)hd_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale actions:(void (^)(CGContextRef contextRef))actionBlock {
    if (!actionBlock || CGSizeIsEmpty(size)) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextInspectContext(context);
    actionBlock(context);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}

- (UIImage *)hd_imageWithClippedCornerRadius:(CGFloat)cornerRadius {
    return [self hd_imageWithClippedCornerRadius:cornerRadius scale:self.scale];
}

- (UIImage *)hd_imageWithClippedCornerRadius:(CGFloat)cornerRadius scale:(CGFloat)scale {
    if (cornerRadius <= 0) {
        return self;
    }
    return [UIImage hd_imageWithSize:self.size
                              opaque:NO
                               scale:scale
                             actions:^(CGContextRef contextRef) {
                                 [[UIBezierPath bezierPathWithRoundedRect:CGRectMakeWithSize(self.size) cornerRadius:cornerRadius] addClip];
                                 [self drawInRect:CGRectMakeWithSize(self.size)];
                             }];
}
@end

@implementation UIImage (HDUIKit)
- (BOOL)hd_opaque {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = alphaInfo == kCGImageAlphaNoneSkipLast || alphaInfo == kCGImageAlphaNoneSkipFirst || alphaInfo == kCGImageAlphaNone;
    return opaque;
}

- (UIColor *)hd_averageColor {
    unsigned char rgba[4] = {};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextInspectContext(context);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    if (rgba[3] > 0) {
        return [UIColor colorWithRed:((CGFloat)rgba[0] / rgba[3])
                               green:((CGFloat)rgba[1] / rgba[3])
                                blue:((CGFloat)rgba[2] / rgba[3])
                               alpha:((CGFloat)rgba[3] / 255.0)];
    } else {
        return [UIColor colorWithRed:((CGFloat)rgba[0]) / 255.0
                               green:((CGFloat)rgba[1]) / 255.0
                                blue:((CGFloat)rgba[2]) / 255.0
                               alpha:((CGFloat)rgba[3]) / 255.0];
    }
}

- (UIImage *)hd_imageWithOrientation:(UIImageOrientation)orientation {
    if (orientation == UIImageOrientationUp) {
        return self;
    }

    CGSize contextSize = self.size;
    if (orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight) {
        contextSize = CGSizeMake(contextSize.height, contextSize.width);
    }

    contextSize = CGSizeFlatSpecificScale(contextSize, self.scale);

    return [UIImage hd_imageWithSize:contextSize
                              opaque:NO
                               scale:self.scale
                             actions:^(CGContextRef contextRef) {
                                 // 画布的原点在左上角，旋转后可能图片就飞到画布外了，所以旋转前先把图片摆到特定位置再旋转，图片刚好就落在画布里
                                 switch (orientation) {
                                     case UIImageOrientationUp:
                                         // 上
                                         break;
                                     case UIImageOrientationDown:
                                         // 下
                                         CGContextTranslateCTM(contextRef, contextSize.width, contextSize.height);
                                         CGContextRotateCTM(contextRef, AngleWithDegrees(180));
                                         break;
                                     case UIImageOrientationLeft:
                                         // 左
                                         CGContextTranslateCTM(contextRef, 0, contextSize.height);
                                         CGContextRotateCTM(contextRef, AngleWithDegrees(-90));
                                         break;
                                     case UIImageOrientationRight:
                                         // 右
                                         CGContextTranslateCTM(contextRef, contextSize.width, 0);
                                         CGContextRotateCTM(contextRef, AngleWithDegrees(90));
                                         break;
                                     case UIImageOrientationUpMirrored:
                                     case UIImageOrientationDownMirrored:
                                         // 向上、向下翻转是一样的
                                         CGContextTranslateCTM(contextRef, 0, contextSize.height);
                                         CGContextScaleCTM(contextRef, 1, -1);
                                         break;
                                     case UIImageOrientationLeftMirrored:
                                     case UIImageOrientationRightMirrored:
                                         // 向左、向右翻转是一样的
                                         CGContextTranslateCTM(contextRef, contextSize.width, 0);
                                         CGContextScaleCTM(contextRef, -1, 1);
                                         break;
                                 }

                                 // 在前面画布的旋转、移动的结果上绘制自身即可，这里不用考虑旋转带来的宽高置换的问题
                                 [self drawInRect:CGRectMakeWithSize(self.size)];
                             }];
}

+ (UIImage *)hd_animatedImageWithData:(NSData *)data {
    return [self hd_animatedImageWithData:data scale:1];
}

+ (UIImage *)hd_animatedImageWithData:(NSData *)data scale:(CGFloat)scale {
    // http://www.jianshu.com/p/767af9c690a3
    // https://github.com/rs/SDWebImage
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage = nil;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] init];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self hd_frameDurationAtIndex:i source:source];
            UIImage *frameImage = [UIImage imageWithCGImage:image scale:scale == 0 ? kScreenScale : scale orientation:UIImageOrientationUp];
            [images addObject:frameImage];
            CGImageRelease(image);
        }
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}

+ (float)hd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary<NSString *, NSDictionary *> *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary<NSString *, NSNumber *> *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)hd_animatedImageNamed:(NSString *)name {
    return [UIImage hd_animatedImageNamed:name scale:1];
}

+ (UIImage *)hd_animatedImageNamed:(NSString *)name scale:(CGFloat)scale {
    NSString *type = name.pathExtension.lowercaseString;
    type = type.length > 0 ? type : @"gif";
    NSString *path = [[NSBundle mainBundle] pathForResource:name.stringByDeletingPathExtension ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [UIImage hd_animatedImageWithData:data scale:scale];
}

- (UIImage *)hd_imageWithImageAbove:(UIImage *)image atPoint:(CGPoint)point {
    return [UIImage hd_imageWithSize:self.size
                              opaque:self.hd_opaque
                               scale:self.scale
                             actions:^(CGContextRef contextRef) {
                                 [self drawInRect:CGRectMakeWithSize(self.size)];
                                 [image drawAtPoint:point];
                             }];
}
@end
