//
//  HDPlaceholderView.h
//  HDUIKit
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "UIViewPlaceholderViewModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDPlaceholderView : UIView
@property (nonatomic, strong) UIViewPlaceholderViewModel *model;    ///< 模型
@property (nonatomic, copy) void (^tappedRefreshBtnHandler)(void);  ///< 按钮回调

@end

NS_ASSUME_NONNULL_END
