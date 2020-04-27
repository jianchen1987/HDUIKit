//
//  HDKeyboardManager.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDKeyboardManager : NSObject
+ (instancetype)sharedInstance;

/// 键盘唤起时，点击键盘以外的区域是否收起键盘，默认未开启
@property (nonatomic, assign) BOOL shouldResignOnTouchOutside;

/// 键盘唤起时，当前 window 上添加的用于点击空白收起键盘的手势对象
@property (nonnull, nonatomic, strong, readonly) UITapGestureRecognizer *resignFirstResponderGesture;

/// 收起键盘的手势忽略的界面，默认 [UIAlertController, UIAlertControllerTextFieldViewController]
@property (nonatomic, strong, nonnull, readonly) NSMutableSet<Class> *disabledTouchResignedClasses;

/// 收起键盘的手势强制生效的界面，默认 []
@property (nonatomic, strong, nonnull, readonly) NSMutableSet<Class> *enabledTouchResignedClasses;

/// 如果当前界面收起键盘手势开启，但局部不生效，可以设置该属性，默认 [UIControl, UINavigationBar]
@property (nonatomic, strong, nonnull, readonly) NSMutableSet<Class> *touchResignedGestureIgnoreClasses;
@end

NS_ASSUME_NONNULL_END
