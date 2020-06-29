//
//  HDActionAlertView.m
//  HDUIKit
//
//  Created by VanJay on 2019/7/31.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"
#import "HDActionAlertViewController.h"
#import "HDDispatchMainQueueSafe.h"

@class HDActionAlertViewBackgroundWindow;

const UIWindowLevel HDActionAlertViewWindowLevel = 1986.0;            // 不要与系统 alert 重叠
const UIWindowLevel HDActionAlertViewBackgroundWindowLevel = 1985.0;  // 在 alert 窗口下方

static BOOL __hd_animating;
static NSMutableDictionary<NSString *, NSMutableArray<HDActionAlertView *> *> *__sharedQueueCache;
static HDActionAlertViewBackgroundWindow *__hd_background_window;
static HDActionAlertView *__hd_current_view;

#pragma mark - HDActionAlertViewBackgroundWindow 声明一个Window
@interface HDActionAlertViewBackgroundWindow : UIWindow
@property (nonatomic, assign) HDActionAlertViewBackgroundStyle style;
/// 实心填充背景色颜色透明度，默认 0.6
@property (nonatomic, assign) CGFloat solidBackgroundColorAlpha;
@end

@implementation HDActionAlertViewBackgroundWindow

#pragma mark - init
- (id)initWithFrame:(CGRect)frame andStyle:(HDActionAlertViewBackgroundStyle)style solidBackgroundColorAlpha:(CGFloat)solidBackgroundColorAlpha {
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = HDActionAlertViewBackgroundWindowLevel;
        self.solidBackgroundColorAlpha = solidBackgroundColorAlpha;
    }
    return self;
}

- (void)becomeKeyWindow {
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case HDActionAlertViewBackgroundStyleGradient: {  // 渐变效果
            [[UIColor colorWithWhite:0 alpha:0.5] set];   // 背景透明度
            CGContextFillRect(context, self.bounds);
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height);
            CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);

            break;
        }
        case HDActionAlertViewBackgroundStyleSolid: {
            [[UIColor.blackColor colorWithAlphaComponent:self.solidBackgroundColorAlpha] set];  // 背景透明度
            CGContextFillRect(context, self.bounds);
            break;
        }
    }
}
@end

@interface HDActionAlertWindow : UIWindow
/// 是否可以成为 keyWindow，默认为 false
@property (nonatomic, assign) BOOL canBecomeKeyWindow;
/// 弹窗
@property (nonatomic, weak) HDActionAlertView *alertView;
/// 背景是否禁用事件（containerView 仍然响应），比如 TopToast 弹窗，背景就不该拦截事件，但本身仍需上滑 dismiss 操作
@property (nonatomic, assign) BOOL ignoreBackgroundTouchEvent;
@end

@implementation HDActionAlertWindow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = HDActionAlertViewWindowLevel;
    }
    return self;
}

- (void)becomeKeyWindow {
    if (self.canBecomeKeyWindow) {
        [super becomeKeyWindow];
    } else {
        UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
        [appWindow makeKeyWindow];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.ignoreBackgroundTouchEvent) return [super pointInside:point withEvent:event];

    if (!self.alertView) return [super pointInside:point withEvent:event];

    if (CGRectContainsPoint(self.alertView.containerView.frame, point)) return true;

    return false;
}

@end

#pragma mark - HDActionAlertView

static NSString *const kHDAlertActionViewTransitionAnimationCompletionKey = @"kHDAlertActionViewTransitionAnimationCompletionKey";

@interface HDActionAlertView () <CAAnimationDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) HDActionAlertWindow *alertWindow;
@property (nonatomic, assign, getter=isLayoutDirty) BOOL layoutDirty;
@property (nonatomic, strong) UIView *customView;
@end

@implementation HDActionAlertView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.solidBackgroundColorAlpha = 0.6;
    }
    return self;
}

+ (instancetype)actionAlertViewWithCustomView:(UIView *)customView style:(HDActionAlertViewTransitionStyle)style {
    return [[self alloc] initWithCustomView:customView style:style];
}

- (instancetype)initWithCustomView:(UIView *)customView style:(HDActionAlertViewTransitionStyle)style {
    if (self = [super init]) {
        _customView = customView;
        [self addSubview:_customView];
        self.transitionStyle = style;
        _allowTapBackgroundDismiss = NO;
    }
    return self;
}

+ (instancetype)actionAlertViewWithAnimationStyle:(HDActionAlertViewTransitionStyle)style {
    return [[self alloc] initWithAnimationStyle:style];
}

