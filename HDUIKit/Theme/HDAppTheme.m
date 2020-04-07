//
//  HDAppTheme.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDAppTheme.h"
#import "UIColor+HDKitCore.h"

@implementation HDAppThemeFont

- (UIFont *)forSize:(CGFloat)size {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

- (UIFont *)thinForSize:(CGFloat)size {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightThin];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

- (UIFont *)boldForSize:(CGFloat)size {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
    } else {
        return [UIFont boldSystemFontOfSize:size];
    }
}

- (UIFont *)amountOnly {
    return [self boldForSize:30.f];
}

- (UIFont *)numberOnly {
    return [self boldForSize:23.f];
}

- (UIFont *)_23Bold {
    return [self boldForSize:23.f];
}

- (UIFont *)_20Bold {
    return [self boldForSize:20.f];
}

- (UIFont *)standard1Bold {
    return [self boldForSize:22.f];
}

- (UIFont *)standard2 {
    return [self forSize:17.f];
}

- (UIFont *)standard2Bold {
    return [self boldForSize:17.f];
}

- (UIFont *)standard3 {
    return [self forSize:15.f];
}

- (UIFont *)standard3Bold {
    return [self boldForSize:15.f];
}

- (UIFont *)standard4 {
    return [self forSize:12.f];
}

- (UIFont *)standard4Bold {
    return [self boldForSize:12.f];
}

- (UIFont *)standard5 {
    return [self forSize:11.f];
}

- (UIFont *)standard5Bold {
    return [self boldForSize:11.f];
}

@end

@implementation HDAppThemeColor

- (UIColor *)C1 {
    return [UIColor hd_colorWithHexString:@"#f83460"];
}

- (UIColor *)C2 {
    return [UIColor hd_colorWithHexString:@"#f5a635"];
}

- (UIColor *)G1 {
    return [UIColor hd_colorWithHexString:@"#343b4d"];
}

- (UIColor *)G2 {
    return [UIColor hd_colorWithHexString:@"#5d667f"];
}

- (UIColor *)G3 {
    return [UIColor hd_colorWithHexString:@"#adb6c8"];
}

- (UIColor *)G4 {
    return [UIColor hd_colorWithHexString:@"#e4e5ea"];
}

- (UIColor *)G5 {
    return [UIColor hd_colorWithHexString:@"#f5f7fa"];
}

- (UIColor *)G6 {
    return [UIColor hd_colorWithHexString:@"#E1E1E1"];
}

@end

@implementation HDAppThemeValue

- (UIEdgeInsets)padding {
    return UIEdgeInsetsMake(25, 15, 25, 15);
}

- (CGFloat)textFieldHeight {
    return 45.0f;
}

- (CGFloat)buttonHeight {
    return 45.0f;
}

- (CGFloat)pixelOne {
    return 1.0 / UIScreen.mainScreen.scale;
}

- (CGFloat)statusBarHeight {
    return CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
}

@end

@implementation HDAppTheme

static HDAppThemeFont *_font;
+ (HDAppThemeFont *)font {
    if (_font == nil) {
        _font = [HDAppThemeFont new];
    }
    return _font;
}

static HDAppThemeColor *_color;
+ (HDAppThemeColor *)color {
    if (_color == nil) {
        _color = [HDAppThemeColor new];
    }
    return _color;
}

static HDAppThemeValue *_value;
+ (HDAppThemeValue *)value {
    if (_value == nil) {
        _value = [HDAppThemeValue new];
    }
    return _value;
}
@end
