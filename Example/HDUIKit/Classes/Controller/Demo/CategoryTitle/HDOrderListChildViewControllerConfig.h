//
//  HDOrderListChildViewControllerConfig.h
//  HDUIKit_Example
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDCategoryContentViewController.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDOrderListChildViewControllerConfig : NSObject
/// 标题
@property (nonatomic, copy) NSString *title;
/// 控制器
@property (nonatomic, strong) HDCategoryContentViewController *vc;

+ (instancetype)configWithTitle:(NSString *)title vc:(HDCategoryContentViewController *)vc;

@end

NS_ASSUME_NONNULL_END
