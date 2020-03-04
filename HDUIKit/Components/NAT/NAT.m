//
//  NAT.m
//  ViPay
//
//  Created by VanJay on 2019/8/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "NAT.h"

@implementation NAT
+ (void)showToastWithTitle:(NSString *)title content:(NSString *)content type:(FFToastType)type {
    FFToast *toast = [[FFToast alloc] initToastWithTitle:title message:content iconImage:nil];
    toast.duration = 3.0f;
    toast.toastType = type;
    toast.toastPosition = FFToastPositionDefault;
    [toast show];
}

+ (void)showAlertWithMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler {

    [self showAlertWithMessage:message confirmButtonTitle:confirmButtonTitle confirmButtonHandler:confirmButtonHandler cancelButtonTitle:cancelButtonTitle cancelButtonHandler:cancelButtonHandler layoutType:NATAlertButtonLayoutTypeRightConfirm];
}

+ (void)showAlertWithMessage:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler layoutType:(NATAlertButtonLayoutType)layoutType {

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil message:message config:nil];
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
}

+ (void)showAlertWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle handler:(HDAlertViewButtonHandler)handler {

    buttonTitle = buttonTitle ?: @"确定";

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil message:message config:nil];
    alertView.identitableString = message;
    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:buttonTitle type:HDAlertViewButtonTypeCustom handler:handler];
    [alertView addButtons:@[button]];

    [alertView show];
}

+ (void)showAlertWithTitle:(NSString *)title contentView:(UIView *)contentView buttonTitle:(NSString *)buttonTitle handler:(HDAlertViewButtonHandler)handler {

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil contentView:contentView config:nil];
    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:buttonTitle type:HDAlertViewButtonTypeCustom handler:handler];
    [alertView addButtons:@[button]];

    [alertView show];
}

+ (void)showAlertWithTitle:(NSString *)title contentView:(UIView *)contentView confirmButtonTitle:(NSString *)confirmButtonTitle confirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonHandler:(HDAlertViewButtonHandler)cancelButtonHandler {

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
}
@end
