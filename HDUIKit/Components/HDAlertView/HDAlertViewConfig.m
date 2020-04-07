//
//  HDAlertViewConfig.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAlertViewConfig.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"

@implementation HDAlertViewConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        const CGFloat onePix = (CGFloat)(1 * 2) / [UIScreen mainScreen].scale;
        // 默认值
        self.titleFont = HDAppTheme.font.standard3;
        self.titleColor = UIColor.blackColor;
        self.messageFont = HDAppTheme.font.standard3;
        self.messageColor = HDAppTheme.color.G2;
        self.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(15), onePix, onePix, onePix);
        self.contentViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(15), kRealWidth(5), kRealWidth(15));
        self.labelHEdgeMargin = kRealWidth(15);
        self.marginTitle2Message = kRealWidth(15);
        self.marginMessageToButton = kRealWidth(15);
        self.buttonHMargin = onePix;
        self.buttonVMargin = 5;
        self.buttonHeight = kRealWidth(45);
        self.buttonCorner = 10;
        self.containerCorner = 10;
        self.containerMinHeight = 150;
    }
    return self;
}
@end
