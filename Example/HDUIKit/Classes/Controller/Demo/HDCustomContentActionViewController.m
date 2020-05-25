//
//  HDCustomContentActionViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/5/25.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDCustomContentActionViewController.h"

@interface HDCustomContentActionViewController ()

@end

@implementation HDCustomContentActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.title = @"选择退款原因";
    config.style = HDCustomViewActionViewStyleClose;
    config.contentHorizontalEdgeMargin = 0;
    const CGFloat width = kScreenWidth - config.contentHorizontalEdgeMargin * 2;

    UIView<HDCustomViewActionViewProtocol> *view = [[UIView<HDCustomViewActionViewProtocol> alloc] initWithFrame:CGRectMake(0, 0, width, 1000)];
    view.backgroundColor = UIColor.redColor;
    // [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];

    actionView.willDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {

    };
    [actionView show];
}

@end
