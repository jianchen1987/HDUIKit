//
//  HDCustomViewActionViewConfig.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HDCustomViewActionViewStyle) {
    HDCustomViewActionViewStyleCancel = 0,  /// 取消
    HDCustomViewActionViewStyleClose,       /// 关闭
};

typedef NS_ENUM(NSUInteger, HDCustomViewActionViewTextAlignment) {
    HDCustomViewActionViewTextAlignmentLeft = 0,        /// 左对齐
    HDCustomViewActionViewTextAlignmentCenter,          /// 居中（边距无效）
};

NS_ASSUME_NONNULL_BEGIN

@interface HDCustomViewActionViewConfig : NSObject
@property (nonatomic, copy) NSString *title;                                                    ///< 标题，设置则为显示
@property (nonatomic, strong) UIFont *titleFont;                                                ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;                                              ///< 标题颜色
@property (nonatomic, copy) NSString *buttonTitle;                                              ///< 按钮标题
@property (nonatomic, strong) UIFont *buttonTitleFont;                                          ///< 按钮标题字体
@property (nonatomic, strong) UIColor *buttonTitleColor;                                        ///< 按钮标题颜色
@property (nonatomic, strong) UIColor *buttonBgColor;                                           ///< 按钮背景色
@property (nonatomic, strong) UIColor *iPhoneXFillViewBgColor;                                  ///< iPhoneX 系列底部填充色
@property (nonatomic, assign) CGFloat buttonHeight;                                             ///< 按钮高度
@property (nonatomic, assign) UIEdgeInsets containerViewEdgeInsets;                             ///< 容器内边距
@property (nonatomic, assign) CGFloat contentHorizontalEdgeMargin;                              ///< 内容水平方向离边距离
@property (nonatomic, assign) CGFloat marginTitleToContentView;                                 ///< 标题和内容间距
@property (nonatomic, assign) CGFloat containerCorner;                                          ///< 容器圆角
@property (nonatomic, assign) CGFloat containerMinHeight;                                       ///< 容器最小高度
@property (nonatomic, assign) CGFloat containerMaxHeight;                                       ///< 容器最大高度，默认屏幕高度80%
@property (nonatomic, assign) HDCustomViewActionViewStyle style;                                ///< 风格
@property (nonatomic, assign) BOOL scrollViewBounces;                                           ///< scrollView 是否开启 bounce，默认开启
@property (nonatomic, assign) BOOL shouldAddScrollViewContainer;                                ///< 是否应该 UIScrollView 容器，默认开启
@property (nonatomic, assign) BOOL needTopSepLine;                                              ///< 是否需要顶部分割线，默认关闭，无 title 自动隐藏
@property (nonatomic, assign) UIEdgeInsets topLineEdgeInsets;                                   ///< 顶部分割线距离边距，上下无效
@property (nonatomic, assign) CGFloat topLineHeight;                                            ///< 顶部分割线宽度
@property (nonatomic, strong) UIColor *topLineColor;                                            ///< 顶部分割线颜色
@property (nonatomic, strong) UIImage *closeImage;                                              ///< 关闭按钮图片
@property (nonatomic, assign) HDCustomViewActionViewTextAlignment textAlignment;               ///< 标题居中居左
@end

NS_ASSUME_NONNULL_END
