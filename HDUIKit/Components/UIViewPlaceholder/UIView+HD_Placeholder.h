//
//  UIView+HD_Placeholder.h
//  HDUIKit
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIViewPlaceholderViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HD_Placeholder)

/**
 添加占位显示文字和图片

 @param model 占位配置模型，nil 将使用默认值
 */
- (void)hd_showPlaceholderViewWithModel:(UIViewPlaceholderViewModel *_Nullable)model;

/**
 移除占位显示文字和图片
 */
- (void)hd_removePlaceholderView;

@property (nonatomic, copy) void (^hd_tappedRefreshBtnHandler)(void);  ///< 按钮回调

@end

NS_ASSUME_NONNULL_END
