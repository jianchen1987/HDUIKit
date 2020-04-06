//
//  HDAppTheme.m
//  HDUIKit
//
//  Created by 帅呆 on 2019/1/28.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAppTheme.h"
#import "UIColor+HDKitCore.h"

@implementation HDAppTheme

+ (UIColor *)HDColorC1 {
    return [UIColor hd_colorWithHexString:@"#f83460"];
}

+ (UIColor *)HDColorC2 {
    return [UIColor hd_colorWithHexString:@"#f5a635"];
}

+ (UIColor *)HDColorG1 {
    return [UIColor hd_colorWithHexString:@"#343b4d"];
}

+ (UIColor *)HDColorG2 {
    return [UIColor hd_colorWithHexString:@"#5d667f"];
}

+ (UIColor *)HDColorG3 {
    return [UIColor hd_colorWithHexString:@"#adb6c8"];
}

+ (UIColor *)HDColorG4 {
    return [UIColor hd_colorWithHexString:@"#e4e5ea"];
}

+ (UIColor *)HDColorG5 {
    return [UIColor hd_colorWithHexString:@"#f5f7fa"];
}

+ (UIColor *)HDColorG6 {
    return [UIColor hd_colorWithHexString:@"#E1E1E1"];
}

+ (UIFont *)fontForSize:(CGFloat)size {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)thinFontForSize:(CGFloat)size {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightThin];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)boldFontForSize:(CGFloat)size {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:size];
    }
}

/**
 30 bold
 */
+ (UIFont *)HDFontAmountOnly {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:30.0f weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:30.0f];
    }
}

/**
 22 bold
 */
+ (UIFont *)HDFontNumberOnly {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:23.0f];
    }
}

/**
 22
 */
+ (UIFont *)HDFontStandard1Bold {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:22.0f weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:22.0f];
    }
}

/**
 17
 */
+ (UIFont *)HDFontStandard2 {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:17.0f weight:UIFontWeightRegular];
    } else {
        return [UIFont systemFontOfSize:17.0f];
    }
}

/**
 23 加粗
 */
+ (UIFont *)HDFont23Bold {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:23.0f];
    }
}

/**
 20 加粗
 */
+ (UIFont *)HDFont20Bold {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:20.0f weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:20.0f];
    }
}

/**
 17
 */
+ (UIFont *)HDFontStandard2Bold {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:17.0f weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:17.0f];
    }
}

/**
 15
 */
+ (UIFont *)HDFontStandard3 {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:15.0f weight:UIFontWeightRegular];
    } else {
        return [UIFont systemFontOfSize:15.0f];
    }
}

+ (UIFont *)HDFontStandard3Bold {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:15.0f weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:15.0f];
    }
}

/**
 12
 */
+ (UIFont *)HDFontStandard4Bold {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:12.0f weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:12.0f];
    }
}

/**
 12
 */
+ (UIFont *)HDFontStandard4 {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular];
    } else {
        return [UIFont systemFontOfSize:12.0f];
    }
}

/**
 11
 */
+ (UIFont *)HDFontStandard5 {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:11.0f weight:UIFontWeightRegular];
    } else {
        return [UIFont systemFontOfSize:11.0f];
    }
}

/**
 9
 */
+ (UIFont *)HDFont9 {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:9.0f weight:UIFontWeightRegular];
    } else {
        return [UIFont systemFontOfSize:9.0f];
    }
}

+ (UIEdgeInsets)padding {
    return UIEdgeInsetsMake(25, 15, 25, 15);
}

+ (CGFloat)textFieldHeight {
    return 45.0f;
}

+ (CGFloat)normalButtonHeight {
    return 45.0f;
}

+ (CGFloat)mainButtonHeight {
    return 45.0f;
}

+ (CGFloat)pixelOne {
    return 1.0 / UIScreen.mainScreen.scale;
}

+ (CGFloat)statusBarHeight {
    return CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
}
@end
