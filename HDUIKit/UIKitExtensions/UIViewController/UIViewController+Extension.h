//
//  UIViewController+Extension.h
//  HDUIKit
//
//  Created by 谢 on 2019/1/9.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)
+ (instancetype)viewFromXIB;

/// 控制器 pop 或 dismiss，内部会判断呈现方式
/// @param animated 是否动画
/// @param completion 完成回调
- (void)dismissAnimated:(BOOL)animated completion:(void (^__nullable)(void))completion;

@property (nonatomic, assign, readonly) BOOL isDisplaying;             ///< 是否正在显示
@property (nonatomic, assign, readonly) BOOL isLastVCInNavController;  ///< 是否是导航控制器中最后一个
@end

NS_ASSUME_NONNULL_END
