//
//  HDCategoryIndicatorParamsModel.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryViewDefines.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HDCategoryIndicatorParamsModel : NSObject
/// 当前选中的index
@property (nonatomic, assign) NSInteger selectedIndex;
/// 当前选中的cellFrame
@property (nonatomic, assign) CGRect selectedCellFrame;
/// 正在过渡中的两个cell，相对位置在左边的cell的index
@property (nonatomic, assign) NSInteger leftIndex;
/// 正在过渡中的两个cell，相对位置在左边的cell的frame
@property (nonatomic, assign) CGRect leftCellFrame;
/// 正在过渡中的两个cell，相对位置在右边的cell的index
@property (nonatomic, assign) NSInteger rightIndex;
/// 正在过渡中的两个cell，相对位置在右边的cell的frame
@property (nonatomic, assign) CGRect rightCellFrame;
/// 正在过渡中的两个cell，从左到右的百分比
@property (nonatomic, assign) CGFloat percent;
/// 之前选中的index
@property (nonatomic, assign) NSInteger lastSelectedIndex;
/// cell被选中类型
@property (nonatomic, assign) HDCategoryCellSelectedType selectedType;
@end
