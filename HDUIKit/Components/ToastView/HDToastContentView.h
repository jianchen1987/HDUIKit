//
//  HDToastContentView.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * `HDToastView`默认使用的contentView。其结构是：customView->textLabel->detailTextLabel等三个view依次往下排列。其中customView可以赋值任意的UIView或者自定义的view。
 *  注意，customView 会响应 tintColor 的变化。而 textLabel/detailTextLabel 在没设置颜色到 attributes 里的情况下，也会跟随 tintColor 变化，设置了 attributes 的颜色则优先使用 attributes 里的颜色。
 *
 */
@interface HDToastContentView : UIView

/**
 * 设置一个UIView，可以是：菊花、图片等等，请自行保证 customView 的 size 被正确设置。
 */
@property (nonatomic, strong) UIView *customView;

/**
 * 设置第一行大文字label。
 */
@property (nonatomic, strong, readonly) UILabel *textLabel;

/**
 * 通过textLabelText设置可以应用textLabelAttributes的样式，如果通过textLabel.text设置则可能导致一些样式失效。
 */
@property (nonatomic, copy) NSString *textLabelText;

/**
 * 设置第二行小文字label。
 */
@property (nonatomic, strong, readonly) UILabel *detailTextLabel;

/**
 * 通过detailTextLabelText设置可以应用detailTextLabelAttributes的样式，如果通过detailTextLabel.text设置则可能导致一些样式失效。
 */
@property (nonatomic, copy) NSString *detailTextLabelText;

/**
 * 设置上下左右的padding。
 */
@property (nonatomic, assign) UIEdgeInsets insets UI_APPEARANCE_SELECTOR;

/**
 * 设置最小size。
 */
@property (nonatomic, assign) CGSize minimumSize UI_APPEARANCE_SELECTOR;

/**
 * 设置customView的marginBottom。
 */
@property (nonatomic, assign) CGFloat customViewMarginBottom UI_APPEARANCE_SELECTOR;

/**
 * 设置textLabel的marginBottom。
 */
@property (nonatomic, assign) CGFloat textLabelMarginBottom UI_APPEARANCE_SELECTOR;

/**
 * 设置detailTextLabel的marginBottom。
 */
@property (nonatomic, assign) CGFloat detailTextLabelMarginBottom UI_APPEARANCE_SELECTOR;

/**
 * 设置textLabel的attributes，如果包含 NSForegroundColorAttributeName 则 textLabel 不响应 tintColor，如果不包含则 textLabel 会拿 tintColor 当成文字颜色。
 */
@property (nonatomic, strong) NSDictionary<NSString *, id> *textLabelAttributes UI_APPEARANCE_SELECTOR;

/**
 * 设置 detailTextLabel 的 attributes，如果包含 NSForegroundColorAttributeName 则 detailTextLabel 不响应 tintColor，如果不包含则 detailTextLabel 会拿 tintColor 当成文字颜色。
 */
@property (nonatomic, strong) NSDictionary<NSString *, id> *detailTextLabelAttributes UI_APPEARANCE_SELECTOR;

/**
 是否正方形
 */
@property (assign, nonatomic, getter=isSquare) BOOL square UI_APPEARANCE_SELECTOR;

@end
