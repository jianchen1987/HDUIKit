//
//  HDCategoryIconTitleCellModel.h
//  HDKitCore
//
//  Created by seeu on 2023/11/30.
//

#import "HDCategoryTitleCellModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HDCategoryIconRelativePosition) {
    HDCategoryIconRelativePositionTop = 0,
    HDCategoryIconRelativePositionLeft,
    HDCategoryIconRelativePositionBottom,
    HDCategoryIconRelativePositionRight,
};

@interface HDCategoryIconTitleCellModel : HDCategoryTitleCellModel
///< icon相对title的位置，默认top
@property (nonatomic, assign) HDCategoryIconRelativePosition relativePosition;
/// 图片url数组
@property (nonatomic, copy) NSString *iconUrl;
/// 图片尺寸。默认：CGSizeMake(5, 5)
@property (nonatomic, assign) CGSize iconSize;
/// icon的圆角值。默认：HDCategoryViewAutomaticDimension（self.dotSize.height/2）
@property (nonatomic, assign) CGFloat iconCornerRadius;
/// 与title的间距
@property (nonatomic, assign) CGFloat offset;
@end

NS_ASSUME_NONNULL_END
