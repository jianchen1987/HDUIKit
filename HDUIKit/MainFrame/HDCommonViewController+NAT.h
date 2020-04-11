//
//  HDCommonViewController+NAT.h
//  HDUIKit
//
//  Created by VanJay on 2020/3/12.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDCommonViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCommonViewController (NAT)
/** 显示 loading */
- (void)showloading;

/** 显示 loading 和 文字，支持属性文字 */
- (void)showloadingText:(id)text;

/** 关闭 loading */
- (void)dismissLoading;
@end

NS_ASSUME_NONNULL_END
