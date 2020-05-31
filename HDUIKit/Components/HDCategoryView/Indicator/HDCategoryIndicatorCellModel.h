//
//  HDCategoryIndicatorCellModel.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryBaseCellModel.h"
#import <UIKit/UIKit.h>

@interface HDCategoryIndicatorCellModel : HDCategoryBaseCellModel
@property (nonatomic, assign, getter=isSepratorLineShowEnabled) BOOL sepratorLineShowEnabled;
@property (nonatomic, strong) UIColor *separatorLineColor;
@property (nonatomic, assign) CGSize separatorLineSize;
/// 底部指示器的frame转换到cell的frame
@property (nonatomic, assign) CGRect backgroundViewMaskFrame;
@property (nonatomic, assign, getter=isCellBackgroundColorGradientEnabled) BOOL cellBackgroundColorGradientEnabled;
@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;
@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;
@end
