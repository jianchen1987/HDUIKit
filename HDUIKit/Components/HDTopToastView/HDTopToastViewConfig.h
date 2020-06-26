//
//  HDTopToastViewConfig.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDTopToastViewConfig : NSObject
@property (nonatomic, strong) UIFont *titleFont;                     ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;                   ///< 标题颜色
@property (nonatomic, strong) UIFont *messageFont;                   ///< 内容字体
@property (nonatomic, strong) UIColor *messageColor;                 ///< 内容颜色
@property (nonatomic, strong) UIColor *backgroundColor;              ///< 背景颜色
@property (nonatomic, assign) UIEdgeInsets containerViewEdgeInsets;  ///< 容器内边距，默认状态栏下方开始，左右离屏幕 10
@property (nonatomic, assign) UIEdgeInsets contentViewEdgeInsets;    ///< 内容 view 内边距
@property (nonatomic, assign) CGFloat marginTitle2Message;           ///< 标题和副标题间距
@property (nonatomic, assign) CGFloat marginTitleToIcon;             ///< 标题和图标间距
@property (nonatomic, assign) CGFloat containerCorner;               ///< 容器圆角
@property (nonatomic, assign) CGFloat containerMinHeight;            ///< 容器最小高度
@property (nonatomic, assign) CGFloat iconWidth;                     ///< 图标 width，高度根据原图比例缩放
@property (nonatomic, assign) NSTimeInterval hideAfterDuration;      ///< 自动消失时间，默认自动计算
@end

NS_ASSUME_NONNULL_END
