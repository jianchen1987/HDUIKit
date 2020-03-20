//
//  UIViewController+WJKeyBoard.m
//  ViPay
//
//  Created by VanJay on 2019/11/6.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAssociatedObjectHelper.h"
#import "NSObject+HD_Swizzle.h"
#import "UIViewController+WJKeyBoard.h"

@implementation UIViewController (WJKeyBoard)

- (void)wj_addKeyBoardHandle {
    [self hd_swizzleInstanceMethod:@selector(viewWillAppear:) withMethod:@selector(wj_viewWillAppear:)];
    [self hd_swizzleInstanceMethod:@selector(viewWillDisappear:) withMethod:@selector(wj_viewWillDisappear:)];
}

- (void)wj_viewWillAppear:(BOOL)animated {
    [self wj_viewWillAppear:animated];
    [self addKeyboardObserver];
}

- (void)wj_viewWillDisappear:(BOOL)animated {
    [self wj_viewWillDisappear:animated];
    [self removeKeyboardObserver];
}

#pragma mark

- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

#pragma mark - deal

- (void)setProperty {
    UIView *currentEditView;
    if (self.wj_currentEditView) {
        currentEditView = self.wj_currentEditView;
    } else {
        currentEditView = [self getCurrentEditView];
    }
    self.wj_currentEditViewBottom = [self getCurrentEditViewBottom:currentEditView];

    if (!self.wj_needScrollView) {
        self.wj_needScrollView = self.view;
    }
}

- (UIView *)getCurrentEditView {
    return [self findCurrentEditView:self.view];
}

- (UIView *)findCurrentEditView:(UIView *)view {
    for (UIView *childView in view.subviews) {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder]) {
            return childView;
        }
        UIView *result = [self findCurrentEditView:childView];
        if (result) {
            return result;
        }
    }
    return nil;
}

- (CGFloat)getCurrentEditViewBottom:(UIView *)view {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [view convertRect:view.bounds toView:window].origin.y + view.frame.size.height;
}

#pragma mark - notification

- (BOOL)keyboardWillShow:(NSNotification *)noti {
    [self setProperty];

    CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardBounds = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // 键盘是否挡住输入框，h<0则挡住了
    CGFloat h = keyboardBounds.origin.y - self.wj_currentEditViewBottom;
    if (h < 0) {
        [self handleMoveDistance:h animateWithDuration:animationDuration];
    }
    return YES;
}

- (BOOL)keyboardWillHide:(NSNotification *)noti {
    CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self handleMoveDistance:(-self.wj_moveDistance) animateWithDuration:animationDuration];

    return YES;
}

- (BOOL)keyboardFrameWillChange:(NSNotification *)noti {
    if (self.wj_moveDistance == 0) {
        return NO;
    }

    CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardBounds = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // 键盘是否挡住输入框，h<0则挡住了
    CGFloat h = keyboardBounds.origin.y - (self.wj_currentEditViewBottom + self.wj_moveDistance);
    if (h < 0) {
        [self handleMoveDistance:h animateWithDuration:animationDuration];
    }

    return YES;
}

#pragma mark - handle

- (void)handleMoveDistance:(CGFloat)distance animateWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self moveNeedScrollViewDistance:distance];
                         self.wj_moveDistance += distance;
                     }
                     completion:^(BOOL finished){

                     }];
}

- (void)moveNeedScrollViewDistance:(CGFloat)distance {
    self.wj_needScrollView.frame = CGRectMake(self.wj_needScrollView.frame.origin.x, self.wj_needScrollView.frame.origin.y + distance, self.wj_needScrollView.frame.size.width, self.wj_needScrollView.frame.size.height);
}

#pragma mark - runtime getter && setter
HDSynthesizeCGFloatProperty(wj_moveDistance, setWj_moveDistance);
HDSynthesizeCGFloatProperty(wj_currentEditViewBottom, setWj_currentEditViewBottom);
HDSynthesizeIdWeakProperty(wj_needScrollView, setWj_needScrollView);
HDSynthesizeIdWeakProperty(wj_currentEditView, setWj_currentEditView);
@end
