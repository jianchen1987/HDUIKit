//
//  HDSocialShareAlertViewConfig.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSocialShareAlertViewConfig.h"
#import "HDAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>

@implementation HDSocialShareAlertViewConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleFont = HDAppTheme.font.standard2Bold;
        self.titleColor = HDAppTheme.color.G1;
        self.contentViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), kRealWidth(15), kRealWidth(15));
        self.marginTitleToCollectionView = kRealWidth(10);
        self.cancelTitleFont = HDAppTheme.font.standard2Bold;
        self.cancelTitleColor = HDAppTheme.color.G1;
        self.cancelButtonBackgroundColor = HexColor(0xF5F7FA);
        self.buttonHeight = kRealWidth(45);
        self.containerCorner = 10;
        self.minimumLineSpacing = 0;
        self.collectionCellCol = 4;
        self.cellHeightToWidthRadio = 1.0;
    }
    return self;
}
@end
