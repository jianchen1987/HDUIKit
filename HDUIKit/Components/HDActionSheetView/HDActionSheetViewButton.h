//
//  HDActionSheetViewButton.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDActionSheetViewButtonType) {
    HDActionSheetViewButtonTypeDefault = 0,
    HDActionSheetViewButtonTypeCustom,
    HDActionSheetViewButtonTypeCancel
};

@class HDActionSheetView;
@class HDActionSheetViewButton;

typedef void (^HDActionSheetViewButtonHandler)(HDActionSheetView *alertView, HDActionSheetViewButton *button);

NS_ASSUME_NONNULL_BEGIN

@interface HDActionSheetViewButton : UIButton
@property (nonatomic, assign) HDActionSheetViewButtonType type;      ///< 类型
@property (nonatomic, weak) HDActionSheetView *alertView;            ///< 弹窗
@property (nonatomic, copy) HDActionSheetViewButtonHandler handler;  ///< 回调

+ (instancetype)buttonWithTitle:(NSString *)title type:(HDActionSheetViewButtonType)type handler:(HDActionSheetViewButtonHandler)handler;
- (instancetype)initWithTitle:(NSString *)title type:(HDActionSheetViewButtonType)type handler:(HDActionSheetViewButtonHandler)handler;
@end

NS_ASSUME_NONNULL_END
