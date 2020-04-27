//
//  HDKeyboardManager+Helper.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDKeyboardManagerDefines.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HD_Keyboard_Hierarchy)
@property (nullable, nonatomic, readonly, strong) UIViewController *viewContainingController;

/// 如果 self 是 UISearchBarTextField 类型则返回其 searchBar，否则返回 nil
@property (nullable, nonatomic, readonly) UISearchBar *textFieldSearchBar;
@end

@interface UIView (HD_Keyboard_Additions)
@property (nonatomic, assign) HDKMEnableMode shouldResignOnTouchOutsideMode;
@end

NS_ASSUME_NONNULL_END
