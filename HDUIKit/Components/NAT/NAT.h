//
//  NAT.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAlertView.h"
#import "HDTopToastView.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NATAlertButtonLayoutType) {
    NATAlertButtonLayoutTypeRightConfirm = 0,  ///< 确认在右边
    NATAlertButtonLayoutTypeLeftConfirm,       ///< 确认在左边
};

@interface NAT : NSObject

/**
 显示屏幕顶部弹出的 Toast
 
 @param title 标题
 @param content 内容
 @param type 类型
 */
+ (HDTopToastView *)showToastWithTitle:(NSString *_Nullable)title content:(NSString *_Nullable)content type:(HDTopToastType)type;

/**
显示屏幕顶部弹出的 Toast

@param title 标题
@param content 内容
@param type 类型
@param config 配置
*/
+ (HDTopToastView *)showToastWithTitle:(NSString *_Nullable)title content:(NSString *_Nullable)content type:(HDTopToastType)type config:(HDTopToastViewConfig *_Nullable)config;

/// 弹出提示框，确认按钮在右边
/// @param message 信息
/// @param confirmButtonTitle 确认标题
/// @param confirmButtonHandler 确认回调
/// @param cancelButtonTitle 取消标题
/// @param cancelButtonHandler 取消回调
+ (HDAlertView *_Nonnull)showAlertWithMessage:(NSString *_Nullable)message confirmButtonTitle:(NSString *_Nullable)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler _Nullable)confirmButtonHandler cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler _Nullable)cancelButtonHandler;

/// 弹出提示框，确认按钮在右边
/// @param title 标题
/// @param message 信息
/// @param confirmButtonTitle 确认标题
/// @param confirmButtonHandler 确认回调
/// @param cancelButtonTitle 取消标题
/// @param cancelButtonHandler 取消回调
+ (HDAlertView *)showAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message confirmButtonTitle:(NSString *_Nullable)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler _Nullable)confirmButtonHandler cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler _Nullable)cancelButtonHandler;

/// 弹出提示框，确认按钮在右边
/// @param message 信息
/// @param confirmButtonTitle 确认标题
/// @param confirmButtonHandler 确认回调
/// @param cancelButtonTitle 取消标题
/// @param cancelButtonHandler 取消回调
/// @param layoutType 操作按钮布局类型
+ (HDAlertView *)showAlertWithMessage:(NSString *_Nullable)message confirmButtonTitle:(NSString *_Nullable)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler _Nullable)confirmButtonHandler cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler _Nullable)cancelButtonHandler layoutType:(NATAlertButtonLayoutType)layoutType;

/**
 弹出提示框
 
 @param message 内容
 @param buttonTitle 按钮标题
 @param handler 回调
 */
+ (HDAlertView *)showAlertWithMessage:(NSString *_Nullable)message buttonTitle:(NSString *_Nullable)buttonTitle handler:(HDAlertViewButtonHandler _Nullable)handler;

/**
弹出提示框

@param title 标题
@param message 内容
@param buttonTitle 按钮标题
@param handler 回调
*/
+ (HDAlertView *)showAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message buttonTitle:(NSString *_Nullable)buttonTitle handler:(HDAlertViewButtonHandler _Nullable)handler;

/**
 弹出提示框
 
 @param title 标题
 @param contentView 容器 View
 @param buttonTitle 按钮标题
 @param handler 回调
 */
+ (HDAlertView *)showAlertWithTitle:(NSString *_Nullable)title contentView:(UIView *)contentView buttonTitle:(NSString *_Nullable)buttonTitle handler:(HDAlertViewButtonHandler _Nullable)handler;

/**
弹出提示框

@param title 标题
@param contentView 容器 View
@param confirmButtonTitle 确定按钮标题
@param confirmButtonHandler 确定回调
@param cancelButtonTitle 取消按钮标题
@param cancelButtonHandler 取消回调
*/
+ (HDAlertView *)showAlertWithTitle:(NSString *_Nullable)title contentView:(UIView *)contentView confirmButtonTitle:(NSString *_Nullable)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler _Nullable)confirmButtonHandler cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler _Nullable)cancelButtonHandler;
@end

NS_ASSUME_NONNULL_END
