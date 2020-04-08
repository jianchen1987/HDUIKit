//
//  HDShareImageAlertView.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDShareImageAlertViewConfig : NSObject
@property (nonatomic, strong) UIFont *titleFont;                     ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;                   ///< 标题颜色
@property (nonatomic, strong) UIFont *subTitleFont;                  ///< 子标题字体
@property (nonatomic, strong) UIColor *subTitleColor;                ///< 子标题颜色
@property (nonatomic, strong) UIFont *tipLBFont;                     ///< 提示字体
@property (nonatomic, strong) UIColor *tipLBColor;                   ///< 提示颜色
@property (nonatomic, assign) UIEdgeInsets contentViewEdgeInsets;    ///< 内容 view 内边距
@property (nonatomic, assign) CGFloat marginTitleToSubTitle;         ///< 标题和子标题间距
@property (nonatomic, assign) CGFloat marginSubTitleToImage;         ///< 子标题和图片间距
@property (nonatomic, assign) CGFloat marginImageToTip;              ///< 图片盒提示文字间距
@property (nonatomic, strong) UIFont *cancelTitleFont;               ///< 取消按钮字体
@property (nonatomic, strong) UIColor *cancelTitleColor;             ///< 取消按钮颜色
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;  ///< 取消按钮背景颜色
@property (nonatomic, assign) CGFloat buttonHeight;                  ///< 按钮高度
@property (nonatomic, assign) CGFloat containerCorner;               ///< 容器圆角
@end

@interface HDShareImageAlertView : HDActionAlertView
+ (instancetype)alertViewWithTitle:(NSString *)title subTitle:(NSString *__nullable)subTitle tipStr:(NSString *__nullable)tipStr cancelTitle:(NSString *__nullable)cancelTitle image:(UIImage *)image config:(HDShareImageAlertViewConfig *__nullable)config;
- (instancetype)initWithWithTitle:(NSString *)title subTitle:(NSString *__nullable)subTitle tipStr:(NSString *__nullable)tipStr cancelTitle:(NSString *__nullable)cancelTitle image:(UIImage *)image config:(HDShareImageAlertViewConfig *__nullable)config;
@end

NS_ASSUME_NONNULL_END
