//
//  UIScrollView+HDNavigationBar.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HDNavigationBar)

/// 是否禁用UIScrollView左滑返回手势处理，默认NO
@property (nonatomic, assign) BOOL hd_gestureHandleDisabled;

@end

NS_ASSUME_NONNULL_END
