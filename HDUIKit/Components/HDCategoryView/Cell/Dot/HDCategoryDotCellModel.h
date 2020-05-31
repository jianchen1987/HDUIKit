//
//  HDCategoryDotCellModel.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryTitleCellModel.h"

typedef NS_ENUM(NSUInteger, HDCategoryDotRelativePosition) {
    HDCategoryDotRelativePosition_TopLeft = 0,
    HDCategoryDotRelativePosition_TopRight,
    HDCategoryDotRelativePosition_BottomLeft,
    HDCategoryDotRelativePosition_BottomRight,
};

@interface HDCategoryDotCellModel : HDCategoryTitleCellModel
@property (nonatomic, assign) BOOL dotHidden;
@property (nonatomic, assign) HDCategoryDotRelativePosition relativePosition;
@property (nonatomic, assign) CGSize dotSize;
@property (nonatomic, assign) CGFloat dotCornerRadius;
@property (nonatomic, strong) UIColor *dotColor;
@property (nonatomic, assign) CGPoint dotOffset;
@end
