//
//  HDActionSheetViewConfig.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDActionSheetViewConfig : NSObject
@property (nonatomic, strong) UIColor *lineColor;           ///< 线条颜色
@property (nonatomic, assign) CGFloat lineHeight;           ///< 线条高度
@property (nonatomic, assign) UIEdgeInsets lineEdgeInsets;  ///< 线条内边距（左右生效）
@property (nonatomic, assign) CGFloat buttonHeight;         ///< 按钮高度
@property (nonatomic, assign) CGFloat containerCorner;      ///< 容器圆角
@end

NS_ASSUME_NONNULL_END
