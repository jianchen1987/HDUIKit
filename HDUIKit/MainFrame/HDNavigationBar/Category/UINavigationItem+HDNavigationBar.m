//
//  UINavigationItem+HDNavigationBar.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/29.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarConfigure.h"
#import "UINavigationItem+HDNavigationBar.h"

@implementation UINavigationItem (HDNavigationBar)

// iOS 11之前，通过添加空UIBarButtonItem调整间距
+ (void)load {
    if (@available(iOS 11.0, *)) {
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray<NSString *> *oriSels = @[@"setLeftBarButtonItem:",
                                             @"setLeftBarButtonItem:animated:",
                                             @"setLeftBarButtonItems:",
                                             @"setLeftBarButtonItems:animated:",
                                             @"setRightBarButtonItem:",
                                             @"setRightBarButtonItem:animated:",
                                             @"setRightBarButtonItems:",
                                             @"setRightBarButtonItems:animated:"];

            [oriSels enumerateObjectsUsingBlock:^(NSString *_Nonnull oriSel, NSUInteger idx, BOOL *_Nonnull stop) {
                hd_swizzled_instanceMethod(self, oriSel, self);
            }];
        });
    }
}

- (void)hd_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    [self setLeftBarButtonItem:leftBarButtonItem animated:NO];
}

- (void)hd_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated {
    if (!HDNavConfigure.hd_disableFixSpace && leftBarButtonItem) {  //存在按钮且需要调节
        [self setLeftBarButtonItems:@[leftBarButtonItem] animated:animated];
    } else {  // 不存在按钮,或者不需要调节
        [self setLeftBarButtonItems:nil];
        [self hd_setLeftBarButtonItem:leftBarButtonItem animated:animated];
    }
}

- (void)hd_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    [self setLeftBarButtonItems:leftBarButtonItems animated:NO];
}

- (void)hd_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems animated:(BOOL)animated {
    if (!HDNavConfigure.hd_disableFixSpace && leftBarButtonItems.count) {  //存在按钮且需要调节
        UIBarButtonItem *firstItem = leftBarButtonItems.firstObject;
        CGFloat width = HDNavConfigure.hd_navItemLeftSpace - HDNavConfigure.hd_fixedSpace;
        if (firstItem.width == width) {  //已经存在space
            [self hd_setLeftBarButtonItems:leftBarButtonItems animated:animated];
        } else {
            NSMutableArray *items = [NSMutableArray arrayWithArray:leftBarButtonItems];
            [items insertObject:[self fixedSpaceWithWidth:width] atIndex:0];
            [self hd_setLeftBarButtonItems:items animated:animated];
        }
    } else {  //不存在按钮,或者不需要调节
        [self hd_setLeftBarButtonItems:leftBarButtonItems animated:animated];
    }
}

- (void)hd_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    [self setRightBarButtonItem:rightBarButtonItem animated:NO];
}

- (void)hd_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated {
    if (!HDNavConfigure.hd_disableFixSpace && rightBarButtonItem) {  //存在按钮且需要调节
        [self setRightBarButtonItems:@[rightBarButtonItem] animated:animated];
    } else {  //不存在按钮,或者不需要调节
        [self setRightBarButtonItems:nil];
        [self hd_setRightBarButtonItem:rightBarButtonItem animated:animated];
    }
}

- (void)hd_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems {
    [self setRightBarButtonItems:rightBarButtonItems animated:NO];
}

- (void)hd_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems animated:(BOOL)animated {
    if (!HDNavConfigure.hd_disableFixSpace && rightBarButtonItems.count) {  //存在按钮且需要调节
        UIBarButtonItem *firstItem = rightBarButtonItems.firstObject;
        CGFloat width = HDNavConfigure.hd_navItemRightSpace - HDNavConfigure.hd_fixedSpace;
        if (firstItem.width == width) {  //已经存在space
            [self hd_setRightBarButtonItems:rightBarButtonItems animated:animated];
        } else {
            NSMutableArray *items = [NSMutableArray arrayWithArray:rightBarButtonItems];
            [items insertObject:[self fixedSpaceWithWidth:width] atIndex:0];
            [self hd_setRightBarButtonItems:items animated:animated];
        }
    } else {  //不存在按钮,或者不需要调节
        [self hd_setRightBarButtonItems:rightBarButtonItems animated:animated];
    }
}

- (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end

@implementation NSObject (HDNavigationBar)

// iOS11之后，通过修改约束跳转导航栏item的间距
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            NSDictionary *oriSels = @{@"_UINavigationBarContentView": @"layoutSubviews",
                                      @"_UINavigationBarContentViewLayout": @"_updateMarginConstraints"};
            [oriSels enumerateKeysAndObjectsUsingBlock:^(NSString *cls, NSString *oriSel, BOOL *_Nonnull stop) {
                hd_swizzled_instanceMethod(NSClassFromString(cls), oriSel, self);
            }];
        }
    });
}

- (void)hd_layoutSubviews {
    [self hd_layoutSubviews];
    if (HDNavConfigure.hd_disableFixSpace) return;
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationBarContentView")]) return;
    id layout = [self valueForKey:@"_layout"];
    if (!layout) return;
    SEL selector = NSSelectorFromString(@"_updateMarginConstraints");
    IMP imp = [layout methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(layout, selector);
}

- (void)hd__updateMarginConstraints {
    [self hd__updateMarginConstraints];
    if (HDNavConfigure.hd_disableFixSpace) return;
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationBarContentViewLayout")]) return;
    [self hd_adjustLeadingBarConstraints];
    [self hd_adjustTrailingBarConstraints];
}

- (void)hd_adjustLeadingBarConstraints {
    if (HDNavConfigure.hd_disableFixSpace) return;
    NSArray<NSLayoutConstraint *> *leadingBarConstraints = [self valueForKey:@"_leadingBarConstraints"];
    if (!leadingBarConstraints) return;
    CGFloat constant = HDNavConfigure.hd_navItemLeftSpace - HDNavConfigure.hd_fixedSpace;
    for (NSLayoutConstraint *constraint in leadingBarConstraints) {
        if (constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondAttribute == NSLayoutAttributeLeading) {
            constraint.constant = constant;
        }
    }
}

- (void)hd_adjustTrailingBarConstraints {
    if (HDNavConfigure.hd_disableFixSpace) return;
    NSArray<NSLayoutConstraint *> *trailingBarConstraints = [self valueForKey:@"_trailingBarConstraints"];
    if (!trailingBarConstraints) return;
    CGFloat constant = HDNavConfigure.hd_fixedSpace - HDNavConfigure.hd_navItemRightSpace;
    for (NSLayoutConstraint *constraint in trailingBarConstraints) {
        if (constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            constraint.constant = constant;
        }
    }
}

@end
