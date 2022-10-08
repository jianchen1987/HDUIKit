//
//  HDToastViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/6/26.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDToastViewController.h"
#import <HDUIKit/HDTopToastView.h>

@interface HDToastViewController ()

@end

@implementation HDToastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

//    [HDTips showSuccess: @"密码设置成功，请使用新密码登录" hideAfterDelay:3 iconImageName:@"icon_setPassword_success"];
    
    
    HDTopToastViewConfig *config = HDTopToastViewConfig.new;
    [NAT showToastWithTitle:@"我是很长的内容我是很长的内容我是很长的内" content:nil type:HDTopToastTypeSuccess config:config];
}
@end
