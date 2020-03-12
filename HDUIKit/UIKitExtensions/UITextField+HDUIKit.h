//
//  UITextField+HDUIKit.h
//  HDUIKit
//
//  Created by VanJay on 2019/11/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (HDUIKit)
/**
 *  光标选择的范围
 *
 *  @return 获取光标选择的范围
 */
- (NSRange)selectedRange;

/**
 *  设置光标选择的范围
 *
 *  @param range 光标选择的范围
 */
- (void)setSelectedRange:(NSRange)range;
@end

NS_ASSUME_NONNULL_END
