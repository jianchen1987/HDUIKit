//
//  UITableView+HD.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (HDUIKit)

/**
 等同于 UITableView 自 iOS 11 开始新增的同名方法，但兼容 iOS 11 以下的系统使用。

 @param updates insert/delete/reload/move calls
 @param completion completion callback
 */
- (void)hd_performBatchUpdates:(void(NS_NOESCAPE ^ _Nullable)(void))updates completion:(void (^_Nullable)(BOOL finished))completion;
@end

NS_ASSUME_NONNULL_END
