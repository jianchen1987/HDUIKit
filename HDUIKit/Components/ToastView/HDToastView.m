//
//  HDToastView.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDToastView.h"
#import "HDCommonDefines.h"
#import "HDToastAnimator.h"
#import "HDToastBackgroundView.h"
#import "HDToastContentView.h"
#import "UIView+HDKitCore.h"

static NSMutableArray<HDToastView *> *kToastViews = nil;

@interface HDToastView ()

@property (nonatomic, weak) NSTimer *hideDelayTimer;

@end

@implementation HDToastView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"请使用initWithView:初始化");
    return [self initWithView:[[UIView alloc] init]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(NO, @"请使用initWithView:初始化");
    return [self initWithView:[[UIView alloc] init]];
}

- (nonnull instancetype)initWithView:(nonnull UIView *)view {
    NSAssert(view, @"view不能为空");
    if (self = [super initWithFrame:view.bounds]) {
        _parentView = view;
        [self didInitialize];
    }
    return self;
}

- (void)dealloc {
    [self removeNotifications];
    if ([kToastViews containsObject:self]) {
        [kToastViews removeObject:self];
    }
}

- (void)didInitialize {

    self.tintColor = UIColor.whiteColor;

    self.toastPosition = HDToastViewPositionCenter;

    // 顺序不能乱，先添加backgroundView再添加contentView
    self.backgroundView = [self defaultBackgrondView];
    self.contentView = [self defaultContentView];

    self.opaque = NO;
    self.alpha = 0.0;
    self.backgroundColor = UIColor.clearColor;
    self.layer.allowsGroupOpacity = NO;

    _maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.maskView];

    [self registerNotifications];
}

- (void)didMoveToSuperview {
    if (!kToastViews) {
        kToastViews = [[NSMutableArray alloc] init];
    }
    if (self.superview) {
        // show
        if (![kToastViews containsObject:self]) {
            [kToastViews addObject:self];
        }
    } else {
        // hide
        if ([kToastViews containsObject:self]) {
            [kToastViews removeObject:self];
        }
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    _parentView = nil;
}

- (HDToastAnimator *)defaultAnimator {
    HDToastAnimator *toastAnimator = [[HDToastAnimator alloc] initWithToastView:self];
    return toastAnimator;
}

- (UIView *)defaultBackgrondView {
    HDToastBackgroundView *backgroundView = [[HDToastBackgroundView alloc] init];
    return backgroundView;
}

- (UIView *)defaultContentView {
    HDToastContentView *contentView = [[HDToastContentView alloc] init];
    return contentView;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
    _backgroundView = backgroundView;
    self.backgroundView.alpha = 0.0;
    [self addSubview:self.backgroundView];
    [self setNeedsLayout];
}

- (void)setContentView:(UIView *)contentView {
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        _contentView = nil;
    }
    _contentView = contentView;
    self.contentView.alpha = 0.0;
    [self addSubview:self.contentView];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.frame = self.parentView.bounds;
    self.maskView.frame = self.bounds;

    CGFloat contentWidth = CGRectGetWidth(self.parentView.bounds);
    CGFloat contentHeight = CGRectGetHeight(self.parentView.bounds);

    UIEdgeInsets marginInsets = UIEdgeInsetsConcat(self.marginInsets, self.parentView.hd_safeAreaInsets);

    CGFloat limitWidth = contentWidth - UIEdgeInsetsGetHorizontalValue(marginInsets);
    CGFloat limitHeight = contentHeight - UIEdgeInsetsGetVerticalValue(marginInsets);

    if (self.contentView) {
        CGSize contentViewSize = [self.contentView sizeThatFits:CGSizeMake(limitWidth, limitHeight)];
        contentViewSize.width = MIN(contentViewSize.width, limitWidth);
        contentViewSize.height = MIN(contentViewSize.height, limitHeight);
        CGFloat contentViewX = MAX(marginInsets.left, (contentWidth - contentViewSize.width) / 2) + self.offset.x;
        CGFloat contentViewY = MAX(marginInsets.top, (contentHeight - contentViewSize.height) / 2) + self.offset.y;

        if (self.toastPosition == HDToastViewPositionTop) {
            contentViewY = marginInsets.top + self.offset.y;
        } else if (self.toastPosition == HDToastViewPositionBottom) {
            contentViewY = contentHeight - contentViewSize.height - marginInsets.bottom + self.offset.y;
        }

        CGRect contentRect = CGRectFlatMake(contentViewX, contentViewY, contentViewSize.width, contentViewSize.height);
        self.contentView.hd_frameApplyTransform = contentRect;
    }
    if (self.backgroundView) {
        // backgroundView的frame跟contentView一样，contentView里面的subviews如果需要在视觉上跟backgroundView有个padding，那么就自己在自定义的contentView里面做。
        self.backgroundView.frame = self.contentView.frame;
    }
}

