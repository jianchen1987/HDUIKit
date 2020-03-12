//
//  HDAppTheme.h
//  HDUIKit
//
//  Created by 帅呆 on 2019/1/28.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDAppTheme : NSObject
/** #f83460 */
+ (UIColor *)HDColorC1;
/** #f5a635 */
+ (UIColor *)HDColorC2;
/** #343b4d */
+ (UIColor *)HDColorG1;
/** #5d667f */
+ (UIColor *)HDColorG2;
/** #ADB6C8 */
+ (UIColor *)HDColorG3;
/** #e4e5ea */
+ (UIColor *)HDColorG4;
/** #f5f7fa */
+ (UIColor *)HDColorG5;
/** #E1E1E1 */
+ (UIColor *)HDColorG6;

+ (UIFont *)fontForSize:(CGFloat)size;
+ (UIFont *)boldFontForSize:(CGFloat)size;
+ (UIFont *)thinFontForSize:(CGFloat)size;

/**
 30 blod
 */
+ (UIFont *)HDFontAmountOnly;
/**
 22 blod
 */
+ (UIFont *)HDFontNumberOnly;
/**
 22
 */
+ (UIFont *)HDFontStandard1Bold;

/**
 23 加粗
 */
+ (UIFont *)HDFont23Bold;

/**
 20 加粗
 */
+ (UIFont *)HDFont20Bold;

/**
 17
 */
+ (UIFont *)HDFontStandard2;
+ (UIFont *)HDFontStandard2Bold;
/**
 15
 */
+ (UIFont *)HDFontStandard3;
+ (UIFont *)HDFontStandard3Bold;
/**
 12
 */
+ (UIFont *)HDFontStandard4Bold;
/**
 12
 */
+ (UIFont *)HDFontStandard4;
/**
 11
 */
+ (UIFont *)HDFontStandard5;
/**
 9
 */
+ (UIFont *)HDFont9;

/**
 边距

 @return 边距
 */
+ (UIEdgeInsets)padding;

+ (CGFloat)textFieldHeight;

+ (CGFloat)normalButtonHeight;

+ (CGFloat)mainButtonHeight;

/** 一像素的大小 */
+ (CGFloat)pixelOne;

+ (CGFloat)statusBarHeight;
@end

NS_ASSUME_NONNULL_END
