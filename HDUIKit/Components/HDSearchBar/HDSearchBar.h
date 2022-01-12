//
//  HDSearchBar.h
//  HDUIKit
//
//  Created by VanJay on 2019/4/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDSearchBar;

@protocol HDSearchBarDelegate <NSObject>

@optional
- (BOOL)searchBarTextShouldBeginEditing:(HDSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0));
- (void)searchBar:(HDSearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarLeftButtonClicked:(HDSearchBar *)searchBar;
- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar;
- (BOOL)searchBar:(HDSearchBar *)searchBar shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)searchBarShouldClear:(HDSearchBar *)searchBar;
- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField;
@end

@interface HDSearchBar : UIView
/// 动画时间，默认 0.25
@property (nonatomic, assign) NSTimeInterval animationDuration;
/// 输入框字体
@property (nonatomic, strong) UIFont *textFont;
/// 输入框文字颜色
@property (nonatomic, strong) UIColor *textColor;
/// 光标颜色
@property (nonatomic, strong) UIColor *tintColor;
/// 边框颜色
@property (nonatomic, strong) UIColor *borderColor;
/// 按钮文字颜色
@property (nonatomic, strong) UIColor *buttonTitleColor;
/// 水平方向边缘间距
@property (nonatomic, assign) CGFloat marginToSide;
/// 按钮和输入框距离
@property (nonatomic, assign) CGFloat marginButtonTextField;
/// 文本
@property (nonatomic, copy) NSString *text;
/// 占位文本
@property (nonatomic, copy) NSString *placeHolder;
/// 占位文本颜色
@property (nonatomic, strong) UIColor *placeholderColor;
/// 查找图片
@property (nonatomic, strong) UIImage *searchImage;
/// 自定义的输入框高度
@property (nonatomic, assign) CGFloat textFieldHeight;
/** 显示下部分阴影，默认为关闭，支持随时关闭 */
@property (nonatomic, assign) BOOL showBottomShadow;
/// 输入框背景色
@property (nonatomic, strong) UIColor *inputFieldBackgrounColor;
/// 代理
@property (nonatomic, weak) id<HDSearchBarDelegate> delegate;
/// 输入框
@property (nonatomic, strong, readonly) UITextField *textField;

/// 显示或隐藏左侧按钮
/// @param showLeftButton 是否显示
/// @param animated 是否带动画（布局未完成时不做动画）
- (void)setShowLeftButton:(BOOL)showLeftButton animated:(BOOL)animated;

/// 设置左侧按钮标题
/// @param title 标题
- (void)setLeftButtonTitle:(NSString *)title;

/// 设置左侧按钮图片
/// @param image 图片
- (void)setLeftButtonImage:(UIImage *)image;

/// 显示或隐藏右侧按钮
/// @param showRightButton 是否显示
/// @param animated 是否带动画（布局未完成时不做动画）
- (void)setShowRightButton:(BOOL)showRightButton animated:(BOOL)animated;

/// 设置右侧按钮标题
/// @param title 标题
- (void)setRightButtonTitle:(NSString *)title;

/// 设置右侧按钮图片
/// @param image 图片
- (void)setRightButtonImage:(UIImage *)image;

/// 获取输入框内容
- (NSString *)getText;

/// 禁用输入框
- (void)disableTextField;

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

@end

NS_ASSUME_NONNULL_END
