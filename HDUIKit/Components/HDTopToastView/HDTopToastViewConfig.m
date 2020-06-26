//
//  HDTopToastViewConfig.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTopToastViewConfig.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"

@implementation HDTopToastViewConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认值
        self.titleFont = HDAppTheme.font.standard3;
        self.titleColor = UIColor.blackColor;
        self.messageFont = HDAppTheme.font.standard3;
        self.messageColor = HDAppTheme.color.G2;
        self.backgroundColor = HDAppTheme.color.C1;
        self.containerViewEdgeInsets = UIEdgeInsetsMake(UIApplication.sharedApplication.statusBarFrame.size.height, kRealWidth(10), 0, kRealWidth(10));
        self.contentViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(10), kRealWidth(15));
        self.marginTitle2Message = kRealWidth(10);
        self.marginTitleToIcon = kRealWidth(8);
        self.containerCorner = 10;
        self.containerMinHeight = 40;
        self.iconWidth = kRealWidth(20);
        self.hideAfterDuration = -1;
    }
    return self;
}
@end
