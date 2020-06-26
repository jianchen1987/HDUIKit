//
//  HDTopToastView.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"
#import "HDTopToastViewConfig.h"

typedef NS_ENUM(NSInteger, HDTopToastType) {
    HDTopToastTypeDefault = 1,  ///< 无 icon
    HDTopToastTypeSuccess = 2,  ///< 成功
    HDTopToastTypeError = 3,    ///< 错误
    HDTopToastTypeWarning = 4,  ///< 警告
    HDTopToastTypeInfo = 5      ///< 提示
};

@class HDTopToastView;

typedef void (^HDTopToastViewHandler)(HDTopToastView *_Nonnull toastView);

NS_ASSUME_NONNULL_BEGIN

@interface HDTopToastView : HDActionAlertView
+ (instancetype)toastViewWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message type:(HDTopToastType)type config:(HDTopToastViewConfig *__nullable)config;
- (instancetype)initWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message type:(HDTopToastType)type config:(HDTopToastViewConfig *__nullable)config;
@end

NS_ASSUME_NONNULL_END
