//
//  HDOrderListChildViewControllerConfig.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDOrderListChildViewControllerConfig.h"

@implementation HDOrderListChildViewControllerConfig
+ (instancetype)configWithTitle:(NSString *)title vc:(HDCategoryContentViewController *)vc {
    HDOrderListChildViewControllerConfig *config = HDOrderListChildViewControllerConfig.new;
    config.title = title;
    config.vc = vc;
    return config;
}
@end
