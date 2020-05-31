//
//  HDCategoryIndicatorComponentView.m
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorComponentView.h"

@implementation HDCategoryIndicatorComponentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _componentPosition = HDCategoryComponentPosition_Bottom;
        _scrollEnabled = YES;
        _verticalMargin = 0;
        _scrollAnimationDuration = 0.25;
        _indicatorWidth = HDCategoryViewAutomaticDimension;
        _indicatorWidthIncrement = 0;
        _indicatorHeight = 3;
        _indicatorCornerRadius = HDCategoryViewAutomaticDimension;
        _indicatorColor = [UIColor redColor];
        _scrollStyle = HDCategoryIndicatorScrollStyleSimple;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        NSAssert(NO, @"Use initWithFrame");
    }
    return self;
}

- (CGFloat)indicatorWidthValue:(CGRect)cellFrame {
    if (self.indicatorWidth == HDCategoryViewAutomaticDimension) {
        return cellFrame.size.width + self.indicatorWidthIncrement;
    }
    return self.indicatorWidth + self.indicatorWidthIncrement;
}

- (CGFloat)indicatorHeightValue:(CGRect)cellFrame {
    if (self.indicatorHeight == HDCategoryViewAutomaticDimension) {
        return cellFrame.size.height;
    }
    return self.indicatorHeight;
}

- (CGFloat)indicatorCornerRadiusValue:(CGRect)cellFrame {
    if (self.indicatorCornerRadius == HDCategoryViewAutomaticDimension) {
        return [self indicatorHeightValue:cellFrame] / 2;
    }
    return self.indicatorCornerRadius;
}

#pragma mark - HDCategoryIndicatorProtocol

- (void)hd_refreshState:(HDCategoryIndicatorParamsModel *)model {
}

- (void)hd_contentScrollViewDidScroll:(HDCategoryIndicatorParamsModel *)model {
}

- (void)hd_selectedCell:(HDCategoryIndicatorParamsModel *)model {
}

@end
