//
//  NAT.h
//  ViPay
//
//  Created by VanJay on 2019/8/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAlertView.h"
#import <FFToast/FFToast.h>
#import <UIKit/UIKit.h>

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
+ (void)showToastWithTitle:(NSString *)title content:(NSString *)content type:(FFToastType)type;

/// 弹出提示框，确认按钮在右边
/// @param message 信息
/// @param confirmButtonTitle 确认标题
/// @param confirmButtonHandler 确认回调
/// @param cancelButtonTitle 取消标题
/// @param cancelButtonHandler 取消回调
+ (void)showAlertWithMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler;

/// 弹出提示框，确认按钮在右边
/// @param message 信息
/// @param confirmButtonTitle 确认标题
/// @param confirmButtonHandler 确认回调
/// @param cancelButtonTitle 取消标题
/// @param cancelButtonHandler 取消回调
/// @param layoutType 操作按钮布局类型
+ (void)showAlertWithMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler layoutType:(NATAlertButtonLayoutType)layoutType;

/**
 弹出提示框
 
 @param message 内容
 @param buttonTitle 按钮标题
 @param handler 回调
 */
+ (void)showAlertWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle handler:(HDAlertViewButtonHandler)handler;
/**
 弹出提示框
 
 @param title 标题
 @param contentView 容器 View
 @param buttonTitle 按钮标题
 @param handler 回调
 */
+ (void)showAlertWithTitle:(NSString *)title contentView:(UIView *)contentView buttonTitle:(NSString *)buttonTitle handler:(HDAlertViewButtonHandler)handler;

/**
弹出提示框

@param title 标题
@param contentView 容器 View
@param confirmButtonTitle 确定按钮标题
@param confirmButtonHandler 确定回调
@param cancelButtonTitle 取消按钮标题
@param cancelButtonHandler 取消回调
*/
+ (void)showAlertWithTitle:(NSString *)title contentView:(UIView *)contentView confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler;
@end
