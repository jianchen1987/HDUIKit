//
//  HDAlertViewButton.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDAlertViewButtonType) {
    HDAlertViewButtonTypeDefault = 0,
    HDAlertViewButtonTypeCustom,
    HDAlertViewButtonTypeCancel
};

@class HDAlertView;
@class HDAlertViewButton;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HDAlertViewButtonHandler)(HDAlertView *alertView, HDAlertViewButton *button);

@interface HDAlertViewButton : UIButton
@property (nonatomic, assign) HDAlertViewButtonType type;      ///< 类型
@property (nonatomic, weak) HDAlertView *alertView;            ///< 弹窗
@property (nonatomic, copy) HDAlertViewButtonHandler handler;  ///< 回调

+ (instancetype)buttonWithTitle:(NSString *)title type:(HDAlertViewButtonType)type handler:(HDAlertViewButtonHandler)handler;
- (instancetype)initWithTitle:(NSString *)title type:(HDAlertViewButtonType)type handler:(HDAlertViewButtonHandler)handler;
@end

NS_ASSUME_NONNULL_END
