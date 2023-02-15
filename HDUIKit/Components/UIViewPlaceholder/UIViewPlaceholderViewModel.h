//
//  UIViewPlaceholderViewModel.h
//  HDUIKit
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickOnRefreshButton)(void);

@interface UIViewPlaceholderViewModel : NSObject
@property (nonatomic, strong) UIColor *backgroundColor;                        ///< 背景色
@property (nonatomic, copy) NSString *title;                                   ///< 标题
@property (nonatomic, strong) UIFont *titleFont;                               ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;                             ///< 标题颜色
@property (nonatomic, copy) NSString *image;                                   ///< 图片
@property (nonatomic, assign) BOOL scaleImage;                                 ///< 是否缩放显示图片，如果设置是需要传图片尺寸，默认 NO
@property (nonatomic, assign) CGSize imageSize;                                ///< 图片尺寸
@property (nonatomic, assign) UIEdgeInsets refreshButtonLabelEdgeInset;        ///< 刷新按钮文字内边距
@property (nonatomic, assign) BOOL needRefreshBtn;                             ///< 是否需要刷新按钮
@property (nonatomic, copy) NSString *refreshBtnTitle;                         ///< 刷新按钮标题
@property (nonatomic, strong) UIColor *refreshBtnTitleColor;                   ///< 刷新按钮标题颜色
@property (nonatomic, strong) UIFont *refreshBtnTitleFont;                     ///< 刷新按钮标题颜色
@property (nonatomic, strong) NSAttributedString *refreshBtnAttributeTitle;    ///< 带属性的标题
@property (nonatomic, strong) UIColor *refreshBtnBackgroundColor;              ///< 按钮背景色
@property (nonatomic, strong) UIColor *refreshBtnGhostColor;                   ///< 刷新按钮边框颜色 默认为 nil;
@property (nonatomic, assign) CGFloat refreshBtnBorderWidth;                   ///< 刷新按钮边框宽度 默认为 0pt
@property (nonatomic, copy) ClickOnRefreshButton clickOnRefreshButtonHandler;  ///< 点击回调

@property (nonatomic, assign) CGFloat marginInfoToImage;  ///< 信息距离图片距离
@property (nonatomic, assign) CGFloat marginBtnToInfo;    ///< 按钮距离信息距离
@end

NS_ASSUME_NONNULL_END
