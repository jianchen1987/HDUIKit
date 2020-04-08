//
//  HDTableHeaderFootViewModel.h
//  HDUIKit
//
//  Created by VanJay on 2019/9/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HDTableHeaderFootViewRightViewAlignment) {
    HDTableHeaderFootViewRightViewAlignmentTitleLeftImageRight,
    HDTableHeaderFootViewRightViewAlignmentTitleRightImageLeft
};

@interface HDTableHeaderFootViewModel : NSObject
@property (nonatomic, strong) UIImage *image;                                              ///< 图片
@property (nonatomic, copy) NSString *title;                                               ///< 标题
@property (nonatomic, copy) NSAttributedString *attrTitle;                                 ///< 属性标题
@property (nonatomic, strong) UIColor *backgroundColor;                                    ///< 背景色
@property (nonatomic, strong) UIFont *titleFont;                                           ///< 字体
@property (nonatomic, strong) UIColor *titleColor;                                         ///< 字颜色
@property (nonatomic, copy) NSString *rightButtonTitle;                                    ///< 右边按钮标题
@property (nonatomic, strong) UIImage *rightButtonImage;                                   ///< 右边按钮图片
@property (nonatomic, strong) UIFont *rightButtonTitleFont;                                ///< 右边按钮字体
@property (nonatomic, strong) UIColor *rightButtonTitleColor;                              ///< 右边按钮字颜色
@property (nonatomic, assign) CGFloat marginToBottom;                                      ///< 文字底部距离底部间距，如果为负数则垂直居中
@property (nonatomic, assign) UIEdgeInsets edgeInsets;                                     ///< 内边距，上下不生效
@property (nonatomic, assign) CGFloat titleToImageMarin;                                   ///< 标题与图片间距
@property (nonatomic, assign) CGFloat rightTitleToImageMarin;                              ///< 按钮标题与按钮图片间距
@property (nonatomic, assign) HDTableHeaderFootViewRightViewAlignment rightViewAlignment;  ///< 右视图对齐方式
@property (nonatomic, copy) NSString *routePath;                                           ///< 路由地址

@end

NS_ASSUME_NONNULL_END
