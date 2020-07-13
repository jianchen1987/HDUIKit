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
    /*
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.title = @"选择退款原因";
    config.style = HDCustomViewActionViewStyleClose;
    config.contentHorizontalEdgeMargin = 0;
    config.shouldAddScrollViewContainer = true;
    config.needTopSepLine = false;
    const CGFloat width = kScreenWidth - config.contentHorizontalEdgeMargin * 2;

    UIView<HDCustomViewActionViewProtocol> *view = [[UIView<HDCustomViewActionViewProtocol> alloc] initWithFrame:CGRectMake(0, 0, width, 1000)];
    view.backgroundColor = UIColor.redColor;
    // [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];

    actionView.willDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {

    };
    [actionView show];
    */

    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerMinHeight = kScreenHeight * 0.3;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), kRealWidth(15), kRealWidth(15));
    config.title = @"公告";
    config.style = HDCustomViewActionViewStyleClose;
    config.iPhoneXFillViewBgColor = UIColor.whiteColor;
    config.contentHorizontalEdgeMargin = 10;
    const CGFloat width = kScreenWidth - config.contentHorizontalEdgeMargin * 2;

    UILabel *textLabel = UILabel.new;
    textLabel.text = @"公告";
    textLabel.numberOfLines = 0;
    textLabel.font = HDAppTheme.font.standard3;
    textLabel.textColor = HDAppTheme.color.G2;
    textLabel.frame = (CGRect){0, 0, [textLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)]};

    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:textLabel config:config];
    [actionView show];
}

@end
