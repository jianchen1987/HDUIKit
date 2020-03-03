//
//  UIButton+EventInterval.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/19.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "UIButton+EventInterval.h"
#import <objc/runtime.h>

// 默认时间间隔
static NSTimeInterval const kDefaultEventTimeInterval = 1;
// 白名单
static NSArray<NSString *> *_whiteListClasses = nil;

@interface UIButton ()
/** bool YES 忽略点击事件 NO 允许点击事件 */
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end

@implementation UIButton (EventInterval)

+ (void)load {
    // Method Swizzling
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(hd_sendAction:to:forEvent:);
        Method methodA = class_getInstanceMethod(self, selA);
        Method methodB = class_getInstanceMethod(self, selB);

        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));

        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        } else {
            // 添加失败了 说明本类中有methodB的实现，此时只需要将methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(methodA, methodB);
        }
    });

    // 设置黑名单，忽略自定义键盘
    [UIButton setEventIntervalWhiteListClasses:@[@"HDKeyBoardButton", @"HDTabBarButton"]];
}

#pragma mark - private methods
- (void)hd_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {

    BOOL isInWhiteList = false;
    for (NSString *cls in _whiteListClasses) {
        if ([self isKindOfClass:NSClassFromString(cls)]) {
            isInWhiteList = true;
            break;
        }
    }
    if (isInWhiteList) {
        [self hd_sendAction:action to:target forEvent:event];
        return;
    }

    self.eventTimeInterval = self.eventTimeInterval == 0 ? kDefaultEventTimeInterval : self.eventTimeInterval;
    if (self.isIgnoreEvent) {
        return;
    } else if (self.eventTimeInterval > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.eventTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isIgnoreEvent = false;
        });
    }

    self.isIgnoreEvent = true;
    [self hd_sendAction:action to:target forEvent:event];
}

#pragma mark - public methods
+ (void)setEventIntervalWhiteListClasses:(NSArray<Class> *)classes {
    _whiteListClasses = [classes copy];
}

#pragma mark - getters and setters
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreEvent {
    id value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        return [value boolValue];
    }
    return false;
}

- (NSTimeInterval)eventTimeInterval {
    id value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        if ([value respondsToSelector:@selector(doubleValue)]) {
            return [value doubleValue];
        }
        return kDefaultEventTimeInterval;
    }
    return kDefaultEventTimeInterval;
}

- (void)setEventTimeInterval:(NSTimeInterval)eventTimeInterval {
    objc_setAssociatedObject(self, @selector(eventTimeInterval), @(eventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
