//
//  HDCustomViewActionViewConfig.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCustomViewActionViewConfig.h"
#import "HDAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>

@implementation HDCustomViewActionViewConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认值
        self.titleColor = HDAppTheme.color.G1;
        self.titleFont = [HDAppTheme.font boldForSize:22];
        self.buttonTitle = @"取消";
        self.buttonTitleColor = HDAppTheme.color.G1;
        self.buttonTitleFont = HDAppTheme.font.standard2Bold;
        self.buttonBgColor = HDAppTheme.color.normalBackground;
        self.buttonHeight = kRealWidth(45);
        self.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), kRealWidth(30), kRealWidth(15));
        self.marginTitleToContentView = kRealWidth(15);
        self.containerMinHeight = 120;
        self.containerCorner = 10;
        self.containerMaxHeight = kScreenHeight * 0.8;
    }
    return self;
}
@end