- (instancetype)initWithAnimationStyle:(HDActionAlertViewTransitionStyle)style {
    if (self = [super init]) {
        self.transitionStyle = style;
        _allowTapBackgroundDismiss = NO;
    }
    return self;
}

#pragma mark - Class methods
+ (NSString *)sharedMapQueueKey {
    // 默认以类名作为映射的 key，也就w意味着不同种继承于此的弹窗默认是可以同时显示的，如果需设置它们不可同时显示，可在其实现种重写此方法返回同一字符串，达到将其置于同一队列的目的
    return NSStringFromClass(self.class);
}

+ (NSMutableDictionary<NSString *, NSMutableArray<HDActionAlertView *> *> *)sharedQueueCache {
    if (!__sharedQueueCache) {
        __sharedQueueCache = [[NSMutableDictionary alloc] init];
    }
    return __sharedQueueCache;
}

+ (NSInteger)totalQueueCount {
    __block NSInteger count = 0;

    [[self sharedQueueCache] enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSMutableArray<HDActionAlertView *> *_Nonnull obj, BOOL *_Nonnull stop) {
        count += obj.count;
    }];

    return count;
}

+ (NSString *)queueKey {
    return [self sharedMapQueueKey];
}

+ (NSMutableArray<HDActionAlertView *> *)sharedQueue {
    NSString *queueKey = self.queueKey;
    if (![self.sharedQueueCache objectForKey:queueKey]) {
        [self.sharedQueueCache setObject:[NSMutableArray array] forKey:queueKey];
    }
    return [self.sharedQueueCache objectForKey:queueKey];
}

+ (HDActionAlertView *)currentAlertView {
    return __hd_current_view;
}

+ (void)setCurrentAlertView:(HDActionAlertView *)alertView {
    __hd_current_view = alertView;
}

+ (BOOL)isAnimating {
    return __hd_animating;
}

+ (void)setAnimating:(BOOL)animating {
    __hd_animating = animating;
}

#pragma mark - show/hide background
+ (void)showBackground {

    if (!__hd_background_window) {

        CGRect frame = [[UIScreen mainScreen] bounds];
        if ([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)]) {
            frame = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:frame
                                                          fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
        }

        __hd_background_window = [[HDActionAlertViewBackgroundWindow alloc] initWithFrame:frame
                                                                                 andStyle:[HDActionAlertView currentAlertView].backgroundStyle
                                                                solidBackgroundColorAlpha:[HDActionAlertView currentAlertView].solidBackgroundColorAlpha];

        hd_dispatch_main_async_safe(^{
            [__hd_background_window makeKeyAndVisible];
            __hd_background_window.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 __hd_background_window.alpha = 1;
                             }];
        });
    }
}

+ (void)hideBackgroundAnimated:(BOOL)animated {
    hd_dispatch_main_async_safe(^{
        if (!animated) {
            [__hd_background_window removeFromSuperview];
            __hd_background_window = nil;
            return;
        }

        // 这里有个坑，因为如果背景是动画消失的话，可能在显示下一个 alert 之前 __hd_background_window 还存活着，所以这里要保证背景动画消失的时间要低于 alertView 的消失时间
        [UIView animateWithDuration:0.2
            animations:^{
                __hd_background_window.alpha = 0;
            }
            completion:^(BOOL finished) {
                [__hd_background_window removeFromSuperview];
                __hd_background_window = nil;
                [__sharedQueueCache removeAllObjects];
            }];
    });
}

#pragma mark - public methods

- (void)show {
    hd_dispatch_main_async_safe(^{
        [self _show];
    });
}