#pragma mark - 横竖屏

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    if (!self.parentView) {
        return;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Show and Hide

- (void)showAnimated:(BOOL)animated {

    // show之前需要layout以下，防止同一个tip切换不同的状态导致layout没更新
    [self setNeedsLayout];

    [self.hideDelayTimer invalidate];
    self.alpha = 1.0;

    if (self.willShowBlock) {
        self.willShowBlock(self.parentView, animated);
    }

    if (animated) {
        __weak __typeof(self) weakSelf = self;
        [self.toastAnimator showWithCompletion:^(BOOL finished) {
            if (weakSelf.didShowBlock) {
                weakSelf.didShowBlock(weakSelf.parentView, animated);
            }
        }];
    } else {
        self.backgroundView.alpha = 1.0;
        self.contentView.alpha = 1.0;
        if (self.didShowBlock) {
            self.didShowBlock(self.parentView, animated);
        }
    }
}

- (void)hideAnimated:(BOOL)animated {
    if (self.willHideBlock) {
        self.willHideBlock(self.parentView, animated);
    }
    if (animated) {
        __weak __typeof(self) weakSelf = self;
        [self.toastAnimator hideWithCompletion:^(BOOL finished) {
            [weakSelf didHideWithAnimated:animated];
        }];
    } else {
        self.backgroundView.alpha = 0.0;
        self.contentView.alpha = 0.0;
        [self didHideWithAnimated:animated];
    }
}

- (void)didHideWithAnimated:(BOOL)animated {

    if (self.didHideBlock) {
        self.didHideBlock(self.parentView, animated);
    }

    [self.hideDelayTimer invalidate];

    self.alpha = 0.0;
    if (self.removeFromSuperViewWhenHide) {
        [self removeFromSuperview];
    }
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    NSTimer *timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(handleHideTimer:) userInfo:@(animated) repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.hideDelayTimer = timer;
}

- (void)handleHideTimer:(NSTimer *)timer {
    [self hideAnimated:[timer.userInfo boolValue]];
}

#pragma mark - UIAppearance

- (void)setOffset:(CGPoint)offset {
    if (CGPointEqualToPoint(_offset, offset)) return;
    _offset = offset;
    [self setNeedsLayout];
}

- (void)setMarginInsets:(UIEdgeInsets)marginInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_marginInsets, marginInsets)) return;
    _marginInsets = marginInsets;
    [self setNeedsLayout];
}

#pragma mark - getters and setters
- (HDToastAnimator *)toastAnimator {
    if (!_toastAnimator) {
        _toastAnimator = [self defaultAnimator];
    }
    return _toastAnimator;
}
@end

@interface HDToastView (UIAppearance)

@end

@implementation HDToastView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    HDToastView *appearance = [HDToastView appearance];
    appearance.offset = CGPointZero;
    appearance.marginInsets = UIEdgeInsetsMake(10, 30, 45, 30);
}

@end

@implementation HDToastView (ToastTool)

+ (BOOL)hideAllToastInView:(UIView *)view animated:(BOOL)animated {
    NSArray *toastViews = [self allToastInView:view];
    BOOL result = NO;
    for (HDToastView *toastView in toastViews) {
        result = YES;
        toastView.removeFromSuperViewWhenHide = YES;
        [toastView hideAnimated:animated];
    }
    return result;
}

+ (nullable __kindof UIView *)toastInView:(UIView *)view {
    if (kToastViews.count <= 0) {
        return nil;
    }
    UIView *toastView = kToastViews.lastObject;
    if ([toastView isKindOfClass:self]) {
        return toastView;
    }
    return nil;
}

+ (nullable NSArray<HDToastView *> *)allToastInView:(UIView *)view {
    if (!view) {
        return kToastViews.count > 0 ? [kToastViews mutableCopy] : nil;
    }
    NSMutableArray *toastViews = [[NSMutableArray alloc] init];
    for (UIView *toastView in kToastViews) {
        if (toastView.superview == view && [toastView isKindOfClass:self]) {
            [toastViews addObject:toastView];
        }
    }
    return toastViews.count > 0 ? [toastViews mutableCopy] : nil;
}

@end
