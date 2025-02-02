//
//  HDUISlider.h
//  HDUIKit
//
//  Created by VanJay on 2020/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  相比系统的 UISlider，支持：
 *  1. 修改背后导轨的高度
 *  2. 修改圆点的大小
 *  3. 修改圆点的阴影样式
 */
@interface HDUISlider : UISlider

/// 背后导轨的高度，默认为 0，表示使用系统默认的高度。
@property (nonatomic, assign) IBInspectable CGFloat trackHeight UI_APPEARANCE_SELECTOR;

/// 中间圆球的大小，默认为 CGSizeZero
/// @warning 注意若设置了 thumbSize 但没设置 thumbColor，则圆点的颜色会使用 self.tintColor 的颜色（但系统 UISlider 默认的圆点颜色是白色带阴影）
@property (nonatomic, assign) IBInspectable CGSize thumbSize UI_APPEARANCE_SELECTOR;

/// 中间圆球的颜色，默认为 nil。
/// @warning 注意请勿使用系统的 thumbTintColor，因为 thumbTintColor 和 thumbImage 是互斥的，设置一个会导致另一个被清空，从而导致样式错误。
@property (nonatomic, strong) IBInspectable UIColor *thumbColor UI_APPEARANCE_SELECTOR;

/// 中间圆球的阴影颜色，默认为 nil
@property (nonatomic, strong) IBInspectable UIColor *thumbShadowColor UI_APPEARANCE_SELECTOR;

/// 中间圆球的阴影偏移值，默认为 CGSizeZero
@property (nonatomic, assign) IBInspectable CGSize thumbShadowOffset UI_APPEARANCE_SELECTOR;

/// 中间圆球的阴影扩散度，默认为 0
@property (nonatomic, assign) IBInspectable CGFloat thumbShadowRadius UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
