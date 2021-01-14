//
//  HDSocialShareAlertViewConfig.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDSocialShareAlertViewConfig : NSObject
@property (nonatomic, strong) UIFont *titleFont;                     ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;                   ///< 标题颜色
@property (nonatomic, assign) UIEdgeInsets contentViewEdgeInsets;    ///< 内容 view 内边距
@property (nonatomic, assign) CGFloat marginTitleToCollectionView;   ///< 标题和 cell 容器间距
@property (nonatomic, strong) UIFont *cancelTitleFont;               ///< 取消按钮字体
@property (nonatomic, strong) UIColor *cancelTitleColor;             ///< 取消按钮颜色
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;  ///<  取消按钮背景颜色
@property (nonatomic, assign) CGFloat buttonHeight;                  ///< 按钮高度
@property (nonatomic, assign) CGFloat containerCorner;               ///< 容器圆角
@property (nonatomic, assign) CGFloat minimumLineSpacing;            ///< 行间距
@property (nonatomic, assign) float cellHeightToWidthRadio;          ///< cell 高宽比
@end

NS_ASSUME_NONNULL_END
