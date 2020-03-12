//
//  HDUITextFieldConfig.m
//  HDUIKit
//
//  Created by VanJay on 2019/4/12.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDUITextFieldConfig.h"
#import "HDAppTheme.h"

NSString *const kCharacterSetStringNumber = @"0123456789";
NSString *const kCharacterSetStringNumberAndLetter = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
NSString *const kCharacterSetStringAmount = @"0123456789.";
NSString *const kCharacterSetStringLetter = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

@implementation HDUITextFieldConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认值
        self.placeholderColor = [HDAppTheme HDColorG3];
        self.floatingLabelColor = [HDAppTheme HDColorG3];
        self.leftViewEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 10);
        self.rightViewEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 0);
        self.placeholderEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.bottomLineNormalColor = [HDAppTheme HDColorG4];
        self.bottomLineSelectedColor = [HDAppTheme HDColorC1];
        self.textFieldTintColor = [HDAppTheme HDColorC1];
        self.leftLabelColor = [HDAppTheme HDColorG3];
        self.rightLabelColor = [HDAppTheme HDColorC1];
        self.leftLabelFont = [HDAppTheme HDFontStandard3];
        self.rightLabelFont = [HDAppTheme HDFontStandard3];
        self.font = [UIFont systemFontOfSize:16];
        self.textColor = UIColor.blackColor;
        self.placeholderFont = [UIFont systemFontOfSize:16];
        self.floatingLabelFont = [UIFont systemFontOfSize:12];
        self.hideRightViewWhenEditing = NO;
        self.hideLeftViewWhenEmptyInputUnFoucused = NO;
        self.secureTextEntry = NO;
        self.bottomLineNormalHeight = 1.f;
        self.bottomLineSelectedHeight = 2.f;
        self.textFieldHeightRateExceptMargin = 0.6;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.needShowOrHideRightViewAnimation = NO;
        self.animationDuration = 0;
        self.maxInputLength = 0;
        self.shouldLimitInputLength = YES;
        self.maxInputNumber = 0.f;
        self.allowModifyInputToMaxInputNumber = NO;
        self.maxDecimalsCount = 0;
        self.shouldAppendDecimalAfterEndEditing = NO;
        self.shouldRemoveDecimalAfterBeginEditing = NO;
        self.shouldSeparatedTextWithSymbol = NO;
        self.separatedSymbol = @" ";
        self.marginFloatingLabelToTextField = 0;
        self.marginBottomLineToTextField = 0;
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.shouldSeparatedReverse = false;
        self.separatedReverseUnitLength = 3;

        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 解决外部直接呼出键盘布局时产生的动画bug
            if (weakSelf.animationDuration == 0) {
                weakSelf.animationDuration = 0.3;
            }
        });
    }
    return self;
}

+ (instancetype)defaultConfig {
    HDUITextFieldConfig *obj = [[self alloc] init];
    return obj;
}

- (void)setSeparatedFormat:(NSString *)separatedFormat {
    NSAssert([separatedFormat rangeOfString:@"-"].location != NSNotFound, @"分隔格式为 xxxx-xxxx-xxxx，xx-xxx-xxxx，以 - 分开");

    _separatedFormat = separatedFormat;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    if (secureTextEntry) {
        self.keyboardType = UIKeyboardTypeDefault;
    }
}

#pragma mark - override system methods
- (BOOL)isEqual:(HDUITextFieldConfig *)object {
    BOOL isEqual = YES;
    BOOL isThereAtLeastOnePropertyNotEqual =
        ![self.placeholderColor isEqual:object.placeholderColor] ||
        ![self.floatingLabelColor isEqual:object.floatingLabelColor] ||
        ![self.bottomLineNormalColor isEqual:object.bottomLineNormalColor] ||
        ![self.bottomLineSelectedColor isEqual:object.bottomLineSelectedColor] ||
        ![self.leftLabelColor isEqual:object.leftLabelColor] ||
        ![self.rightLabelColor isEqual:object.rightLabelColor] ||
        ![self.leftIconImage isEqual:object.leftIconImage] ||
        ![self.rightIconImage isEqual:object.rightIconImage] ||
        ![self.placeholder isEqualToString:object.placeholder] ||
        ![self.floatingText isEqualToString:object.floatingText] ||
        ![self.leftLabelString isEqualToString:object.leftLabelString] ||
        ![self.rightLabelString isEqualToString:object.placeholder] ||
        ![self.placeholder isEqualToString:object.rightLabelString] ||
        ![self.attributedPlaceholder isEqual:object.attributedPlaceholder] ||
        ![self.leftLabelFont isEqual:object.leftLabelFont] ||
        ![self.rightLabelFont isEqual:object.rightLabelFont] ||
        ![self.font isEqual:object.font] ||
        ![self.placeholderFont isEqual:object.placeholderFont] ||
        ![self.floatingLabelFont isEqual:object.floatingLabelFont] ||
        !UIEdgeInsetsEqualToEdgeInsets(self.leftViewEdgeInsets, object.leftViewEdgeInsets) ||
        !UIEdgeInsetsEqualToEdgeInsets(self.rightViewEdgeInsets, object.rightViewEdgeInsets) ||
        !UIEdgeInsetsEqualToEdgeInsets(self.placeholderEdgeInsets, object.placeholderEdgeInsets) ||
        self.bottomLineNormalHeight != object.bottomLineNormalHeight ||
        self.bottomLineSelectedHeight != object.bottomLineSelectedHeight ||
        self.textFieldHeightRateExceptMargin != object.textFieldHeightRateExceptMargin ||
        self.marginFloatingLabelToTextField != object.marginFloatingLabelToTextField ||
        self.marginBottomLineToTextField != object.marginBottomLineToTextField ||
        self.maxInputLength != object.maxInputLength ||
        self.shouldLimitInputLength != object.shouldLimitInputLength ||
        ![self.characterSetString isEqualToString:object.characterSetString] ||
        self.maxInputNumber != object.maxInputNumber ||
        self.allowModifyInputToMaxInputNumber != object.allowModifyInputToMaxInputNumber ||
        self.maxDecimalsCount != object.maxDecimalsCount ||
        self.shouldAppendDecimalAfterEndEditing != object.shouldAppendDecimalAfterEndEditing ||
        self.shouldSeparatedTextWithSymbol != object.shouldSeparatedTextWithSymbol ||
        ![self.separatedFormat isEqualToString:object.separatedFormat] ||
        ![self.separatedSymbol isEqualToString:object.separatedSymbol];

    if (isThereAtLeastOnePropertyNotEqual) {
        isEqual = NO;
    }
    return isEqual;
}
@end
