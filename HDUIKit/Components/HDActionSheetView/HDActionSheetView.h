//
//  HDActionSheetView.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"
#import "HDActionSheetViewButton.h"
#import "HDActionSheetViewConfig.h"

@class HDActionSheetView;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HDActionSheetViewHandler)(HDActionSheetView *alertView);

@interface HDActionSheetView : HDActionAlertView
+ (instancetype)alertViewWithCancelButtonTitle:(NSString *__nullable)cancelButtonTitle config:(HDActionSheetViewConfig *__nullable)config;
- (instancetype)initWithCancelButtonTitle:(NSString *__nullable)cancelButtonTitle config:(HDActionSheetViewConfig *__nullable)config;
- (void)addButton:(HDActionSheetViewButton *)button;
- (void)addButtons:(NSArray<HDActionSheetViewButton *> *)buttons;
@end

NS_ASSUME_NONNULL_END
