//
//  UIButton+EventInterval.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/19.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (EventInterval)
///< 白名单，这些类不做处理
+ (void)setEventIntervalWhiteListClasses:(NSArray<NSString *> *)classes;

/** 为按钮添加点击间隔 eventTimeInterval秒 */
@property (nonatomic, assign) NSTimeInterval eventTimeInterval;
@end

NS_ASSUME_NONNULL_END
