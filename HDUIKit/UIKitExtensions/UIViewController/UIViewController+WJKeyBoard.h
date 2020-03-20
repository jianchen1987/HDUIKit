//
//  UIViewController+WJKeyBoard.h
//  ViPay
//
//  Created by VanJay on 2019/11/6.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 一行代码解决键盘遮挡 */
@interface UIViewController (WJKeyBoard)

/** 自动处理键盘遮挡方法 */
- (void)wj_addKeyBoardHandle;

/**
 根据键盘来移动的控件（可选项）
 默认是self.view改变origin.y来移动
 */
@property (nonatomic, strong) UIView *wj_needScrollView;
/** 控件所移动的总距离（只读） */
@property (nonatomic, assign, readonly) CGFloat wj_moveDistance;
/** 焦点所在的控件相对窗口的最低点（只读） */
@property (nonatomic, assign, readonly) CGFloat wj_currentEditViewBottom;
/** 焦点所在的控件 */
@property (nonatomic, strong) UIView *wj_currentEditView;

@end
