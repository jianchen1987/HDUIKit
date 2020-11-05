//
//  UIBarButtonItem+HDNavigationBar.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/28.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "UIBarButtonItem+HDNavigationBar.h"

@implementation UIBarButtonItem (HDNavigationBar)

+ (instancetype)hd_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self hd_itemWithTitle:title image:nil target:target action:action];
}

+ (instancetype)hd_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [self hd_itemWithTitle:nil image:image target:target action:action];
}

+ (instancetype)hd_itemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action {
    return [self hd_itemWithTitle:title image:image highLightImage:nil target:target action:action];
}

+ (instancetype)hd_itemWithImage:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action {
    return [self hd_itemWithTitle:nil image:image highLightImage:highLightImage target:target action:action];
}

+ (instancetype)hd_itemWithTitle:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton new];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (highLightImage) {
        [button setImage:highLightImage forState:UIControlStateHighlighted];
    }
    
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsMake(11, 3, 11, 10);
    button.contentEdgeInsets = contentEdgeInsets;
    
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (button.bounds.size.width < 44.0f) {
        contentEdgeInsets.right = contentEdgeInsets.right + (44.0f - button.bounds.size.width);
        button.contentEdgeInsets = contentEdgeInsets;
        [button sizeToFit];
    }

    return [[self alloc] initWithCustomView:button];
}

@end
