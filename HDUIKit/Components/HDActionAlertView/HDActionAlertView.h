//
//  HDActionAlertView.h
//  HDUIKit
//
//  Created by VanJay on 2019/7/31.
//  Copyright © 2019 chaos network technology. All rights reserved.

// 弹窗的父类，然后以后写弹窗就直接继承

#import <UIKit/UIKit.h>

#define TSACTIONVIEW_CONTAINER_WIDTH (310.0)  // 默认宽度

#ifndef kScreenWidth
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#endif

#ifndef kScreenHeight
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#endif

UIKIT_EXTERN const UIWindowLevel HDActionAlertViewWindowLevel;

NS_ASSUME_NONNULL_BEGIN

@class HDActionAlertView;
typedef void (^HDActionAlertViewHandler)(HDActionAlertView *alertView);
typedef void (^HDActionAlertViewStringHandler)(HDActionAlertView *alertView, NSString *string);

/** 背景效果 */
typedef NS_ENUM(NSInteger, HDActionAlertViewBackgroundStyle) {
    HDActionAlertViewBackgroundStyleSolid = 0,  ///< 渐变
    HDActionAlertViewBackgroundStyleGradient,   ///< 渐变
};

/** 动画效果 */
typedef NS_ENUM(NSInteger, HDActionAlertViewTransitionStyle) {
    HDActionAlertViewTransitionStyleSlideFromBottom = 0,  ///< 底部滑出
    HDActionAlertViewTransitionStyleFade,                 ///< 透明度变化
    HDActionAlertViewTransitionStyleBounce,               ///< 底部滑出
    HDActionAlertViewTransitionStyleDropDown,             ///< 物理动画下落
    HDActionAlertViewTransitionStyleSlideFromTop,         ///< 顶部滑出
};

@protocol TSActionAlertViewDelegate <NSObject>

@optional
/** 以下代理优先级低于 block 回调 */

/** 即将出现 */
- (void)actionAlertViewWillShow:(HDActionAlertView *)alertView;
/** 已经出现 */
- (void)actionAlertViewDidShow:(HDActionAlertView *)alertView;
/** 即将消失 */
- (void)actionAlertViewWillDismiss:(HDActionAlertView *)alertView;
/** 已经消失 */
- (void)actionAlertViewDidDismiss:(HDActionAlertView *)alertView;
/** 点击了背景 */
- (void)actionAlertViewDidTappedBackGroundView:(HDActionAlertView *)alertView;

@end

@interface HDActionAlertView : UIView

@property (weak, nonatomic) id<TSActionAlertViewDelegate> delegate;
@property (nonatomic, assign) HDActionAlertViewBackgroundStyle backgroundStyle;  // 背景效果
@property (nonatomic, assign, getter=isVisible) BOOL visible;                    // 是否正在显示
@property (nonatomic, assign) HDActionAlertViewTransitionStyle transitionStyle;
@property (nonatomic, strong) UIView *containerView;  ///< 容器视图
@property (nonatomic, weak) UIWindow *oldKeyWindow;
@property (nonatomic, assign) BOOL allowTapBackgroundDismiss;  ///< 点击背景是否隐藏
@property (nonatomic, copy) NSString *identitableString;       ///< 标志

/** 以下回调优先级高于代理 */
@property (nonatomic, copy) HDActionAlertViewHandler willShowHandler;
@property (nonatomic, copy) HDActionAlertViewHandler didShowHandler;
@property (nonatomic, copy) HDActionAlertViewHandler willDismissHandler;
@property (nonatomic, copy) HDActionAlertViewHandler didDismissHandler;
@property (nonatomic, copy) HDActionAlertViewHandler didTappedBackgroundHandler;
/**
 初始化方法,传入一个动画类型
 @param style 动画类型
 @return 初始化的对象
 */
+ (instancetype)actionAlertViewWithAnimationStyle:(HDActionAlertViewTransitionStyle)style;
- (instancetype)initWithAnimationStyle:(HDActionAlertViewTransitionStyle)style;
+ (instancetype)actionAlertViewWithCustomView:(UIView *)customView style:(HDActionAlertViewTransitionStyle)style;
- (instancetype)initWithCustomView:(UIView *)customView style:(HDActionAlertViewTransitionStyle)style;

// 展示和消失
- (void)dismiss;
- (void)dismissCompletion:(void (^__nullable)(void))completion;
- (void)show;

// 子类需要实现
/** 布局containerview的位置,就是那个看得到的视图 */
- (void)layoutContainerView;
/** 设置containerview的属性,比如圆角 */
- (void)setupContainerViewAttributes;
/** 给containerview添加子视图 */
- (void)setupContainerSubViews;
/** 设置子视图的frame */
- (void)layoutContainerViewSubViews;

// 给控制器调用的,不用管
- (void)setup;
- (void)resetTransition;
- (void)invalidateLayout;

/** 队列映射中处于不同弹窗队列的 key，子类可自定义 */
+ (NSString *)sharedMapQueueKey;

/// 获取自定义 View，不存在返回 nil
- (UIView *__nullable)getCustomView;
@end

NS_ASSUME_NONNULL_END
