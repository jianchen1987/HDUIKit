//
//  UIViewPlaceholderViewModel.m
//  HDUIKit
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "UIViewPlaceholderViewModel.h"
#import "HDAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>

@implementation UIViewPlaceholderViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.scaleImage = NO;
        self.image = @"placeholder_no_data_coupon";
        self.title = @"暂无数据";
        self.titleColor = HDAppTheme.color.G3;
        self.needRefreshBtn = NO;
        self.refreshBtnTitle = @"刷新";
        self.refreshBtnTitleFont = HDAppTheme.font.standard3;
        self.refreshBtnTitleColor = UIColor.whiteColor;
        self.marginInfoToImage = 10;
        self.marginBtnToInfo = kRealWidth(30);
        self.refreshBtnBackgroundColor = HDAppTheme.color.C1;
        self.refreshButtonLabelEdgeInset = UIEdgeInsetsMake(8, 30, 8, 30);
    }
    return self;
}

@end
