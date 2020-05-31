//
//  HDCategoryBaseCellModel.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryViewDefines.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HDCategoryBaseCellModel : NSObject
/// 索引
@property (nonatomic, assign) NSUInteger index;
/// 是否选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;
/// cell 宽度
@property (nonatomic, assign) CGFloat cellWidth;
/// cell 间距
@property (nonatomic, assign) CGFloat cellSpacing;
/// cell 宽度缩放
@property (nonatomic, assign, getter=isCellWidthZoomEnabled) BOOL cellWidthZoomEnabled;
/// cell 宽度缩放普通系数
@property (nonatomic, assign) CGFloat cellWidthNormalZoomScale;
/// cell 宽度缩放当前系数
@property (nonatomic, assign) CGFloat cellWidthCurrentZoomScale;
/// cell 宽度缩放选中系数
@property (nonatomic, assign) CGFloat cellWidthSelectedZoomScale;
/// 是否开启选中动画
@property (nonatomic, assign, getter=isSelectedAnimationEnabled) BOOL selectedAnimationEnabled;
/// 选中动画时长
@property (nonatomic, assign) NSTimeInterval selectedAnimationDuration;
/// 选中类型
@property (nonatomic, assign) HDCategoryCellSelectedType selectedType;
/// 是否正在执行动画
@property (nonatomic, assign, getter=isTransitionAnimating) BOOL transitionAnimating;
@end