- (void)_show {
    if (self.isVisible) {
        return;
    }

    // if ([HDActionAlertView isAnimating]) {
    // return;
    // }

    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];

    // 同一个标志不添加
    BOOL isDestViewExist = false;
    for (HDActionAlertView *view in [self.class sharedQueue]) {
        if (self.identitableString.length > 0 && view.identitableString.length > 0) {
            if ([self.identitableString isEqualToString:view.identitableString]) {
                isDestViewExist = true;
            }
        }
    }

    if (![[self.class sharedQueue] containsObject:self] && !isDestViewExist) {
        [[self.class sharedQueue] addObject:self];
    }

    if ([[self.class sharedQueue] containsObject:self]) {
        for (HDActionAlertView *alertView in [self.class sharedQueue]) {
            if (alertView != self && [[alertView.class sharedMapQueueKey] isEqualToString:[self.class sharedMapQueueKey]] && alertView.isVisible) {
                [alertView dismissAnimated:false cleanup:NO completion:nil];
            }
        }
    } else {
        return;
    }

    if (self.willShowHandler) {
        self.willShowHandler(self);
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewWillShow:)]) {
        [self.delegate actionAlertViewWillShow:self];
    }

    self.visible = YES;

    [HDActionAlertView setAnimating:YES];
    [HDActionAlertView setCurrentAlertView:self];

    [HDActionAlertView showBackground];

    if (!self.alertWindow) {
        HDActionAlertViewController *viewController = [[HDActionAlertViewController alloc] init];
        viewController.alertView = self;

        HDActionAlertWindow *window = [[HDActionAlertWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.canBecomeKeyWindow = self.canBecomeKeyWindow;
        window.ignoreBackgroundTouchEvent = self.ignoreBackgroundTouchEvent;
        window.alertView = self;
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.rootViewController = viewController;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackgroundView)];
        recognizer.delegate = self;
        [window addGestureRecognizer:recognizer];
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];

    [self validateLayout];

    [self transitionInCompletion:^{
        if (self.didShowHandler) {
            self.didShowHandler(self);
        } else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidShow:)]) {
            [self.delegate actionAlertViewDidShow:self];
        }

        [HDActionAlertView setAnimating:NO];

        NSInteger index = [[self.class sharedQueue] indexOfObject:self];
        if (index < [self.class sharedQueue].count - 1) {
            [self dismissAnimated:false cleanup:NO completion:nil];  // 消失之后显示下一个 AlertView
        }
    }];
}

- (void)dismiss {
    hd_dispatch_main_async_safe(^{
        [self dismissCompletion:nil];
    });
}

- (void)dismissCompletion:(void (^__nullable)(void))completion {
    hd_dispatch_main_async_safe(^{
        [self dismissAnimated:true cleanup:YES completion:completion];
    });
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup completion:(void (^__nullable)(void))completion {
    BOOL isVisible = self.isVisible;

    if (isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(self);
        } else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewWillDismiss:)]) {
            [self.delegate actionAlertViewWillDismiss:self];
        }
    }

    // 执行 dismiss 动画结束之前就清除队列或缓存数据
    if (cleanup) {
        NSMutableArray<HDActionAlertView *> *queue = [self.class sharedQueue];
        [queue removeObject:self];

        if (queue.count <= 0) {
            NSString *queueKey = self.class.queueKey;
            [[self.class sharedQueueCache] removeObjectForKey:queueKey];
        }
    }

    void (^dismissComplete)(void) = ^{
        self.visible = NO;

        [self teardown];

        [HDActionAlertView setCurrentAlertView:nil];

        HDActionAlertView *nextAlertView;
        NSInteger index = [[self.class sharedQueue] indexOfObject:self];
        if (index != NSNotFound && index < [self.class sharedQueue].count - 1) {
            nextAlertView = [self.class sharedQueue][index + 1];
        }

        [HDActionAlertView setAnimating:NO];

        if (isVisible) {
            !completion ?: completion();

            if (self.didDismissHandler) {
                self.didDismissHandler(self);
            } else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidDismiss:)]) {
                [self.delegate actionAlertViewDidDismiss:self];
            }
        }

        // check if we should show next alert
        if (!isVisible) {
            return;
        }

        if (nextAlertView) {
            [nextAlertView show];
        } else {
            // show last alert view
            if ([self.class sharedQueue].count > 0) {
                HDActionAlertView *alert = [[self.class sharedQueue] lastObject];
                [alert show];
            }
        }
    };

    if (animated && isVisible) {
        [HDActionAlertView setAnimating:YES];
        [self transitionOutCompletion:dismissComplete];

        if ([self.class totalQueueCount] <= 0) {
            [HDActionAlertView hideBackgroundAnimated:YES];
        }

    } else {
        dismissComplete();

        if ([self.class totalQueueCount] <= 0) {
            [HDActionAlertView hideBackgroundAnimated:YES];
        }
    }

    UIWindow *window = self.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window makeKeyAndVisible];
    window.hidden = NO;
}

- (UIView *__nullable)getCustomView {
    return self.customView;
}

