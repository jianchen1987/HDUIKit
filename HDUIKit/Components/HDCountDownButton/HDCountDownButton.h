//
//  HDCountDownButton.h
//  HDUIKit
//
//  Created by VanJay on 2019/11/8.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIButton.h>

NS_ASSUME_NONNULL_BEGIN

@class HDCountDownButton;

typedef NSString *_Nullable (^CountDownChangingHandler)(HDCountDownButton *countDownButton, NSUInteger second);
typedef NSString *_Nullable (^CountDownFinishedHandler)(HDCountDownButton *countDownButton, NSUInteger second);
typedef void (^ClickedCountDownButtonHandler)(HDCountDownButton *countDownButton);
typedef void (^ClickedCountDownStateChanged)(HDCountDownButton *countDownButton, BOOL enabled);

@interface HDCountDownButton : HDUIButton
/** 倒计时改变回调，返回值设置按钮标题 */
@property (nonatomic, copy) CountDownChangingHandler countDownChangingHandler;
/** 倒计时完成回调，返回值设置按钮标题 */
@property (nonatomic, copy) CountDownFinishedHandler countDownFinishedHandler;
/** 按钮点击回调 */
@property (nonatomic, copy) ClickedCountDownButtonHandler clickedCountDownButtonHandler;
/** 按钮是否可用状态改变回调 */
@property (nonatomic, copy) ClickedCountDownStateChanged countDownStateChangedHandler;
/** 当前剩余时间秒数 */
@property (nonatomic, assign) NSInteger leftSecond;
/// 开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
/// 停止倒计时
- (void)stopCountDown;
@end

NS_ASSUME_NONNULL_END
