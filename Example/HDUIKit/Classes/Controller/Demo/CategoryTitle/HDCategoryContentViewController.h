//
//  HDCategoryContentViewController.h
//  HDUIKit_Example
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDCategoryContentViewController : HDBaseViewController <HDCategoryListContentViewDelegate>
/// 枚举
@property (nonatomic, assign) NSUInteger orderState;
@end

NS_ASSUME_NONNULL_END
