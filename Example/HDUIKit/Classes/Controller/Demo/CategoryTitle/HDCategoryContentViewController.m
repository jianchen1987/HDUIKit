//
//  HDCategoryContentViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDCategoryContentViewController.h"

@interface HDCategoryContentViewController ()

@end

@implementation HDCategoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = HDRandomColor;
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
