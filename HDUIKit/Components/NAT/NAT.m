//
//  NAT.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "NAT.h"

@implementation NAT
+ (HDTopToastView *)showToastWithTitle:(NSString *)title content:(NSString *)content type:(HDTopToastType)type {
    HDTopToastViewConfig *config = HDTopToastViewConfig.new;
    return [self showToastWithTitle:title content:content type:type config:config];
}

+ (HDTopToastView *)showToastWithTitle:(NSString *)title content:(NSString *)content type:(HDTopToastType)type config:(HDTopToastViewConfig *_Nullable)config {
    HDTopToastView *toast = [HDTopToastView toastViewWithTitle:title message:content type:type config:config];
    [toast show];
    return toast;
}

+ (HDAlertView *)showAlertWithMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler {

    return [self showAlertWithTitle:nil message:message confirmButtonTitle:confirmButtonTitle confirmButtonHandler:confirmButtonHandler cancelButtonTitle:cancelButtonTitle cancelButtonHandler:cancelButtonHandler layoutType:NATAlertButtonLayoutTypeRightConfirm];
}

+ (HDAlertView *)showAlertWithMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler layoutType:(NATAlertButtonLayoutType)layoutType {
    return [self showAlertWithTitle:nil message:message confirmButtonTitle:confirmButtonTitle confirmButtonHandler:confirmButtonHandler cancelButtonTitle:cancelButtonTitle cancelButtonHandler:cancelButtonHandler layoutType:layoutType];
}

+ (HDAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler {

    return [self showAlertWithTitle:title message:message confirmButtonTitle:confirmButtonTitle confirmButtonHandler:confirmButtonHandler cancelButtonTitle:cancelButtonTitle cancelButtonHandler:cancelButtonHandler layoutType:NATAlertButtonLayoutTypeRightConfirm];
}

+ (HDAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler layoutType:(NATAlertButtonLayoutType)layoutType {

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:title message:message config:nil];
    alertView.identitableString = message;

    BOOL isRight = layoutType == NATAlertButtonLayoutTypeRightConfirm;

    HDAlertViewButton *confirmButton = confirmButton = [HDAlertViewButton buttonWithTitle:confirmButtonTitle type:HDAlertViewButtonTypeCustom handler:confirmButtonHandler];

    cancelButtonTitle = cancelButtonTitle ?: @"取消";
    HDAlertViewButton *cancelButton = [HDAlertViewButton buttonWithTitle:cancelButtonTitle
                                                                    type:HDAlertViewButtonTypeCancel
                                                                 handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                                     if (cancelButtonHandler) {
                                                                         cancelButtonHandler(alertView, button);
                                                                     } else {
                                                                         [alertView dismiss];
                                                                     }
                                                                 }];
    if (isRight) {
        [alertView addButtons:@[cancelButton, confirmButton]];
    } else {
        [alertView addButtons:@[confirmButton, cancelButton]];
    }

    [alertView show];
    return alertView;
}

+ (HDAlertView *)showAlertWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle handler:(HDAlertViewButtonHandler)handler {

    return [self showAlertWithTitle:nil message:message buttonTitle:buttonTitle handler:handler];
}

+ (HDAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle handler:(HDAlertViewButtonHandler)handler {

    buttonTitle = buttonTitle ?: @"确定";

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:title message:message config:nil];
    alertView.identitableString = message;
    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:buttonTitle type:HDAlertViewButtonTypeCustom handler:handler];
    [alertView addButtons:@[button]];

    [alertView show];
    return alertView;
}

+ (HDAlertView *)showAlertWithTitle:(NSString *)title contentView:(UIView *)contentView buttonTitle:(NSString *)buttonTitle handler:(HDAlertViewButtonHandler)handler {

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil contentView:contentView config:nil];
    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:buttonTitle type:HDAlertViewButtonTypeCustom handler:handler];
    [alertView addButtons:@[button]];

    [alertView show];
    return alertView;
}

+ (HDAlertView *)showAlertWithTitle:(NSString *)title contentView:(UIView *)contentView confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler {

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil contentView:contentView config:nil];
    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:confirmButtonTitle type:HDAlertViewButtonTypeCustom handler:confirmButtonHandler];

    cancelButtonTitle = cancelButtonTitle ?: @"取消";
    HDAlertViewButton *cancelButton = [HDAlertViewButton buttonWithTitle:cancelButtonTitle
                                                                    type:HDAlertViewButtonTypeCancel
                                                                 handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                                     if (cancelButtonHandler) {
                                                                         cancelButtonHandler(alertView, button);
                                                                     } else {
                                                                         [alertView dismiss];
                                                                     }
                                                                 }];

    [alertView addButtons:@[cancelButton, button]];

    [alertView show];
    return alertView;
}
@end
