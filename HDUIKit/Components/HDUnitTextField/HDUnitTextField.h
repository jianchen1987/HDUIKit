//
//  HDUnitTextField.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UnitField 的外观风格

 - HDUnitTextFieldStyleBorder: 边框样式, UnitField 的默认样式
 - HDUnitTextFieldStyleUnderline: 下滑线样式
 */
typedef NS_ENUM(NSUInteger, HDUnitTextFieldStyle) {
    HDUnitTextFieldStyleBorder,
    HDUnitTextFieldStyleUnderline
};

@protocol HDUnitTextFieldDelegate;

IB_DESIGNABLE
@interface HDUnitTextField : UIControl <UITextInput>

@property (nullable, nonatomic, weak) id<HDUnitTextFieldDelegate> delegate;

/**
 保留的用户输入的字符串，最好使用数字字符串，因为目前还不支持其他字符。
 */
@property (nullable, nonatomic, copy) IBInspectable NSString *text;
@property (null_unspecified, nonatomic, copy) IBInspectable UITextContentType textContentType NS_AVAILABLE_IOS(10_0);  // default is nil

#if TARGET_INTERFACE_BUILDER
/**
 允许输入的个数。
 目前 HDUnitTextField 允许的输入单元个数区间控制在 1 ~ 8 个。任何超过该范围内的赋值行为都将被忽略。
 */
@property (nonatomic, assign) IBInspectable NSUInteger inputUnitCount;

/**
 UnitField 的外观风格, 默认为 HDUnitTextFieldStyleBorder.
 */
@property (nonatomic, assign) IBInspectable NSUInteger style;
#else
@property (nonatomic, assign, readonly) NSUInteger inputUnitCount;
@property (nonatomic, assign, readonly) HDUnitTextFieldStyle style;
#endif

/**
 每个 Unit 之间的距离，默认为 12
    ┌┈┈┈┬┈┈┈┬┈┈┈┬┈┈┈┐
    ┆ 1 ┆ 2 ┆ 3 ┆ 4 ┆       unitSpace is 0.
    └┈┈┈┴┈┈┈┴┈┈┈┴┈┈┈┘
    ┌┈┈┈┐┌┈┈┈┐┌┈┈┈┐┌┈┈┈┐
    ┆ 1 ┆┆ 2 ┆┆ 3 ┆┆ 4 ┆    unitSpace is 6
    └┈┈┈┘└┈┈┈┘└┈┈┈┘└┈┈┈┘
 */
@property (nonatomic, assign) IBInspectable NSUInteger unitSpace;

/**
 设置边框圆角
    ╭┈┈┈╮╭┈┈┈╮╭┈┈┈╮╭┈┈┈╮
    ┆ 1 ┆┆ 2 ┆┆ 3 ┆┆ 4 ┆    unitSpace is 6, borderRadius is 4.
    ╰┈┈┈╯╰┈┈┈╯╰┈┈┈╯╰┈┈┈╯
    ╭┈┈┈┬┈┈┈┬┈┈┈┬┈┈┈╮
    ┆ 1 ┆ 2 ┆ 3 ┆ 4 ┆       unitSpace is 0, borderRadius is 4.
    ╰┈┈┈┴┈┈┈┴┈┈┈┴┈┈┈╯
 */
@property (nonatomic, assign) IBInspectable CGFloat borderRadius;

/**
 设置边框宽度，默认为 1。
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 设置文本字体
 */
@property (nonatomic, strong) IBInspectable UIFont *textFont;

/**
 设置文本颜色，默认为黑色。
 */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *textColor;

@property (null_resettable, nonatomic, strong) IBInspectable UIColor *tintColor;

/**
 如果需要完成一个 unit 输入后显示地指定已完成的 unit 颜色，可以设置该属性。默认为 nil。
 注意：
    该属性仅在`unitSpace`属性值大于 2 时有效。在连续模式下，不适合颜色跟踪。可以考虑使用`cursorColor`替代
 */
@property (nullable, nonatomic, strong) IBInspectable UIColor *trackTintColor;

/**
 用于提示输入的焦点所在位置，设置该值后会产生一个光标闪烁动画，如果设置为空，则不生成光标动画。
 */
@property (nullable, nonatomic, strong) IBInspectable UIColor *cursorColor;

/**
 当输入完成后，是否需要自动取消第一响应者。默认为 NO。
 */
@property (nonatomic, assign) IBInspectable BOOL autoResignFirstResponderWhenInputFinished;

/**
 每个 unitfield 的大小, 默认为 44x44
 */
@property (nonatomic, assign) IBInspectable CGSize unitSize;

- (instancetype)initWithInputUnitCount:(NSUInteger)count;
- (instancetype)initWithStyle:(HDUnitTextFieldStyle)style inputUnitCount:(NSUInteger)count;

/// 插入
- (void)insertText:(NSString *)text;

/// 退格
- (void)deleteBackward;

/// 清除
- (void)clear;

@end

@protocol HDUnitTextFieldDelegate <UITextFieldDelegate>

@optional
- (BOOL)unitTextField:(HDUnitTextField *)unitTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 输入完成 end editing
 
 @param textField 输入框
 */
- (void)unitTextFieldDidEndEditing:(HDUnitTextField *)textField;

/**
 开始响应
 
 @param textField 输入框
 */
- (void)unitTextFieldBecomeFirstResponder:(HDUnitTextField *)textField;

/**
取消响应

@param textField 输入框
*/
- (void)unitTextFieldResignFirstResponder:(HDUnitTextField *)textField;

/**
 开始输入 begin editing
 
 @param textField 输入框
 */
- (void)unitTextFieldDidBeginEditing:(HDUnitTextField *)textField;

/**
 删除一个字符 delete a character
 
 @param textField 输入框
 */
- (void)unitTextFieldDidDelete:(HDUnitTextField *)textField;

/**
 清除完成 clear all characters
 
 @param textField 输入框
 */
- (void)unitTextFieldDidClear:(HDUnitTextField *)textField;

@end

NS_ASSUME_NONNULL_END
