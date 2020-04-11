//
//  UIImage+HDImageCropper.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HDImageCropper)
/// 修正方向
- (UIImage *)fixOrientation;

/// 旋转图片
/// @param angleInRadians 角度
- (UIImage *)rotateByAngle:(CGFloat)angleInRadians;

@end
