//
//  UIView+KeyboardMoveRespond.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "UIView+KeyboardMoveRespond.h"
#import <HDKitCore/HDAssociatedObjectHelper.h>
#import <HDKitCore/HDDispatchMainQueueSafe.h>
#import <HDKitCore/UIView+HD_Extension.h>
#import <HDKitCore/UIViewController+HDKitCore.h>

@interface UIView ()
@property (nonatomic, assign) BOOL isHd_enableUpSpring;                     ///< 是否开启跟随键盘向上弹起
@property (nonatomic, assign) CGFloat hd_marginForSelfBottomToKeyBoardTop;  ///< 底部和键盘顶部间距
@property (nonatomic, assign) CGFloat hd_distance;                          ///< 移动距离
@property (nonatomic, strong) UIView *hd_maxTopRefrenceView;                ///< 最大到其底部的参考 view
@property (nonatomic, assign) BOOL hd_judgeCover;                           ///< 判断是否覆盖决定移动
@property (nonatomic, assign) CGFloat hd_distanceToRefViewBottom;           ///< 距离参考控件的底部距离
@end

@implementation UIView (KeyboardMoveRespond)
- (void)hd_dealloc {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (!self.isHd_enableUpSpring) {
        [self performSelector:NSSelectorFromString(@"hd_dealloc")];
        return;
    };

    // 移除监听键盘
    if ([self respondsToSelector:@selector(isHd_enableUpSpring)] && [self isHd_enableUpSpring]) {
        HDLog(@"%@ 移除了键盘监听", NSStringFromClass(self.class));
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [self performSelector:NSSelectorFromString(@"hd_dealloc")];
    }

#pragma clang diagnostic pop
}

#pragma mark - public methods
- (void)setFollowKeyBoardConfigEnable:(BOOL)enable margin:(CGFloat)margin refView:(UIView *__nullable)refView distanceToRefViewBottom:(CGFloat)distanceToRefViewBottom {
    [self setFollowKeyBoardConfigEnable:enable margin:margin refView:refView];
    self.hd_distanceToRefViewBottom = distanceToRefViewBottom;
}

- (void)setFollowKeyBoardConfigEnable:(BOOL)enable margin:(CGFloat)margin refView:(UIView *__nullable)refView {
    self.hd_judgeCover = YES;
    self.isHd_enableUpSpring = enable;
    self.hd_marginForSelfBottomToKeyBoardTop = margin;
    self.hd_maxTopRefrenceView = refView;
    self.hd_distanceToRefViewBottom = 10;
}

- (void)setFollowKeyBoardConfigEnable:(BOOL)enable distance:(CGFloat)distance {
    self.hd_judgeCover = NO;
    self.isHd_enableUpSpring = enable;
    self.hd_distance = distance;
}

#pragma mark - event response
/**
 *  监听键盘弹出，改变View的frame
 */
- (void)hd_keyboardWillChangeFrame:(NSNotification *)notification {

    if (!self.isHd_enableUpSpring) return;

    // 取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 取得键盘最后和开始的frame
    CGFloat originEndY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;

    // 先清空 transform，解决切换键盘产生的错误位移
    self.transform = CGAffineTransformIdentity;

    CGFloat endY = originEndY - self.hd_marginForSelfBottomToKeyBoardTop;

    // 转换坐标系得到当前view相对于整个屏幕的坐标
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect selfFrameToKeywindow = [self convertRect:self.bounds toView:keyWindow];

    CGFloat minus = selfFrameToKeywindow.origin.y + selfFrameToKeywindow.size.height - endY;

    if (self.hd_maxTopRefrenceView) {
        // 转换参考 view 的坐标
        CGRect refViewFrame = [self.hd_maxTopRefrenceView convertRect:self.hd_maxTopRefrenceView.bounds toView:keyWindow];

        // 判断是否高出参考 view，最大只能到 参考 view 的底部
        CGFloat refViewBottom = refViewFrame.origin.y + refViewFrame.size.height + self.hd_distanceToRefViewBottom;
        if (selfFrameToKeywindow.origin.y - minus < refViewBottom) {
            minus = selfFrameToKeywindow.origin.y - refViewBottom;
        }
    }

    BOOL isVCActive = self.viewController.hd_isViewLoadedAndVisible && (!self.viewController.navigationController || self.viewController.isLastVCInNavController);
    if (isVCActive && minus > 0) {  // 遮住了当前输入框
        hd_dispatch_main_async_safe(^{
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.transform = CGAffineTransformMakeTranslation(0, -minus);
                             }];
        });
    }

    if (originEndY == [UIScreen mainScreen].bounds.size.height) {  // 键盘下降
        hd_dispatch_main_async_safe(^{
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.transform = CGAffineTransformIdentity;
                             }];
        });
    }
}

/**
 *  监听键盘弹出，改变View的frame
 */
- (void)hd_keyboardWillChangeFrameNoJudge:(NSNotification *)notification {

    // 取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 取得键盘最后和开始的frame
    CGFloat originEndY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;

    CGFloat minus = self.hd_distance;

    BOOL isVCActive = self.viewController.hd_isViewLoadedAndVisible && (!self.viewController.navigationController || self.viewController.isLastVCInNavController);
    if (isVCActive && minus > 0) {  // 遮住了当前输入框
        hd_dispatch_main_async_safe(^{
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.transform = CGAffineTransformMakeTranslation(0, -minus);
                             }];
        });
    }

    if (originEndY == [UIScreen mainScreen].bounds.size.height) {  // 键盘下降
        hd_dispatch_main_async_safe(^{
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.transform = CGAffineTransformIdentity;
                             }];
        });
    }
}

#pragma mark - getters and setters
- (void)setIsHd_enableUpSpring:(BOOL)isHd_enableUpSpring {
    if (isHd_enableUpSpring) {
        if (self.hd_judgeCover) {
            // 监听键盘
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hd_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        } else {
            // 监听键盘
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hd_keyboardWillChangeFrameNoJudge:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
// 交换 dealloc 方法，销毁通知监听
// [self swizzleInstanceMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(hd_dealloc)];
#pragma clang diagnostic pop
    }

    [self willChangeValueForKey:@"isHd_enableUpSpring"];
    objc_setAssociatedObject(self, @selector(isHd_enableUpSpring), @(isHd_enableUpSpring), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"isHd_enableUpSpring"];
}

- (BOOL)isHd_enableUpSpring {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

HDSynthesizeCGFloatProperty(hd_marginForSelfBottomToKeyBoardTop, setHd_marginForSelfBottomToKeyBoardTop);
HDSynthesizeCGFloatProperty(hd_distance, setHd_distance);
HDSynthesizeCGFloatProperty(hd_distanceToRefViewBottom, setHd_distanceToRefViewBottom);
HDSynthesizeBOOLProperty(hd_judgeCover, setHd_judgeCover);
HDSynthesizeIdWeakProperty(hd_maxTopRefrenceView, setHd_maxTopRefrenceView);

@end
