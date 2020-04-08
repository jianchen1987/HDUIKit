//
//  HDCustomViewActionViewConfig.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCustomViewActionViewConfig : NSObject
@property (nonatomic, copy) NSString *title;                         ///< 标题，设置则为显示
@property (nonatomic, strong) UIFont *titleFont;                     ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;                   ///< 标题颜色
@property (nonatomic, copy) NSString *buttonTitle;                   ///< 按钮标题
@property (nonatomic, strong) UIFont *buttonTitleFont;               ///< 按钮标题字体
@property (nonatomic, strong) UIColor *buttonTitleColor;             ///< 按钮标题颜色
@property (nonatomic, strong) UIColor *buttonBgColor;                ///< 按钮背景色
@property (nonatomic, assign) CGFloat buttonHeight;                  ///< 按钮高度
@property (nonatomic, assign) UIEdgeInsets containerViewEdgeInsets;  ///< 容器内边距
@property (nonatomic, assign) CGFloat marginTitleToContentView;      ///< 标题和内容间距
@property (nonatomic, assign) CGFloat containerCorner;               ///< 容器圆角
@property (nonatomic, assign) CGFloat containerMinHeight;            ///< 容器最小高度
@property (nonatomic, assign) CGFloat containerMaxHeight;            ///< 容器最大高度，默认屏幕高度80%
@end

NS_ASSUME_NONNULL_END
