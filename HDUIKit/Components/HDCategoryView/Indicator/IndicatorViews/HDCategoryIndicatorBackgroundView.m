//
//  HDCategoryIndicatorBackgroundView.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorBackgroundView.h"
#import "HDCategoryFactory.h"

@implementation HDCategoryIndicatorBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorWidth = HDCategoryViewAutomaticDimension;
        self.indicatorHeight = HDCategoryViewAutomaticDimension;
        self.indicatorCornerRadius = HDCategoryViewAutomaticDimension;
        self.indicatorColor = [UIColor lightGrayColor];
        self.indicatorWidthIncrement = 10;
    }
    return self;
}

#pragma mark - HDCategoryIndicatorProtocol

- (void)hd_refreshState:(HDCategoryIndicatorParamsModel *)model {
    self.layer.cornerRadius = [self indicatorCornerRadiusValue:model.selectedCellFrame];
    self.backgroundColor = self.indicatorColor;

    CGFloat width = [self indicatorWidthValue:model.selectedCellFrame];
    CGFloat height = [self indicatorHeightValue:model.selectedCellFrame];
    CGFloat x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - width) / 2;
    CGFloat y = (model.selectedCellFrame.size.height - height) / 2 - self.verticalMargin;
    self.frame = CGRectMake(x, y, width, height);
}

- (void)hd_contentScrollViewDidScroll:(HDCategoryIndicatorParamsModel *)model {
    CGRect rightCellFrame = model.rightCellFrame;
    CGRect leftCellFrame = model.leftCellFrame;
    CGFloat percent = model.percent;
    CGFloat targetX = 0;
    CGFloat targetWidth = [self indicatorWidthValue:leftCellFrame];

    if (percent == 0) {
        targetX = leftCellFrame.origin.x + (leftCellFrame.size.width - targetWidth) / 2.0;
    } else {
        CGFloat leftWidth = targetWidth;
        CGFloat rightWidth = [self indicatorWidthValue:rightCellFrame];

        CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - leftWidth) / 2;
        CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - rightWidth) / 2;

        targetX = [HDCategoryFactory interpolationFrom:leftX to:rightX percent:percent];

        if (self.indicatorWidth == HDCategoryViewAutomaticDimension) {
            targetWidth = [HDCategoryFactory interpolationFrom:leftWidth to:rightWidth percent:percent];
        }
    }

    // 允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    if (self.isScrollEnabled == YES || (self.isScrollEnabled == NO && percent == 0)) {
        CGRect toFrame = self.frame;
        toFrame.origin.x = targetX;
        toFrame.size.width = targetWidth;
        self.frame = toFrame;
    }
}

- (void)hd_selectedCell:(HDCategoryIndicatorParamsModel *)model {
    CGFloat width = [self indicatorWidthValue:model.selectedCellFrame];
    CGRect toFrame = self.frame;
    toFrame.origin.x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - width) / 2;
    toFrame.size.width = width;

    if (self.isScrollEnabled) {
        [UIView animateWithDuration:self.scrollAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.frame = toFrame;
                         }
                         completion:^(BOOL finished){
                         }];
    } else {
        self.frame = toFrame;
    }
}

@end
