//
//  HDUIGhostButton.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDUIButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HDUIGhostButtonColor) {
    HDUIGhostButtonColorBlue,
    HDUIGhostButtonColorRed,
    HDUIGhostButtonColorGreen,
    HDUIGhostButtonColorGray,
    HDUIGhostButtonColorWhite,
};

/**
 *  用于 `HDUIGhostButton.cornerRadius` 属性，当 `cornerRadius` 为 `HDUIGhostButtonCornerRadiusAdjustsBounds` 时，`HDUIGhostButton` 会在高度变化时自动调整 `cornerRadius`，使其始终保持为高度的 1/2。
 */
extern const CGFloat HDUIGhostButtonCornerRadiusAdjustsBounds;

/**
 *  “幽灵”按钮，也即背景透明、带圆角边框的按钮
 *
 *  可通过 `HDUIGhostButtonColor` 设置几种预设的颜色，也可以用 `ghostColor` 设置自定义颜色。
 *
 *  @warning 默认情况下，`ghostColor` 只会修改文字和边框的颜色，如果需要让 image 也跟随 `ghostColor` 的颜色，则可将 `adjustsImageWithGhostColor` 设为 `YES`
 */
@interface HDUIGhostButton : HDUIButton

@property (nonatomic, strong, nullable) IBInspectable UIColor *ghostColor;  // 默认为 GhostButtonColorBlue
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;   // 默认为 0pt
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;  // 默认为 HDUIGhostButtonCornerRadiusAdjustsBounds，也即固定保持按钮高度的一半。

/**
 *  控制按钮里面的图片是否也要跟随 `ghostColor` 一起变化，默认为 `NO`
 */
@property (nonatomic, assign) BOOL adjustsImageWithGhostColor UI_APPEARANCE_SELECTOR;

- (instancetype)initWithGhostType:(HDUIGhostButtonColor)ghostType;
- (instancetype)initWithGhostColor:(nullable UIColor *)ghostColor;
@end

NS_ASSUME_NONNULL_END
