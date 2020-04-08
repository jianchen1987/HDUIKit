//
//  HDActionSheetViewConfig.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionSheetViewConfig.h"
#import "HDAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>

@implementation HDActionSheetViewConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认值
        self.lineColor = HexColor(0xE4E5EA);
        self.lineHeight = 0.5;
        self.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.buttonHeight = kRealWidth(50);
        self.containerCorner = 10;
    }
    return self;
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = (CGFloat)(lineHeight * 2) / [UIScreen mainScreen].scale;
}
@end
