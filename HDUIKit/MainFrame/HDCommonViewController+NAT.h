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

/** 关闭 loading */
- (void)dismissLoading;
@end

NS_ASSUME_NONNULL_END