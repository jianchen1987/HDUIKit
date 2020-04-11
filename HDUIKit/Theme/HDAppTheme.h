//
//  HDAppTheme.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDAppThemeFont : NSObject

- (UIFont *)forSize:(CGFloat)size;
- (UIFont *)boldForSize:(CGFloat)size;
- (UIFont *)thinForSize:(CGFloat)size;

/** 30 加粗 */
- (UIFont *)amountOnly;

/** 23 加粗 */
- (UIFont *)numberOnly;

/** 23 加粗 */
- (UIFont *)_23Bold;

/** 20 加粗 */
- (UIFont *)_20Bold;

/** 22 加粗 */
- (UIFont *)standard1Bold;

/** 17 */
- (UIFont *)standard2;

/** 17 加粗 */
- (UIFont *)standard2Bold;

/** 15 */
- (UIFont *)standard3;

/** 15 加粗 */
- (UIFont *)standard3Bold;

/** 12 */
- (UIFont *)standard4;

/** 12 加粗 */
- (UIFont *)standard4Bold;

/** 11 */
- (UIFont *)standard5;

/** 11 加粗 */
- (UIFont *)standard5Bold;
@end

@interface HDAppThemeColor : NSObject
/** #FC821A */
- (UIColor *)C1;

/** #FF4444 */
- (UIColor *)C2;

/** #22B573 */
- (UIColor *)C3;

/** #EBB626 */
- (UIColor *)C4;

/** #343b4d */
- (UIColor *)G1;

/** #5d667f */
- (UIColor *)G2;

/** #ADB6C8 */
- (UIColor *)G3;

/** #e4e5ea */
- (UIColor *)G4;

/** #f5f7fa */
- (UIColor *)G5;

/** #E1E1E1 */
- (UIColor *)G6;

/** #F5F7FA */
- (UIColor *)normalBackground;
@end

@interface HDAppThemeValue : NSObject
/** 布局时，与控制器 View 内边距 */
- (UIEdgeInsets)padding;

/** 输入框高度 */
- (CGFloat)textFieldHeight;

/** 按钮高度 */
- (CGFloat)buttonHeight;

/** 一像素的大小 */
- (CGFloat)pixelOne;

/** 状态栏高度 */
- (CGFloat)statusBarHeight;
@end

@interface HDAppTheme : NSObject
/** 字体 */
+ (HDAppThemeFont *)font;

/** 颜色 */
+ (HDAppThemeColor *)color;

/** 距离、大小、尺寸 */
+ (HDAppThemeValue *)value;
@end

NS_ASSUME_NONNULL_END
