//
//  UINavigationController+HDNavigationBar.m
//  HDUIKit
//
//  Created by VanJay on 2019/10/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDNavigationBarConfigure.h"
#import "HDNavigationBarTransitionDelegateHandler.h"
#import "UINavigationController+HDNavigationBar.h"
#import "UIViewController+HDNavigationBar.h"

@implementation UINavigationController (HDNavigationBar)

+ (instancetype)rootVC:(UIViewController *)rootVC {
    return [self rootVC:rootVC transitionScale:NO];
}

+ (instancetype)rootVC:(UIViewController *)rootVC transitionScale:(BOOL)transitionScale {
    return [[self alloc] initWithRootVC:rootVC transitionScale:transitionScale];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithRootVC:(UIViewController *)rootVC transitionScale:(BOOL)transitionScale {
    if (self = [super init]) {
        self.hd_openGestureHandle = YES;
        self.hd_transitionScale = transitionScale;
        [self pushViewController:rootVC animated:YES];
    }
    return self;
}
#pragma clang diagnostic pop

static char kAssociatedObjectKey_transitionScale;
- (void)setHd_transitionScale:(BOOL)hd_transitionScale {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_transitionScale, @(hd_transitionScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hd_transitionScale {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_transitionScale) boolValue];
}

static char kAssociatedObjectKey_openScrollLeftPush;
- (void)setHd_openScrollLeftPush:(BOOL)hd_openScrollLeftPush {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_openScrollLeftPush, @(hd_openScrollLeftPush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hd_openScrollLeftPush {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_openScrollLeftPush) boolValue];
}

static char kAssociatedObjectKey_openGestureHandle;
- (void)setHd_openGestureHandle:(BOOL)hd_openGestureHandle {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_openGestureHandle, @(hd_openGestureHandle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hd_openGestureHandle {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_openGestureHandle) boolValue];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hd_swizzled_instanceMethod(self, @"viewDidLoad", self);
    });
}

- (void)hd_viewDidLoad {

    if (self.hd_openGestureHandle) {
        // 处理特殊控制器
        if ([self isKindOfClass:[UIImagePickerController class]]) return;
        if ([self isKindOfClass:[UIVideoEditorController class]]) return;

        // 设置背景色
        self.view.backgroundColor = [UIColor blackColor];

        // 设置代理
        self.delegate = self.navigationHandler;

        // 注册控制器属性改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(propertyChangeNotification:) name:HDViewControllerPropertyChangedNotification object:nil];
    }

    [self hd_viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HDViewControllerPropertyChangedNotification object:nil];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark - Notifiaction
- (void)propertyChangeNotification:(NSNotification *)notification {
    UIViewController *vc = (UIViewController *)notification.object[@"viewController"];

    BOOL isRootVC = (vc == self.viewControllers.firstObject);

    // 手势处理
    if (vc.hd_interactivePopDisabled) {  // 禁止滑动
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.screenPanGesture];
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGesture];
    } else if (vc.hd_fullScreenPopDisabled) {  // 禁止全屏滑动，支持边缘滑动
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGesture];

        if (self.hd_transitionScale) {
            self.interactivePopGestureRecognizer.delegate = nil;
            self.interactivePopGestureRecognizer.enabled = NO;

            if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.screenPanGesture]) {
                [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.screenPanGesture];
                self.screenPanGesture.delegate = self.gestureHandler;
            }
        } else {
            self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
            self.interactivePopGestureRecognizer.delegate = self.gestureHandler;
            self.interactivePopGestureRecognizer.enabled = !isRootVC;
        }
    } else {  // 支持全屏滑动
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.screenPanGesture];

        // 给self.interactivePopGestureRecognizer.view 添加全屏滑动手势
        if (!isRootVC && ![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.panGesture]) {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
            self.panGesture.delegate = self.gestureHandler;
        }

        // 手势处理
        if (self.hd_transitionScale || self.hd_openScrollLeftPush) {
            [self.panGesture addTarget:self.navigationHandler action:@selector(panGestureAction:)];
        } else {
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            [self.panGesture addTarget:self.systemTarget action:internalAction];
        }
    }
}

#pragma mark - getter
static char kAssociatedObjectKey_screenPanGesture;
- (UIScreenEdgePanGestureRecognizer *)screenPanGesture {
    UIScreenEdgePanGestureRecognizer *panGesture = objc_getAssociatedObject(self, &kAssociatedObjectKey_screenPanGesture);
    if (!panGesture) {
        panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.navigationHandler action:@selector(panGestureAction:)];
        panGesture.edges = UIRectEdgeLeft;

        objc_setAssociatedObject(self, &kAssociatedObjectKey_screenPanGesture, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

static char kAssociatedObjectKey_panGesture;
- (UIPanGestureRecognizer *)panGesture {
    UIPanGestureRecognizer *panGesture = objc_getAssociatedObject(self, &kAssociatedObjectKey_panGesture);
    if (!panGesture) {
        panGesture = [[UIPanGestureRecognizer alloc] init];
        panGesture.maximumNumberOfTouches = 1;

        objc_setAssociatedObject(self, &kAssociatedObjectKey_panGesture, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

static char kAssociatedObjectKey_navigationHandler;
- (HDNavigationControllerDelegateHandler *)navigationHandler {
    HDNavigationControllerDelegateHandler *handler = objc_getAssociatedObject(self, &kAssociatedObjectKey_navigationHandler);
    if (!handler) {
        handler = [HDNavigationControllerDelegateHandler new];
        handler.navigationController = self;

        objc_setAssociatedObject(self, &kAssociatedObjectKey_navigationHandler, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return handler;
}

static char kAssociatedObjectKey_gestureHandler;
- (HDGestureRecognizerDelegateHandler *)gestureHandler {
    HDGestureRecognizerDelegateHandler *handler = objc_getAssociatedObject(self, &kAssociatedObjectKey_gestureHandler);
    if (!handler) {
        handler = [HDGestureRecognizerDelegateHandler new];
        handler.navigationController = self;
        handler.systemTarget = self.systemTarget;
        handler.customTarget = self.navigationHandler;

        objc_setAssociatedObject(self, &kAssociatedObjectKey_gestureHandler, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return handler;
}

- (id)systemTarget {
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    return internalTarget;
}

@end
