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

    HDTopToastViewConfig *config = HDTopToastViewConfig.new;
    config.hideAfterDuration = 3;
    [NAT showToastWithTitle:nil content:@"库存不足" type:HDTopToastTypeSuccess config:config];
}
@end
