//
//  UIBarButtonItem+HDNavigationBar.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/28.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (HDNavigationBar)

+ (instancetype)hd_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)hd_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

+ (instancetype)hd_itemWithTitle:(nullable NSString *)title image:(nullable UIImage *)image target:(id)target action:(SEL)action;

+ (instancetype)hd_itemWithImage:(nullable UIImage *)image highLightImage:(nullable UIImage *)highLightImage target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
