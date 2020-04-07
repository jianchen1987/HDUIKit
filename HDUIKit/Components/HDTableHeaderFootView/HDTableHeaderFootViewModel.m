//
//  HDTableHeaderFootViewModel.m
//  ViPay
//
//  Created by VanJay on 2019/9/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTableHeaderFootViewModel.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"

@implementation HDTableHeaderFootViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = HDAppTheme.color.G1;
        self.titleFont = HDAppTheme.font.standard3;
        self.backgroundColor = UIColor.whiteColor;
        self.marginToBottom = -1;
        self.rightButtonTitleColor = HDAppTheme.color.G3;
        self.rightButtonTitleFont = HDAppTheme.font.standard4;
        self.edgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
        self.titleToImageMarin = kRealWidth(6);
        self.rightTitleToImageMarin = kRealWidth(6);
        self.rightViewAlignment = HDTableHeaderFootViewRightViewAlignmentTitleRightImageLeft;
    }
    return self;
}

@end
