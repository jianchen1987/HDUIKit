//
//  HDAlertView.h
//  ViPay
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"
#import "HDAlertViewButton.h"
#import "HDAlertViewConfig.h"

@class HDAlertView;

typedef void (^HDAlertViewHandler)(HDAlertView *_Nonnull alertView);

NS_ASSUME_NONNULL_BEGIN

@interface HDAlertView : HDActionAlertView
+ (instancetype)alertViewWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message config:(HDAlertViewConfig *__nullable)config;
- (instancetype)initWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message config:(HDAlertViewConfig *__nullable)config;
+ (instancetype)alertViewWithTitle:(NSString *__nullable)title contentView:(UIView *)contentView config:(HDAlertViewConfig *__nullable)config;
- (instancetype)initWithTitle:(NSString *__nullable)title contentView:(UIView *)contentView config:(HDAlertViewConfig *__nullable)config;
- (void)addButton:(HDAlertViewButton *)button;
- (void)addButtons:(NSArray<HDAlertViewButton *> *)buttons;
@end

NS_ASSUME_NONNULL_END