#pragma mark - Transitions
- (void)transitionInCompletion:(void (^)(void))completion {

    UIView *view = self.customView ?: self.containerView;

    switch (self.transitionStyle) {
        case HDActionAlertViewTransitionStyleSlideFromBottom: {
            CGRect rect = view.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            view.frame = rect;
            [UIView animateWithDuration:0.3
                animations:^{
                    view.frame = originalRect;
                }
                completion:^(BOOL finished) {
                    !completion ?: completion();
                }];
        } break;

        case HDActionAlertViewTransitionStyleSlideFromTop: {
            CGRect rect = view.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            view.frame = rect;
            [UIView animateWithDuration:0.3
                animations:^{
                    view.frame = originalRect;
                }
                completion:^(BOOL finished) {
                    !completion ?: completion();
                }];
        } break;

        case HDActionAlertViewTransitionStyleFade: {
            view.alpha = 0;
            [UIView animateWithDuration:0.3
                animations:^{
                    view.alpha = 1;
                }
                completion:^(BOOL finished) {
                    !completion ?: completion();
                }];
        } break;

        case HDActionAlertViewTransitionStyleBounce: {

            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:kHDAlertActionViewTransitionAnimationCompletionKey];
            [view.layer addAnimation:animation forKey:@"bouce"];
        } break;

        case HDActionAlertViewTransitionStyleDropDown: {

            CGFloat y = view.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:kHDAlertActionViewTransitionAnimationCompletionKey];
            [view.layer addAnimation:animation forKey:@"dropdown"];
        } break;

        default:
            break;
    }
}

- (void)transitionOutCompletion:(void (^)(void))completion {
    UIView *view = self.customView ?: self.containerView;

    switch (self.transitionStyle) {
        case HDActionAlertViewTransitionStyleSlideFromBottom: {
            CGRect rect = view.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                delay:0
                options:UIViewAnimationOptionCurveEaseIn
                animations:^{
                    view.frame = rect;
                }
                completion:^(BOOL finished) {
                    !completion ?: completion();
                }];
        } break;

        case HDActionAlertViewTransitionStyleSlideFromTop: {
            CGRect rect = view.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                delay:0
                options:UIViewAnimationOptionCurveEaseIn
                animations:^{
                    view.frame = rect;
                }
                completion:^(BOOL finished) {
                    !completion ?: completion();
                }];
        } break;

        case HDActionAlertViewTransitionStyleFade: {
            [UIView animateWithDuration:0.25
                animations:^{
                    view.alpha = 0;
                }
                completion:^(BOOL finished) {
                    !completion ?: completion();
                }];
        } break;

        case HDActionAlertViewTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:kHDAlertActionViewTransitionAnimationCompletionKey];
            [view.layer addAnimation:animation forKey:@"bounce"];

            view.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } break;

        case HDActionAlertViewTransitionStyleDropDown: {
            CGPoint point = view.center;
            point.y += self.bounds.size.height;

            [UIView animateWithDuration:0.3
                delay:0
                options:UIViewAnimationOptionCurveEaseIn
                animations:^{
                    view.center = point;
                    CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                    view.transform = CGAffineTransformMakeRotation(angle);
                }
                completion:^(BOOL finished) {
                    !completion ?: completion();
                }];
        } break;

        default:
            break;
    }
}

- (void)resetTransition {
    UIView *view = self.customView ?: self.containerView;

    [view.layer removeAllAnimations];
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invalidateLayout {
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout {
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;

    if (_customView) {
        self.bounds = _customView.bounds;
        return;
    }

    self.containerView.transform = CGAffineTransformIdentity;
    [self layoutContainerView];
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;

    [self layoutContainerViewSubViews];
}

#pragma mark - Setup

- (void)setup {
    if (!_customView) {
        [self setupContainerView];

        [self setupContainerSubViews];

        [self invalidateLayout];
    }
}

- (void)teardown {
    [self.containerView removeFromSuperview];
    self.containerView = nil;

    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    self.layoutDirty = NO;
}

#pragma mark - HDActionAlertViewOverridable
- (void)setupContainerSubViews {
    // 设置容器视图
}

- (void)layoutContainerViewSubViews {
    // 布局容器子视图
}

- (void)setupContainerViewAttributes {
    // 给容器视图加属性
}

- (void)layoutContainerView {
    // 布局容器视图
    self.containerView.frame = CGRectMake(0, 0, 0, 0);
}

- (void)setupContainerView {

    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.clipsToBounds = YES;
    [self addSubview:self.containerView];

    [self setupContainerViewAttributes];
}

#pragma mark - event response
// 点击背景
- (void)tappedBackgroundView {

    if (self.didTappedBackgroundHandler) {
        self.didTappedBackgroundHandler(self);
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidTappedBackGroundView:)]) {
        [self.delegate actionAlertViewDidTappedBackGroundView:self];
    }

    if (_allowTapBackgroundDismiss) {
        [self dismissCompletion:nil];
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void (^completion)(void) = [anim valueForKey:kHDAlertActionViewTransitionAnimationCompletionKey];
    !completion ?: completion();
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (CGRectContainsPoint(self.containerView.frame, [touch locationInView:self.alertWindow])) {
        return false;
    }
    return true;
}
@end
